class MemberModel {
  final String id;
  final String name;
  final DateTime birthDate;
  final bool isLeader;

  MemberModel({
    required this.id,
    required this.name,
    required this.birthDate,
    this.isLeader = false,
  });
  bool get isBirthday {
    final now = DateTime.now();
    return birthDate.day == now.day && birthDate.month == now.month;
  }
}