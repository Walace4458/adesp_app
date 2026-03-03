import 'gabinete_enums.dart';
import 'gabinete_ids.dart';
import 'gabinete_slot.dart';

class GabinetePastorRef {
  final GabinetePastorId id;
  final String displayName;

  const GabinetePastorRef({
    required this.id,
    required this.displayName,
  });

  Map<String, dynamic> toJson() => {
        'id': id.value,
        'displayName': displayName,
      };

  static GabinetePastorRef fromJson(Map<String, dynamic> json) {
    return GabinetePastorRef(
      id: GabinetePastorId(json['id'] as String),
      displayName: json['displayName'] as String,
    );
  }
}

/// Pedido/agendamento de gabinete (domínio principal).
class GabineteRequest {
  final GabineteRequestId id;

  /// Slot confirmado (quando vira request, não depende mais do hold).
  final GabineteSlot slot;

  /// Quem pediu (member). Para admin ver “tudo”; membro vê apenas dele.
  final GabineteMemberId memberId;

  /// Se você tiver auth: userId que criou, útil para filtros/segurança.
  final String createdByUserId;

  /// Categoria/motivo.
  final String categoryId;

  /// Dados capturados no momento do pedido (snapshot),
  /// mesmo se o cadastro do membro mudar depois.
  final String memberNameSnapshot;
  final String whatsappSnapshot;

  final String? note;

  /// Política do pedido: secretaria decide ou membro escolheu pastor.
  final GabineteAssignmentPolicy assignmentPolicy;

  /// Se member escolheu pastor, fica setado.
  final GabinetePastorRef? requestedPastor;

  /// Status do pedido.
  final GabineteRequestStatus status;

  /// Audit básico.
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Admin que confirmou/cancelou/concluiu (se aplicável).
  final String? lastAdminActorUserId;

  /// Decisão oficial (apenas admin pode mudar para confirmed/canceled/completed).
  final DateTime? confirmedAt;
  final DateTime? canceledAt;
  final DateTime? completedAt;

  const GabineteRequest({
    required this.id,
    required this.slot,
    required this.memberId,
    required this.createdByUserId,
    required this.categoryId,
    required this.memberNameSnapshot,
    required this.whatsappSnapshot,
    required this.assignmentPolicy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.note,
    this.requestedPastor,
    this.lastAdminActorUserId,
    this.confirmedAt,
    this.canceledAt,
    this.completedAt,
  });

  bool get isActive =>
      status == GabineteRequestStatus.pendingAdminApproval ||
      status == GabineteRequestStatus.confirmed;

  bool get isPendingAdmin => status == GabineteRequestStatus.pendingAdminApproval;

  GabineteRequest copyWith({
    GabineteRequestId? id,
    GabineteSlot? slot,
    GabineteMemberId? memberId,
    String? createdByUserId,
    String? categoryId,
    String? memberNameSnapshot,
    String? whatsappSnapshot,
    String? note,
    GabineteAssignmentPolicy? assignmentPolicy,
    GabinetePastorRef? requestedPastor,
    GabineteRequestStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastAdminActorUserId,
    DateTime? confirmedAt,
    DateTime? canceledAt,
    DateTime? completedAt,
  }) {
    return GabineteRequest(
      id: id ?? this.id,
      slot: slot ?? this.slot,
      memberId: memberId ?? this.memberId,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      categoryId: categoryId ?? this.categoryId,
      memberNameSnapshot: memberNameSnapshot ?? this.memberNameSnapshot,
      whatsappSnapshot: whatsappSnapshot ?? this.whatsappSnapshot,
      note: note ?? this.note,
      assignmentPolicy: assignmentPolicy ?? this.assignmentPolicy,
      requestedPastor: requestedPastor ?? this.requestedPastor,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastAdminActorUserId: lastAdminActorUserId ?? this.lastAdminActorUserId,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      canceledAt: canceledAt ?? this.canceledAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.value,
        'slot': slot.toJson(),
        'memberId': memberId.value,
        'createdByUserId': createdByUserId,
        'categoryId': categoryId,
        'memberNameSnapshot': memberNameSnapshot,
        'whatsappSnapshot': whatsappSnapshot,
        'note': note,
        'assignmentPolicy': gabineteAssignmentPolicyToJson(assignmentPolicy),
        'requestedPastor': requestedPastor?.toJson(),
        'status': gabineteRequestStatusToJson(status),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'lastAdminActorUserId': lastAdminActorUserId,
        'confirmedAt': confirmedAt?.toIso8601String(),
        'canceledAt': canceledAt?.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  static GabineteRequest fromJson(Map<String, dynamic> json) {
    return GabineteRequest(
      id: GabineteRequestId(json['id'] as String),
      slot: GabineteSlot.fromJson(json['slot'] as Map<String, dynamic>),
      memberId: GabineteMemberId(json['memberId'] as String),
      createdByUserId: json['createdByUserId'] as String,
      categoryId: json['categoryId'] as String,
      memberNameSnapshot: json['memberNameSnapshot'] as String,
      whatsappSnapshot: json['whatsappSnapshot'] as String,
      note: json['note'] as String?,
      assignmentPolicy: gabineteAssignmentPolicyFromJson(json['assignmentPolicy'] as String),
      requestedPastor: (json['requestedPastor'] as Map<String, dynamic>?) != null
          ? GabinetePastorRef.fromJson(json['requestedPastor'] as Map<String, dynamic>)
          : null,
      status: gabineteRequestStatusFromJson(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastAdminActorUserId: json['lastAdminActorUserId'] as String?,
      confirmedAt: (json['confirmedAt'] as String?) != null ? DateTime.parse(json['confirmedAt'] as String) : null,
      canceledAt: (json['canceledAt'] as String?) != null ? DateTime.parse(json['canceledAt'] as String) : null,
      completedAt: (json['completedAt'] as String?) != null ? DateTime.parse(json['completedAt'] as String) : null,
    );
  }
}