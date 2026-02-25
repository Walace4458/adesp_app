import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/agenda/data/agenda_repository.dart';
import 'package:flutter_application_1/features/agenda/data/mock_agenda_repository.dart';
import 'package:flutter_application_1/features/agenda/models/agenda_event.dart';

class AgendaPage extends StatefulWidget{
  const AgendaPage({super.key});
  
  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final AgendaRepository _repo = MockAgendaRepository();

  late Future<List<AgendaEvent>> _future;

  int _weekOffset = 0; //0 semana atual, -1 passada, +1 proxima.

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchEvents();
  }

  void _reload() {
    setState(() {
      _future = _repo.fetchEvents();
    });
  }

  void _goPrevWeek () => setState(() => _weekOffset -= 1);
  void _goNextWeek () => setState(() => _weekOffset += 1);
  void _goThisWeek () => setState(() => _weekOffset = 0);

  DateTime _startOfWeekSunday(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final daySinceSunday = d.weekday % 7;
    return d.subtract(const Duration(days: 7));
  }

  List<AgendaEvent> _eventsInRange(
    List<AgendaEvent> all,
    DateTime start,
    DateTime endExclusive,
  ) {
    final filtered = all.where((e) {
      return !e.startAt.isBefore(start) && e.startAt.isBefore(endExclusive);
    }).toList();

    filtered.sort((a, b) => a.startAt.compareTo(b.startAt));
    return filtered;
  }

  List<AgendaEvent> _featured(List<AgendaEvent> all) {
    final f = all.where((e) => e.isFeatured).toList();
    f.sort((a, b) => a.startAt.compareTo(b.startAt));
    return f;
  }

  String _dowShortPt(DateTime d) {
    switch (d.weekday) {
      case DateTime.monday:
        return 'SEG';
      case DateTime.tuesday:
        return 'TER';
      case DateTime.wednesday:
        return 'QUA';
      case DateTime.thursday:
        return 'QUI';
      case DateTime.friday:
        return 'FRI';
      case DateTime.saturday:
        return 'SÁB';
      case DateTime.sunday:
        return 'DOM';
      default: 
        return '';
    }
  }

  String _monthShortPt(int month) {
    const m = [
      'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
      'jul', 'ago', 'set', 'out', 'nov', 'dez'
    ];
    return m[month - 1];
  }

  String _formatDayMonth(DateTime d) {
    return '${d.day} ${_monthShortPt(d.month)}';
  }

  String _formatTime(DateTime d) {
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String _rangeLabel(DateTime start, DateTime endInclusive) {
    return '${_dowShortPt(start)}, ${_formatDayMonth(start)} - ' 
    '${_dowShortPt(endInclusive)}, ${_formatDayMonth(endInclusive)}';
  }

    String _categoryLabel(AgendaCategory c) {
    switch (c) {
      case AgendaCategory.culto:
        return 'Culto';
      case AgendaCategory.jovens:
        return 'Jovens';
      case AgendaCategory.celula:
        return 'Célula';
      case AgendaCategory.evento:
        return 'Evento';
      case AgendaCategory.ensaio:
        return 'Ensaio';
      case AgendaCategory.outro:
        return 'Outro';
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda'),),
      body: FutureBuilder<List<AgendaEvent>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Não foi possível carregar a agenda.'),
                    const SizedBox(height: 12,),
                    ElevatedButton(onPressed: (){
                      setState(() {
                        _future = _repo.fetchEvents()
;                      });
                    }, child: const Text('Tentar novamente')),
                  ],
                ),
              ),
            );
          }
          final all = snapshot.data ?? const <AgendaEvent>[];

          final featured = _featured(all);

          final now = DateTime.now();
          final baseWeekStart = _startOfWeekSunday(now).add(Duration(days: 7 * _weekOffset));
          final baseWeekEndExclusive = _endOfWeekExclusive(baseWeekStart);
          final baseWeekEndInclusive = baseWeekEndExclusive.subtract(const Duration(days: 1));

          final weekEvents = _eventsInRange(all, baseWeekStart, baseWeekEndExclusive);

          return RefreshIndicator(
            onRefresh: () async => _reload(), 
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                //======= Destaques ======= 
                if (featured.isNotEmpty) ...[
                  Row(
                    children: [
                      Text(
                        'Em destaque'
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12,),
                  SizedBox(
                    height: 190,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: featured.length, 
                      separatorBuilder: (_, _) => const SizedBox(width: 12,),
                      itemBuilder: (context, index) {
                        final e = featured[index];
                        return _FeaturedCard(
                          title: e.title,
                          subtitle: '${_dowShortPt(e.startAt)} • ${_formatDayMonth(e.startAt)} • ${_formatTime(e.startAt)}',
                          location: e.location,
                          category: _categoryLabel(e.category),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Abrir detalhes: ${e.title}')),
                            );
                          },
                        );
                      }, 
                      ),
                  ),
                  const SizedBox(height: 24,),
                ]

                // ====== HEADER SEMANA ======
              ],
            )
            )
        }
      ),
    );
  }
}