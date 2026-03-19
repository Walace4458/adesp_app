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
}