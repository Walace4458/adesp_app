class ReportModel {
  final String id;
  final String cellId;
  final DateTime date;

  final List<String> newMembers;
  final List<String> newVisitors;

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
  });
}