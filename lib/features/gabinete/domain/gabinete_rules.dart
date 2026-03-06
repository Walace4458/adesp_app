class GabineteRules {
  static const int maxActiveRequestsPerUser = 2;
  static const int maxDaysInFuture = 30;
  static const allowedWeekdays = {
    DateTime.tuesday,
    DateTime.thursday,
    DateTime.sunday,
  };
}