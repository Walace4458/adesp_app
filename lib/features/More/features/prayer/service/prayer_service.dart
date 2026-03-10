import '../models/prayer_request.dart';

class PrayerService {
  Future<void>sendPrayer(PrayerRequest request) async {
    await Future.delayed(const Duration(microseconds: 500));
  }
}