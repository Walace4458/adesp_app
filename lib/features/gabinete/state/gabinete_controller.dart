import 'package:flutter/material.dart';

import '../models/gabinete_slot.dart';
import '../models/gabinete_request.dart';
import '../models/gabinete_enums.dart';
import '../models/gabinete_ids.dart'; // 👈 IMPORTANTE (IDs tipados)
import 'gabinete_state.dart';

class GabineteController extends ChangeNotifier {
  GabineteState _state = GabineteState.initial();
  GabineteState get state => _state;

  void _setState(GabineteState s) {
    _state = s;
    notifyListeners();
  }

  // =========================
  // INIT
  // =========================
  Future<void> init() async {}

  // =========================
  // LOAD RANGE (mock)
  // =========================
  Future<void> loadRange(DateTime start, DateTime end) async {
    _setState(_state.copyWith(rangeRequests: []));
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
  // SELEÇÃO
  // =========================
  bool selectSlot(GabineteSlot slot) {
    if (isSlotInPast(slot)) return false;
    if (isSlotBlockedByRangeRequests(slot.key)) return false;

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
  // SUBMIT REQUEST (DDD CORRETO)
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

    try {
      final now = DateTime.now();

      final request = GabineteRequest(
        // ✅ IDs tipados
        id: GabineteRequestId(now.millisecondsSinceEpoch.toString()),

        slot: slot,

        memberId: GabineteMemberId(userId),

        createdByUserId: userId,

        categoryId: categoryId,

        // ✅ snapshots
        memberNameSnapshot: name,
        whatsappSnapshot: whatsapp,

        // ✅ política padrão (ajusta se tiver outra)
        assignmentPolicy: GabineteAssignmentPolicy.adminDecides,

        status: GabineteRequestStatus.pendingAdminApproval,

        createdAt: now,
        updatedAt: now,

        note: note,
      );

      _setState(
        _state.copyWith(
          myRequests: [request, ..._state.myRequests],
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