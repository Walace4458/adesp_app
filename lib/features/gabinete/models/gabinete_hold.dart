import 'gabinete_ids.dart';

class GabineteSlotHold {
  final GabineteHoldId id;
  final String slotKey;
  final String heldByUserId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isReleased;
  final GabineteRequestId? consumedByRequestId;

  const GabineteSlotHold({
    required this.id,
    required this.slotKey,
    required this.heldByUserId,
    required this.createdAt,
    required this.expiresAt,
    required this.isReleased,
    this.consumedByRequestId,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isActive => !isReleased && !isExpired && consumedByRequestId == null;

  GabineteSlotHold copyWith({
    GabineteHoldId? id,
    String? slotKey,
    String? heldByUserId,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isReleased,
    GabineteRequestId? consumedByRequestId,
  }) {
    return GabineteSlotHold(
      id: id ?? this.id, 
      slotKey: slotKey ?? this.slotKey, 
      heldByUserId: heldByUserId ?? this.heldByUserId, 
      createdAt: createdAt ?? this.createdAt, 
      expiresAt: expiresAt ?? this.expiresAt, 
      isReleased: isReleased ?? this.isReleased,
      consumedByRequestId: consumedByRequestId ?? this.consumedByRequestId,
      );
  }

  Map<String, dynamic> toJson() => {
    'id': id.value,
    'slotKey': slotKey,
    'heldByUserId': heldByUserId,
    'createdAt': createdAt.toIso8601String(),
    'expiresAt': expiresAt.toIso8601String(),
    'isReleased': isReleased,
    'consumedByRequestId': consumedByRequestId?.value,
  };

  static GabineteSlotHold fromJson(Map<String, dynamic> json) {
    return GabineteSlotHold(
      id: GabineteHoldId(json['id'] as String),
      slotKey: json['slotKey'] as String,
      heldByUserId: json['heldByUserId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isReleased: (json['isReleased'] as bool?) ?? false,
      consumedByRequestId: (json['consumedByRequestId'] as String?) != null
          ? GabineteRequestId(json['consumedByRequestId'] as String)
          : null,
    );
  }
}