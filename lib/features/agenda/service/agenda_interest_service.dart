import '../../../core/services/api_service.dart';

class AgendaInterestService {
  const AgendaInterestService();

  Future<void> setInterested({
    required String eventId,
    required bool interested,
  }) async {
    await ApiService.post(
      '/agenda/$eventId/interesse',
      {
        'interessado': interested,
      },
    );
  }
}