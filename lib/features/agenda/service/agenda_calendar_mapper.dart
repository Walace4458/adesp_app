import 'package:flutter_application_1/features/agenda/models/agenda_event.dart';

class AgendaCalendarMapper {
  DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  Map<DateTime, List<AgendaEvent>> groupByDay(List<AgendaEvent> events) {
    final map = <DateTime, List<AgendaEvent>>{};
    for (final e in events) {
      final key = dateOnly(e.startAt);
      if (!map.containsKey(key)) {
        map[key] = [];
      }

      map[key]!.add(e);
    }

    for (final entry in map.entries) {
      entry.value.sort((a, b) => a.startAt.compareTo(b.startAt));
    }
    return map;
  }
}