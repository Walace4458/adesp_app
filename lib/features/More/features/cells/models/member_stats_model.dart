class MemberStatsModel {
  final int totalPresences;
  final int totalAbsences;
  final double presencePercentage;
  final int consecutiveAbsences;

  MemberStatsModel({
    required this.totalPresences,
    required this.totalAbsences,
    required this.presencePercentage,
    required this.consecutiveAbsences,
  });
}