import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/agenda_event.dart';
import '../../service/agenda_calendar_mapper.dart';

class AgendaMonthSheet extends StatefulWidget {
  final List<AgendaEvent> allEvents;
  final void Function(AgendaEvent event)? onEventTap;

  const AgendaMonthSheet({
    super.key,
    required this.allEvents,
    this.onEventTap,
  });

  @override
  State<AgendaMonthSheet> createState() => _AgendaMonthSheetState();
}

class _AgendaMonthSheetState extends State<AgendaMonthSheet> {
  final _mapper = AgendaCalendarMapper();

  late final Map<DateTime, List<AgendaEvent>> _byDay;

  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    // 🔥 normaliza tudo aqui UMA vez (evita loop / rebuild infinito)
    _byDay = _buildMap(widget.allEvents);

    _focusedDay = DateTime.now();
    _selectedDay = _dateOnly(DateTime.now());
  }

  // =========================
  // NORMALIZAÇÃO FORTE (IMPORTANTE)
  // =========================
  Map<DateTime, List<AgendaEvent>> _buildMap(List<AgendaEvent> events) {
    final map = <DateTime, List<AgendaEvent>>{};

    for (final e in events) {
      final key = _dateOnly(e.startAt);

      map.putIfAbsent(key, () => []);
      map[key]!.add(e);
    }

    return map;
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  List<AgendaEvent> _eventsOf(DateTime day) {
    return _byDay[_dateOnly(day)] ?? const [];
  }

  String _hhmm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final selected = _selectedDay;
    final dayEvents =
        selected == null ? const <AgendaEvent>[] : _eventsOf(selected);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // handle
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: ColorStyle.textoSecundario,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),

            // header
            Row(
              children: [
                Text(
                  'Calendário',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ColorStyle.textoPrincipal,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),

            // =========================
            // CALENDAR (CORRIGIDO)
            // =========================
            TableCalendar<AgendaEvent>(
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2035, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,

              availableGestures: AvailableGestures.horizontalSwipe,

              selectedDayPredicate: (day) =>
                  selected != null && isSameDay(selected, day),

              eventLoader: _eventsOf,

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = _dateOnly(selectedDay);
                  _focusedDay = focusedDay;
                });
              },

              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },

              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),

              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: ColorStyle.textoSecundario),
                weekendStyle: TextStyle(color: ColorStyle.textoSecundario),
              ),

              calendarStyle: CalendarStyle(
                outsideTextStyle:
                    TextStyle(color: ColorStyle.textoSecundario.withAlpha(120)),
                selectedDecoration: BoxDecoration(
                  color: ColorStyle.principal,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: ColorStyle.principal.withAlpha(120),
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
                markerSize: 6,
                markerMargin: const EdgeInsets.symmetric(horizontal: 1),

                markerDecoration: BoxDecoration(
                  color: ColorStyle.principal,
                  shape: BoxShape.circle,
                ),
              ),

              calendarBuilders: CalendarBuilders<AgendaEvent>(
                markerBuilder: (context, day, events) {
                  if(events.isEmpty) return null;

                  final dots = events.length> 3 ? 3 : events.length;

                  return Positioned(
                    bottom: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(dots, (_){
                        return Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: ColorStyle.principal,
                            shape: BoxShape.circle
                          ),
                        );
                      }),
                    ),
                  );
                }
              ),

              // 🚨 REMOVIDO markerBuilder (ele causa overflow/rebuild loop)
              // TableCalendar já lida com markers via eventLoader
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                selected == null
                    ? 'Selecione um dia'
                    : 'Eventos do dia ${selected.day}/${selected.month}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),

            const SizedBox(height: 10),

            // =========================
            // LISTA (SEM OVERFLOW)
            // =========================
            Flexible(
              child: dayEvents.isEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sem eventos neste dia.',
                        style:
                            TextStyle(color: ColorStyle.textoSecundario),
                      ),
                    )
                  : ListView.separated(
                      itemCount: dayEvents.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final e = dayEvents[i];

                        return Material(
                          color: ColorStyle.fundoSuperficie,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: widget.onEventTap == null
                                ? null
                                : () => widget.onEventTap!(e),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Text(
                                    _hhmm(e.startAt),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      e.title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}