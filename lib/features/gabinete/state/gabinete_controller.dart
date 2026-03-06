import 'package:flutter/foundation.dart';

import '../data/gabinete_repository.dart';
import '../models/gabinete_enums.dart';
import '../models/gabinete_slot.dart';
import '../service/gabinete_slot_hold_service.dart';
import 'gabinete_state.dart';
import '../domain/gabinete_request_validator.dart';
import '../domain/gabinete_rules.dart';

class GabineteController extends ChangeNotifier {
  final GabineteRepository repo;
  final GabineteSlotHoldService holdService;

  GabineteState _state = GabineteState.initial();
  GabineteState get state => _state;

  GabineteController({
    required this.repo,
    required this.holdService,
  });

  void _setState(GabineteState s) {
    _state = s;
    notifyListeners();
  }

  void clearError() {
    _setState(_state.copyWith(errorMessage: null));
  }

  // ==========
  // Bootstrap
  // ==========
  Future<void> init() async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));
    try {
      final categories = await repo.fetchCategories();
      _setState(_state.copyWith(isLoading: false, categories: categories));
    } catch (e) {
      _setState(_state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // ==========================
  // Calendário: range requests
  // ==========================
  Future<void> loadRange(DateTime start, DateTime endExclusive) async {
    try {
      final items = await repo.fetchRequestsInRange(start, endExclusive);
      _setState(_state.copyWith(rangeRequests: items));
    } catch (e) {
      _setState(_state.copyWith(errorMessage: e.toString()));
    }
  }

  // =======================
  // Slots fixos por dia
  // =======================
  List<GabineteSlot> buildFixedSlotsForDay(DateTime day) {
    DateTime at(int hour, int minute) =>
        DateTime(day.year, day.month, day.day, hour, minute);

    final slots = <GabineteSlot>[];

    // Manhã: 09:00 → 12:00 (slots de 30min)
    for (int h = 9; h < 12; h++) {
      slots.add(GabineteSlot(start: at(h, 0), endExclusive: at(h, 30)));
      slots.add(GabineteSlot(start: at(h, 30), endExclusive: at(h + 1, 0)));
    }

    // Tarde: 14:00 → 18:00 (slots de 30min)
    for (int h = 14; h < 18; h++) {
      slots.add(GabineteSlot(start: at(h, 0), endExclusive: at(h, 30)));
      slots.add(GabineteSlot(start: at(h, 30), endExclusive: at(h + 1, 0)));
    }

    return slots;
  }

  bool isDayAllowed(DateTime day) {
    return GabineteRules.allowedWeekdays.contains(day.weekday);
  }

  bool isTooFarInFuture(DateTime day) {
    final now = DateTime.now();
    final maxDate = now.add(
      const Duration(days: GabineteRules.maxDaysInFuture),
    );

    return day.isAfter(maxDate);
  }

  bool hasReachedUserLimit(String userId) {
    final active = _state.myRequests.where((r) {
      return r.status == GabineteRequestStatus.pendingAdminApproval ||
            r.status == GabineteRequestStatus.confirmed;
    }).length;

    return active >= GabineteRules.maxActiveRequestsPerUser;
  }

  bool isSlotBlockedByRangeRequests(String slotKey) {
    return _state.rangeRequests.any((r) {
      final blockedStatus =
          r.status == GabineteRequestStatus.pendingAdminApproval ||
              r.status == GabineteRequestStatus.confirmed;
      return blockedStatus && r.slot.key == slotKey;
    });
  }

    bool isSlotInPast(GabineteSlot slot) {
      final now = DateTime.now();
      return slot.start.isBefore(now);
    }

      Future<void> cancelHold(String userId) async {
        await holdService.releaseHoldIfExists(userId);
    }

  // =========
  // HOLD FLOW
  // =========
Future<void> holdSlot({
  required GabineteSlot slot,
  required String userId,
}) async {
  clearError();

  if (!isDayAllowed(slot.start)) {
    _setState(
      _state.copyWith(
        errorMessage: 'Não há gabinete nesse dia'
      ),
    );
    return;
  }

  if (isTooFarInFuture(slot.start)) {
    _setState(
      _state.copyWith(
        errorMessage: 'Não é possível agendar tão distante',
      ),
    );
    return;
  }

  if (hasReachedUserLimit(userId)) {
    _setState(
      _state.copyWith(
        errorMessage: 'Você já possui atendimentos agendados.'
      ),
    );
    return;
  }

  if (isSlotInPast(slot)) {
    _setState(_state.copyWith(errorMessage: 'Não é possível agendar em dias/horários passados.'));
    return;
  }

  if (isSlotBlockedByRangeRequests(slot.key)) {
    _setState(_state.copyWith(errorMessage: 'Esse horário já está reservado.'));
    return;
  }

  try {
    await holdService.startHold(slotKey: slot.key, userId: userId);
  } catch (e) {
    _setState(_state.copyWith(errorMessage: e.toString()));
  }
}
  // =========================
  // Criar request consumindo hold
  // =========================
Future<void> submitRequest({
  required String userId,
  required String categoryId,
  required String name,
  required String whatsapp,
  required String? note,
}) async {
  clearError();

  final hold = holdService.currentHold;

  if (hold == null) {
    _setState(
      _state.copyWith(
        errorMessage: 'Seu horário expirou. Selecione novamente.',
      ),
    );
    return;
  }

  // =========================
  // VALIDAÇÃO DE DOMÍNIO
  // =========================
  final validation = GabineteRequestValidator.validateRequest(
    name: name,
    whatsapp: whatsapp,
    categoryId: categoryId,
    note: note ?? '',
  );

  if (!validation.sucess) {
    _setState(
      _state.copyWith(errorMessage: validation.error),
    );
    return;
  }

  // =========================
  // NORMALIZAÇÃO DOS DADOS
  // =========================
  final normalizedName =
      GabineteRequestValidator.normalizeName(name);

  final normalizedWhatsapp =
      GabineteRequestValidator.normalizeWhatsapp(whatsapp);

  try {
    final req = await repo.createRequestFromHold(
      holdId: hold.id.value,
      userId: userId,
      categoryId: categoryId,
      memberName: normalizedName,
      whatsapp: normalizedWhatsapp,
      note: note,
    );

    // Atualiza "meus pedidos"
    final updatedMy = [req, ..._state.myRequests];

    _setState(_state.copyWith(myRequests: updatedMy));

    // Reload do range (pra bloquear imediatamente no calendário)
    final dayStart = DateTime(
      req.slot.start.year,
      req.slot.start.month,
      req.slot.start.day,
    );

    await loadRange(
      dayStart,
      dayStart.add(const Duration(days: 1)),
    );
  } catch (e) {
    _setState(
      _state.copyWith(errorMessage: e.toString()),
    );
  }
}
  // =============
  // Listagens
  // =============
  Future<void> loadMyRequests(String userId) async {
    try {
      final items = await repo.fetchMyRequests(userId);
      _setState(_state.copyWith(myRequests: items));
    } catch (e) {
      _setState(_state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> loadAllRequests() async {
    try {
      final items = await repo.fetchAllRequests();
      _setState(_state.copyWith(allRequests: items));
    } catch (e) {
      _setState(_state.copyWith(errorMessage: e.toString()));
    }
  }

  // =====================
  // Admin actions (teste)
  // =====================
  Future<void> adminSetStatus({
    required String requestId,
    required String adminUserId,
    required GabineteRequestStatus status,
  }) async {
    clearError();

    try {
      final updated = await repo.adminUpdateStatus(
        requestId: requestId,
        adminUserId: adminUserId,
        newStatus: status,
      );

      final all = _state.allRequests
          .map((r) => r.id.value == requestId ? updated : r)
          .toList();
      final mine = _state.myRequests
          .map((r) => r.id.value == requestId ? updated : r)
          .toList();
      final range = _state.rangeRequests
          .map((r) => r.id.value == requestId ? updated : r)
          .toList();

      _setState(
        _state.copyWith(allRequests: all, myRequests: mine, rangeRequests: range),
      );
    } catch (e) {
      _setState(_state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  void dispose() {
    holdService.dispose();
    super.dispose();
  }
}