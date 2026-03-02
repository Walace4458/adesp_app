import 'package:flutter_application_1/features/agenda/models/agenda_event.dart';

abstract class AgendaRepository {
  Future<List<AgendaEvent>> fetchEventsInRange(
    DateTime start,
    DateTime endExclusive,
  );
}