import 'package:flutter/material.dart';

import '../models/gabinete_slot.dart';
import '../models/gabinete_request.dart';
import '../models/gabinete_enums.dart';
import '../models/gabinete_ids.dart';
import 'gabinete_state.dart';

class GabineteController extends ChangeNotifier {
  GabineteState _state = GabineteState.initial();
  GabineteState get state => _state;

  void _setState(GabineteState s) {
    _state = s;
    notifyListeners();
  }

  // =========================
  // CONFIG
  // =========================
  static const int maxAppointmentsPerDay = 6;

  // =========================
  // INIT
  // =========================
  Future<void> init() async {}

  // =========================
  // MOCK DATA (SIMULA BANCO)
  // =========================
  List<GabineteRequest> _mockRequestsForDay(DateTime day) {
    DateTime at(int h) => DateTime(day.year, day.month, day.day, h);

    // 👇 simula alguns horários já ocupados
    return [
      GabineteRequest(
        id: GabineteRequestId('1'),
        slot: GabineteSlot(start: at(9), endExclusive: at(10)),
        memberId: GabineteMemberId('user1'),
        createdByUserId: 'user1',
        categoryId: 'Aconselhamento',
        memberNameSnapshot: 'João',
        whatsappSnapshot: '21999999999',
        assignmentPolicy: GabineteAssignmentPolicy.adminDecides,
        status: GabineteRequestStatus.confirmed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        note: null,
      ),
      GabineteRequest(
        id: GabineteRequestId('2'),
        slot: GabineteSlot(start: at(14), endExclusive: at(15)),
        memberId: GabineteMemberId('user2'),
        createdByUserId: 'user2',
        categoryId: 'Oração',
        memberNameSnapshot: 'Maria',
        whatsappSnapshot: '21988888888',
        assignmentPolicy: GabineteAssignmentPolicy.adminDecides,
        status: GabineteRequestStatus.pendingAdminApproval,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        note: null,
      ),
    ];
  }

  // =========================
  // LOAD RANGE
  // =========================
  Future<void> loadRange(DateTime start, DateTime end) async {
    final requests = _mockRequestsForDay(start);

    _setState(
      _state.copyWith(rangeRequests: requests),
    );
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
  // REGRAS
  // =========================
  bool isSlotInPast(GabineteSlot slot) {
    return slot.start.isBefore(DateTime.now());
  }

  bool isSlotBlockedByRangeRequests(String key) {
    return _state.rangeRequests.any((r) {
      final active =
          r.status == GabineteRequestStatus.confirmed ||
          r.status == GabineteRequestStatus.pendingAdminApproval;

      return active && r.slot.key == key;
    });
  }

  // =========================
  // MÉTRICAS
  // =========================
  int getTotalAppointmentsForDay() {
    return _state.rangeRequests.where((r) {
      return r.status == GabineteRequestStatus.confirmed ||
          r.status == GabineteRequestStatus.pendingAdminApproval;
    }).length;
  }

  int getRemainingSlotsForDay() {
    return maxAppointmentsPerDay - getTotalAppointmentsForDay();
  }

  bool isDayFull() {
    return getRemainingSlotsForDay() <= 0;
  }

  // =========================
  // SELEÇÃO
  // =========================
  bool selectSlot(GabineteSlot slot) {
    if (isSlotInPast(slot)) return false;
    if (isSlotBlockedByRangeRequests(slot.key)) return false;
    if (isDayFull()) return false;

    _setState(
      _state.copyWith(
        selectedSlot: slot,
        holdStart: DateTime.now(),
      ),
    );

    return true;
  }

  void cancelSelection() {
    _setState(
      _state.copyWith(
        selectedSlot: null,
        holdStart: null,
      ),
    );
  }

  // =========================
  // SUBMIT REQUEST
  // =========================
  Future<void> submitRequest({
    required String userId,
    required String categoryId,
    required String name,
    required String whatsapp,
    required String? note,
  }) async {
    final slot = _state.selectedSlot;

    if (slot == null) {
      _setState(_state.copyWith(
        errorMessage: 'Selecione um horário',
      ));
      return;
    }

    if (isDayFull()) {
      _setState(_state.copyWith(
        errorMessage: 'Dia já está lotado',
      ));
      return;
    }

    try {
      final now = DateTime.now();

      final request = GabineteRequest(
        id: GabineteRequestId(now.millisecondsSinceEpoch.toString()),
        slot: slot,
        memberId: GabineteMemberId(userId),
        createdByUserId: userId,
        categoryId: categoryId,
        memberNameSnapshot: name,
        whatsappSnapshot: whatsapp,
        assignmentPolicy: GabineteAssignmentPolicy.adminDecides,
        status: GabineteRequestStatus.pendingAdminApproval,
        createdAt: now,
        updatedAt: now,
        note: note,
      );

      _setState(
        _state.copyWith(
          myRequests: [request, ..._state.myRequests],
          rangeRequests: [request, ..._state.rangeRequests], // 🔥 ATUALIZA NA HORA
          selectedSlot: null,
          holdStart: null,
        ),
      );
    } catch (e) {
      _setState(
        _state.copyWith(errorMessage: e.toString()),
      );
    }
  }
}