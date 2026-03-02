import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/agenda_event.dart';
import '../../service/agenda_calendar_mapper.dart';

class AgendaMonthSheet extends StatefulWidget {
  final List<AgendaEvent> allEvents;

  /// callback opcional: quando o user toca em um evento da lista do dia
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
    _byDay = _mapper.groupByDay(widget.allEvents);
    _focusedDay = DateTime.now();
    _selectedDay = _mapper.dateOnly(DateTime.now());
  }

  List<AgendaEvent> _eventsOf(DateTime day) {
    final key = _mapper.dateOnly(day);
    return _byDay[key] ?? const <AgendaEvent>[];
  }

  String _hhmm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final selected = _selectedDay;
    final dayEvents = selected == null ? const <AgendaEvent>[] : _eventsOf(selected);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle do modal
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: ColorStyle.textoSecundario,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Text(
                  'Calendário',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorStyle.textoPrincipal,
                      ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Fechar',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),

            // Calendário (mês)
            TableCalendar<AgendaEvent>(
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2035, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              availableGestures: AvailableGestures.horizontalSwipe,
              selectedDayPredicate: (day) =>
                  selected != null && isSameDay(selected, day),
              eventLoader: _eventsOf, // <- como o calendar sabe que tem evento
              onDaySelected: (sel, foc) {
                setState(() {
                  _selectedDay = _mapper.dateOnly(sel);
                  _focusedDay = foc;
                });
              },
              onPageChanged: (foc) => _focusedDay = foc,
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: ColorStyle.textoPrincipal,
                    ),
                leftChevronIcon: const Icon(Icons.chevron_left_rounded),
                rightChevronIcon: const Icon(Icons.chevron_right_rounded),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: ColorStyle.textoSecundario,
                      fontWeight: FontWeight.w700,
                    ),
                weekendStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: ColorStyle.textoSecundario,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              calendarStyle: CalendarStyle(
                outsideTextStyle:
                    TextStyle(color: ColorStyle.textoSecundario.withAlpha(120)),
                weekendTextStyle: TextStyle(color: ColorStyle.textoPrincipal),
                defaultTextStyle: TextStyle(color: ColorStyle.textoPrincipal),
                selectedDecoration: BoxDecoration(
                  color: ColorStyle.principal,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: ColorStyle.principal.withAlpha(110),
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
                markerDecoration: BoxDecoration(
                  color: ColorStyle.principal,
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders<AgendaEvent>(
                // bolinhas (marcadores) por dia
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) return null;
                  final count = events.length;

                  // até 3 bolinhas, simples e leve
                  final dots = count > 3 ? 3 : count;
                  return Positioned(
                    bottom: 4,
                    child: Row(
                      children: List.generate(dots, (_) {
                        return Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 1.2),
                          decoration: BoxDecoration(
                            color: ColorStyle.principal,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Lista simples do dia
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                selected == null
                    ? 'Selecione um dia'
                    : 'Eventos do dia ${selected.day.toString().padLeft(2, '0')}/${selected.month.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: ColorStyle.textoPrincipal,
                    ),
              ),
            ),
            const SizedBox(height: 10),

            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: dayEvents.isEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sem eventos neste dia.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorStyle.textoSecundario,
                            ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: dayEvents.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _hhmm(e.startAt),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: ColorStyle.textoPrincipal,
                                        ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      e.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: ColorStyle.textoPrincipal,
                                          ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: ColorStyle.textoSecundario,
                                  ),
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