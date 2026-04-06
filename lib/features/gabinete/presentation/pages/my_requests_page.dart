import 'package:flutter/foundation.dart';

import '../../data/gabinete_repository.dart';
import '../../models/gabinete_enums.dart';
import '../../models/gabinete_slot.dart';
import '../../models/gabinete_request.dart';
import '../../service/gabinete_slot_hold_service.dart';
import '../../state/gabinete_state.dart';
import '../../domain/gabinete_request_validator.dart';
import '../../domain/gabinete_rules.dart';

class GabineteController extends ChangeNotifier {
  final GabineteRepository repo;
  final GabineteSlotHoldService holdService;

  GabineteState _state = GabineteState.initial();
  GabineteState get state => _state;

  GabineteSlot? _selectedSlot;
  GabineteSlot? get selectedSlot => _selectedSlot;

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

  // =========================
  // INIT
  // =========================
  Future<void> init() async {
    _setState(_state.copyWith(isLoading: true));

    try {
      final categories = await repo.fetchCategories();

      _setState(_state.copyWith(
        isLoading: false,
        categories: categories,
      ));
    } catch (e) {
      _setState(_state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // =========================
  // LOAD RANGE
  // =========================
  Future<void> loadRange(DateTime start, DateTime endExclusive) async {
    try {
      final items = await repo.fetchRequestsInRange(start, endExclusive);
      _setState(_state.copyWith(rangeRequests: items));
    } catch (e) {
      _setState(_state.copyWith(errorMessage: e.toString()));
    }
  }

  // =========================
  // LOAD MY REQUESTS
  // =========================
  Future<void> loadMyRequests(String userId) async {
    try {
      final items = await repo.fetchMyRequests(userId);
      _setState(_state.copyWith(myRequests: items));
    } catch (e) {
      _setState(_state.copyWith(errorMessage: e.toString()));
    }
  }

  // =========================
  // SLOTS
  // =========================
  List<GabineteSlot> buildFixedSlotsForDay(DateTime day) {
    DateTime at(int h) => DateTime(day.year, day.month, day.day, h);

    final slots = <GabineteSlot>[];

    for (int h = 9; h < 12; h++) {
      slots.add(GabineteSlot(start: at(h), endExclusive: at(h + 1)));
    }

    for (int h = 14; h < 18; h++) {
      slots.add(GabineteSlot(start: at(h), endExclusive: at(h + 1)));
    }

    return slots;
  }

  // =========================
  // RULES
  // =========================
  bool isDayAllowed(DateTime day) {
    return GabineteRules.allowedWeekdays.contains(day.weekday);
  }

  bool isTooFarInFuture(DateTime day) {
    final max = DateTime.now()
        .add(const Duration(days: GabineteRules.maxDaysInFuture));
    return day.isAfter(max);
  }

  bool isSlotInPast(GabineteSlot slot) {
    return slot.start.isBefore(DateTime.now());
  }

  bool isSlotOccupied(String slotKey) {
    return _state.rangeRequests.any((r) {
      final active =
          r.status == GabineteRequestStatus.pendingAdminApproval ||
          r.status == GabineteRequestStatus.confirmed;

      return active && r.slot.key == slotKey;
    });
  }

  // =========================
  // SELECT SLOT (COM HOLD)
  // =========================
  Future<bool> selectSlot({
    required GabineteSlot slot,
    required String userId,
  }) async {
    clearError();

    if (isSlotInPast(slot)) return false;
    if (isSlotOccupied(slot.key)) return false;

    try {
      await holdService.startHold(
        slotKey: slot.key,
        userId: userId,
      );

      _selectedSlot = slot;
      notifyListeners();

      return true;
    } catch (e) {
      _setState(_state.copyWith(errorMessage: e.toString()));
      return false;
    }
  }

  Future<void> cancelSelection(String userId) async {
    await holdService.releaseHoldIfExists(userId);
    _selectedSlot = null;
    notifyListeners();
  }

  // =========================
  // SUBMIT (CORRIGIDO)
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
      _setState(_state.copyWith(
        errorMessage: 'Seu horário expirou. Selecione novamente.',
      ));
      return;
    }

    final validation = GabineteRequestValidator.validateRequest(
      name: name,
      whatsapp: whatsapp,
      categoryId: categoryId,
      note: note ?? '',
    );

    if (!validation.sucess) {
      _setState(_state.copyWith(errorMessage: validation.error));
      return;
    }

    try {
      final req = await repo.createRequestFromHold(
        holdId: hold.id.value,
        userId: userId,
        categoryId: categoryId,
        memberName: name,
        whatsapp: whatsapp,
        note: note,
      );

      final updated = [req, ..._state.myRequests];

      _setState(_state.copyWith(myRequests: updated));

      await cancelSelection(userId);
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