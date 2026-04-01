class GroupModel {
  final String id;
  final String name;
  final String description;
  final String role;
  final List<String> memberNames;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.role,
    required this.memberNames,
  });
}