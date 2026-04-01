class FollowUpModel {
  final String id; // 🔥 necessário
  final String memberId;
  final String memberName; // 🔥 necessário pra UI
  final String reason;
  final DateTime createdAt;
  bool isDone;

  FollowUpModel({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.reason,
    required this.createdAt,
    this.isDone = false,
  });
}