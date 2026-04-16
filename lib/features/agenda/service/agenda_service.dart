import '../../../core/services/api_service.dart';

class AgendaService {
  // =========================
  // 📅 BUSCAR AGENDA
  // =========================
  static Future<List<dynamic>> getAgenda() async {
    try {
      print('📡 Chamando agenda...');

      final data = await ApiService.get('/agenda');

      print('✅ Resposta agenda: $data');

      if (data is List) {
        return data;
      } else {
        throw Exception('Resposta da API não é uma lista');
      }
    } catch (e) {
      print('❌ ERRO AGENDA: $e');
      throw Exception('Erro ao buscar agenda');
    }
  }

  // =========================
  // ❤️ INTERESSE
  // =========================
  static Future<void> setInteresse(String eventId) async {
    try {
      print('❤️ Marcando interesse no evento: $eventId');

      await ApiService.post(
        '/agenda/$eventId/interesse',
        {},
      );

      print('✅ Interesse enviado com sucesso');
    } catch (e) {
      print('❌ ERRO INTERESSE: $e');
      throw Exception('Erro ao marcar interesse');
    }
  }

  // =========================
  // ✅ PRESENÇA
  // =========================
  static Future<void> setPresenca(String eventId) async {
    try {
      print('✅ Confirmando presença no evento: $eventId');

      await ApiService.post(
        '/agenda/$eventId/presenca',
        {},
      );

      print('✅ Presença confirmada com sucesso');
    } catch (e) {
      print('❌ ERRO PRESENÇA: $e');
      throw Exception('Erro ao confirmar presença');
    }
  }
}