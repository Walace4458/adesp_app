import 'package:flutter/material.dart';

class GabineteCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onSelectDate;

  const GabineteCalendar({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    final days = _generateCalendarDays(selectedDate);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;

        // 🔥 ALTURA DINÂMICA (EVITA OVERFLOW EM QUALQUER CELULAR)
        final headerHeight = 40.0;
        final weekHeight = 20.0;
        final spacing = 8.0;

        final gridHeight =
            totalHeight - headerHeight - weekHeight - spacing;

        return Column(
          children: [
            // =========================
            // HEADER COM NAVEGAÇÃO
            // =========================
            SizedBox(
              height: headerHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        final prevMonth = DateTime(
                          selectedDate.year,
                          selectedDate.month - 1,
                          1,
                        );
                        onSelectDate(prevMonth);
                      },
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white),
                    ),
                    Text(
                      "${_monthName(selectedDate.month)} ${selectedDate.year}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        final nextMonth = DateTime(
                          selectedDate.year,
                          selectedDate.month + 1,
                          1,
                        );
                        onSelectDate(nextMonth);
                      },
                      icon: const Icon(Icons.chevron_right,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            // =========================
            // DIAS DA SEMANA
            // =========================
            SizedBox(
              height: weekHeight,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: const [
                  _WeekDay("D"),
                  _WeekDay("S"),
                  _WeekDay("T"),
                  _WeekDay("Q"),
                  _WeekDay("Q"),
                  _WeekDay("S"),
                  _WeekDay("S"),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // =========================
            // GRID RESPONSIVO
            // =========================
            SizedBox(
              height: gridHeight,
              child: GridView.builder(
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: days.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemBuilder: (_, i) {
                  final day = days[i];

                  final now = DateTime.now();
                  final today = DateTime(
                      now.year, now.month, now.day);

                  final isPast = day.date.isBefore(today);
                  final isSelected =
                      _isSameDay(day.date, selectedDate);
                  final isCurrentMonth = day.isCurrentMonth;

                  final isGabineteDay =
                      day.date.weekday == DateTime.tuesday ||
                          day.date.weekday ==
                              DateTime.thursday;

                  Color textColor;
                  Color? dotColor;

                  if (!isCurrentMonth) {
                    textColor = Colors.white24;
                  } else if (isPast) {
                    textColor = Colors.white38;
                    dotColor = isGabineteDay
                        ? Colors.grey
                        : null;
                  } else {
                    textColor = Colors.white;
                    if (isGabineteDay) {
                      dotColor = Colors.deepPurple;
                    }
                  }

                  return GestureDetector(
                    onTap: (isCurrentMonth && !isPast)
                        ? () => onSelectDate(day.date)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.deepPurple
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            '${day.date.day}',
                            style: TextStyle(
                              fontSize: 11,
                              color: textColor,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (dotColor != null)
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<_CalendarDay> _generateCalendarDays(
      DateTime base) {
    final firstDay =
        DateTime(base.year, base.month, 1);
    final firstWeekday = firstDay.weekday % 7;

    final start =
        firstDay.subtract(Duration(days: firstWeekday));

    return List.generate(42, (i) {
      final date = start.add(Duration(days: i));
      return _CalendarDay(
        date: date,
        isCurrentMonth: date.month == base.month,
      );
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  String _monthName(int month) {
    const months = [
      '',
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return months[month];
  }
}

class _CalendarDay {
  final DateTime date;
  final bool isCurrentMonth;

  _CalendarDay({
    required this.date,
    required this.isCurrentMonth,
  });
}

class _WeekDay extends StatelessWidget {
  final String label;

  const _WeekDay(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 10,
      ),
    );
  }
}