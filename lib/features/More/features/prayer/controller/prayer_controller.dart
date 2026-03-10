import '../models/prayer_request.dart';
import '../service/prayer_service.dart';

class PrayerController {
  final PrayerService service;

  PrayerController(this.service);

  Future<void>submitPrayer({
    required String message,
    required bool anonymous,
  }) async {
    
    final request = PrayerRequest(
      message: message, 
      anonymous: anonymous, 
      createdAt: DateTime.now(),
    );

    await service.sendPrayer(request);
  }
}