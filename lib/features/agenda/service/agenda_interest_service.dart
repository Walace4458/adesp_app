class AgendaInterestService {
  const AgendaInterestService();

  /// Hoje: stub (retorna true).
  /// Amanhã: aqui você faz POST/DELETE na sua API.
  Future<bool> setInterested({
    required String eventId,
    required bool interested,
  }) async {
    // TODO: implementar chamada real ao backend.
    // Ex: POST /events/{id}/interest  ou DELETE /events/{id}/interest
    await Future.delayed(const Duration(milliseconds: 250));
    return true;
  }
}