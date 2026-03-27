class ReportModel {
  final String id;
  final String cellId;
  final DateTime date;

  final List<String> newMembers;
  final List<String> newVisitors;

  final List<String> presentMemberIds;

  final String description;

  final bool hadContribution;
  final double? contributionValue;

  ReportModel({
    required this.id,
    required this.cellId,
    required this.date,
    required this.newMembers,
    required this.newVisitors,
    required this.description,
    required this.hadContribution,
    this.contributionValue,
    this.presentMemberIds = const []
  });
}

class Report {
  final String id;
  final DateTime date;

  // JÁ EXISTENTES (mantém)
  final int totalPresent;
  final int visitors;

  // NOVO (ESSENCIAL)
  final List<String> presentMemberIds;

  // FUTURO (opcional, mas já deixa pronto)
  final List<String> visitorIds;

  Report({
    required this.id,
    required this.date,
    required this.totalPresent,
    required this.visitors,
    this.presentMemberIds = const [],
    this.visitorIds = const [],
  });
}