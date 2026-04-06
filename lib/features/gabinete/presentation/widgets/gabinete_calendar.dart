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

    return Column(
      mainAxisSize: MainAxisSize.min, // 🔥 NÃO EXPANDE INFINITO
      children: [
        // =========================
        // HEADER (MÊS)
        // =========================
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            "${_monthName(selectedDate.month)} ${selectedDate.year}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // =========================
        // DIAS DA SEMANA
        // =========================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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

        const SizedBox(height: 6),

        // =========================
        // GRID
        // =========================
        Expanded( // 🔥 AGORA ELE SE LIMITA AO TAMANHO DO PAI
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1, // 🔥 QUADRADO PERFEITO
            ),
            itemBuilder: (_, i) {
              final day = days[i];

              final isSelected = _isSameDay(day.date, selectedDate);
              final isCurrentMonth = day.isCurrentMonth;

              final isAvailable =
                  day.date.weekday == DateTime.tuesday ||
                  day.date.weekday == DateTime.thursday;

              return GestureDetector(
                onTap: isCurrentMonth
                    ? () => onSelectDate(day.date)
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.deepPurple
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${day.date.day}',
                        style: TextStyle(
                          fontSize: 12, // 🔥 menor pra caber melhor
                          color: isCurrentMonth
                              ? Colors.white
                              : Colors.white30,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),

                      const SizedBox(height: 2),

                      if (isAvailable && isCurrentMonth)
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Colors.deepPurple,
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
  }

  // =========================
  // GERA CALENDÁRIO
  // =========================
  List<_CalendarDay> _generateCalendarDays(DateTime base) {
    final firstDay = DateTime(base.year, base.month, 1);
    final firstWeekday = firstDay.weekday % 7;

    final start = firstDay.subtract(Duration(days: firstWeekday));

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

// =========================
// MODEL
// =========================
class _CalendarDay {
  final DateTime date;
  final bool isCurrentMonth;

  _CalendarDay({
    required this.date,
    required this.isCurrentMonth,
  });
}

// =========================
// WEEK DAY
// =========================
class _WeekDay extends StatelessWidget {
  final String label;

  const _WeekDay(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 11,
      ),
    );
  }
}