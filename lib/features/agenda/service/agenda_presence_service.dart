import '../../../core/services/api_service.dart';

class AgendaPresenceService {
  const AgendaPresenceService();

  Future<void> setPresenca({
    required String eventId,
    required bool confirmed,
  }) async {
    await ApiService.post(
      '/agenda/$eventId/presenca',
       {
        'confirmado': confirmed,
      },
    );
  }
}