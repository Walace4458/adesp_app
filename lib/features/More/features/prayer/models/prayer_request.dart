class PrayerRequest {
  final String message;
  final bool anonymous;
  final DateTime createdAt;

  PrayerRequest({
    required this.message,
    required this.anonymous,
    required this.createdAt,
  });
}