import 'dart:math';

import '../models/gabinete_category.dart';
import '../models/gabinete_enums.dart';
import '../models/gabinete_hold.dart';
import '../models/gabinete_ids.dart';
import '../models/gabinete_request.dart';
import '../models/gabinete_slot.dart';
import 'gabinete_repository.dart';

class GabineteRepoException implements Exception {
  final String message;
  GabineteRepoException(this.message);
  @override
  String toString() => message;
}

class MockGabineteRepository implements GabineteRepository {
  final _rand = Random();

  final List<GabineteCategory> _categories = const [
    GabineteCategory(id: 'aconselhamento', label: 'Aconselhamento', sortOrder: 1),
    GabineteCategory(id: 'oracao', label: 'Oração', sortOrder: 2),
    GabineteCategory(id: 'discipulado', label: 'Discipulado', sortOrder: 3),
    GabineteCategory(id: 'familia', label: 'Família', sortOrder: 4),
  ];

  // "DB"
  final Map<String, GabineteSlotHold> _holdsById = {};
  final Map<String, String> _activeHoldIdBySlotKey = {}; // slotKey -> holdId (apenas ativos)
  final Map<String, GabineteRequest> _requestsById = {};

  // util
  String _newId(String prefix) =>
      '${prefix}_${DateTime.now().microsecondsSinceEpoch}_${_rand.nextInt(9999)}';

  void _cleanupExpiredHolds() {
    final now = DateTime.now();
    final expiredHoldIds = <String>[];

    _holdsById.forEach((id, hold) {
      final isExpired = now.isAfter(hold.expiresAt);
      if (isExpired && hold.consumedByRequestId == null && !hold.isReleased) {
        expiredHoldIds.add(id);
      }
    });

    for (final id in expiredHoldIds) {
      final hold = _holdsById[id]!;
      _holdsById[id] = hold.copyWith(isReleased: true);

      final current = _activeHoldIdBySlotKey[hold.slotKey];
      if (current == id) _activeHoldIdBySlotKey.remove(hold.slotKey);
    }
  }

  bool _isSlotBlockedByRequest(String slotKey) {
    for (final r in _requestsById.values) {
      if (r.slot.key == slotKey) {
        if (r.status == GabineteRequestStatus.pendingAdminApproval ||
            r.status == GabineteRequestStatus.confirmed) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Future<List<GabineteCategory>> fetchCategories() async {
    return _categories.where((c) => c.isActive).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Future<List<GabineteRequest>> fetchRequestsInRange(
    DateTime start,
    DateTime endExclusive,
  ) async {
    final results = _requestsById.values.where((r) {
      final s = r.slot.start;
      return !s.isBefore(start) && s.isBefore(endExclusive);
    }).toList()
      ..sort((a, b) => a.slot.start.compareTo(b.slot.start));

    return results;
  }

  @override
  Future<List<GabineteRequest>> fetchMyRequests(String userId) async {
    final results = _requestsById.values
        .where((r) => r.createdByUserId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return results;
  }

  @override
  Future<List<GabineteRequest>> fetchAllRequests() async {
    final results = _requestsById.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }

  @override
  Future<GabineteSlotHold> createHold({
    required String slotKey,
    required String userId,
    required Duration ttl,
  }) async {
    _cleanupExpiredHolds();

    // 1) Se já existe request bloqueando, não cria hold
    if (_isSlotBlockedByRequest(slotKey)) {
      throw GabineteRepoException('Esse horário já está reservado.');
    }

    // 2) Se já existe hold ativo nesse slot, checa se é do mesmo usuário
    final existingHoldId = _activeHoldIdBySlotKey[slotKey];
    if (existingHoldId != null) {
      final existing = _holdsById[existingHoldId];
      if (existing != null && existing.isActive) {
        if (existing.heldByUserId == userId) {
          return existing; // reuso
        }
        throw GabineteRepoException(
          'Esse horário está sendo selecionado por outra pessoa. Tente outro.',
        );
      } else {
        _activeHoldIdBySlotKey.remove(slotKey);
      }
    }

    final now = DateTime.now();
    final hold = GabineteSlotHold(
      id: GabineteHoldId(_newId('hold')),
      slotKey: slotKey,
      heldByUserId: userId,
      createdAt: now,
      expiresAt: now.add(ttl),
      isReleased: false,
      consumedByRequestId: null,
    );

    _holdsById[hold.id.value] = hold;
    _activeHoldIdBySlotKey[slotKey] = hold.id.value;

    return hold;
  }

  @override
  Future<void> releaseHold({
    required String holdId,
    required String userId,
  }) async {
    _cleanupExpiredHolds();

    final hold = _holdsById[holdId];
    if (hold == null) return;

    if (hold.heldByUserId != userId) {
      throw GabineteRepoException('Você não pode liberar um horário que não é seu.');
    }

    if (hold.consumedByRequestId != null) {
      return; // já virou request
    }

    _holdsById[holdId] = hold.copyWith(isReleased: true);

    final current = _activeHoldIdBySlotKey[hold.slotKey];
    if (current == holdId) _activeHoldIdBySlotKey.remove(hold.slotKey);
  }

  @override
  Future<GabineteRequest> createRequestFromHold({
    required String holdId,
    required String userId,
    required String categoryId,
    required String memberName,
    required String whatsapp,
    required String? note,
  }) async {
    _cleanupExpiredHolds();

    final hold = _holdsById[holdId];
    if (hold == null) {
      throw GabineteRepoException('Esse horário expirou. Selecione novamente.');
    }

    if (hold.heldByUserId != userId) {
      throw GabineteRepoException('Esse horário não está reservado para você.');
    }

    if (!hold.isActive) {
      throw GabineteRepoException('Esse horário expirou. Selecione novamente.');
    }

    if (_isSlotBlockedByRequest(hold.slotKey)) {
      throw GabineteRepoException('Esse horário já foi reservado.');
    }

    // slotKey = "startIso__endIso"
    final parts = hold.slotKey.split('__');
    if (parts.length != 2) {
      throw GabineteRepoException('Slot inválido.');
    }

    final slot = GabineteSlot(
      start: DateTime.parse(parts[0]),
      endExclusive: DateTime.parse(parts[1]),
    );

    final now = DateTime.now();
    final requestId = GabineteRequestId(_newId('req'));

    final cleanedName = memberName.trim();
    final cleanedWhats = whatsapp.trim();
    final cleanedNote = (note == null || note.trim().isEmpty) ? null : note.trim();

    final request = GabineteRequest(
      id: requestId,
      slot: slot,
      memberId: GabineteMemberId(_newId('member')), // mock: depois liga no MemberService
      createdByUserId: userId,
      categoryId: categoryId,
      memberNameSnapshot: cleanedName,
      whatsappSnapshot: cleanedWhats,
      note: cleanedNote,

      // App NÃO escolhe pastor. Painel web decide.
      assignmentPolicy: GabineteAssignmentPolicy.adminDecides,
      requestedPastor: null,

      status: GabineteRequestStatus.pendingAdminApproval,
      createdAt: now,
      updatedAt: now,
      lastAdminActorUserId: null,
      confirmedAt: null,
      canceledAt: null,
      completedAt: null,
    );

    _requestsById[request.id.value] = request;

    // Consome hold
    _holdsById[holdId] = hold.copyWith(consumedByRequestId: requestId);

    final current = _activeHoldIdBySlotKey[hold.slotKey];
    if (current == holdId) _activeHoldIdBySlotKey.remove(hold.slotKey);

    return request;
  }

  @override
  Future<GabineteRequest> adminUpdateStatus({
    required String requestId,
    required String adminUserId,
    required GabineteRequestStatus newStatus,
  }) async {
    final req = _requestsById[requestId];
    if (req == null) {
      throw GabineteRepoException('Pedido não encontrado.');
    }

    final current = req.status;

    bool allowed = false;
    if (newStatus == GabineteRequestStatus.confirmed) {
      allowed = current == GabineteRequestStatus.pendingAdminApproval;
    } else if (newStatus == GabineteRequestStatus.cancelled) {
      allowed = current == GabineteRequestStatus.pendingAdminApproval ||
          current == GabineteRequestStatus.confirmed;
    } else if (newStatus == GabineteRequestStatus.completed) {
      allowed = current == GabineteRequestStatus.confirmed;
    } else {
      allowed = false;
    }

    if (!allowed) {
      throw GabineteRepoException('Transição inválida: $current -> $newStatus');
    }

    final now = DateTime.now();

    final updated = req.copyWith(
      status: newStatus,
      updatedAt: now,
      lastAdminActorUserId: adminUserId,
      confirmedAt: newStatus == GabineteRequestStatus.confirmed ? now : req.confirmedAt,
      canceledAt: newStatus == GabineteRequestStatus.cancelled ? now : req.canceledAt,
      completedAt: newStatus == GabineteRequestStatus.completed ? now : req.completedAt,
    );

    _requestsById[requestId] = updated;
    return updated;
  }
}