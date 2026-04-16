import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/features/agenda/models/agenda_event.dart';
import 'package:flutter_application_1/features/agenda/service/agenda_presence_store.dart';
import 'package:flutter_application_1/features/agenda/ui/sheets/agenda_month_sheet.dart';
import 'package:flutter_application_1/features/agenda/ui/sheets/agenda_event_datails_sheet.dart';
import 'package:flutter_application_1/features/agenda/service/agenda_interest_service.dart';
import 'package:flutter_application_1/features/agenda/service/agenda_interest_store.dart';
import 'package:flutter_application_1/features/agenda/service/agenda_service.dart';
import 'package:flutter_application_1/features/agenda/service/agenda_presence_service.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final _presenceStore = AgendaPresenceStore();
  Set<String> _confirmedIds = <String>{};

  final _presenceService = const AgendaPresenceService();

  final _interestStore = AgendaInterestStore();
  final _interestService = const AgendaInterestService();

  Set<String> _interestedIds = <String>{};

  late Future<_AgendaCache> _futureCache;

  int _weekOffset = 0;

  @override
  void initState() {
    super.initState();
    _reload();

    _interestStore.load().then((ids) {
      if (!mounted) return;
      setState(() => _interestedIds = ids);
    });

    _presenceStore.load().then((ids){
      if (!mounted) return;
      setState(() => _confirmedIds = ids);
    });
  }

  // =========================
  // CACHE
  // =========================
  Future<_AgendaCache> _fetchCache() async {
    final data = await AgendaService.getAgenda();

    final events = data.map<AgendaEvent>((e) {
      final title = e['titulo'] ?? '';

      return AgendaEvent(
        id: e['id'].toString(),
        title: title,
        startAt: DateTime.parse(e['data']).toLocal(),
        location: e['local'] ?? 'Igreja',
        description: e['descricao'] ?? '',
        category: _mapCategory(title),
        isFeatured: e['is_featured'] == true,
        imageUrl: e['image_url'],
      );
    }).toList();

    return _AgendaCache(events);
  }

  void _reload() {
    _futureCache = _fetchCache();
    setState(() {});
  }

  // =========================
  // FILTERS
  // =========================
  List<AgendaEvent> _weekEvents(List<AgendaEvent> all) {
    final now = DateTime.now();
    final start =
        _startOfWeekSunday(now).add(Duration(days: 7 * _weekOffset));
    final end = _endOfWeekExclusive(start);

    return all
        .where((e) => e.startAt.isAfter(start) && e.startAt.isBefore(end))
        .toList();
  }

  List<AgendaEvent> _featured(List<AgendaEvent> all) {
    final f = all.where((e) => e.isFeatured).toList();
    f.sort((a, b) => a.startAt.compareTo(b.startAt));
    return f;
  }

  // =========================
  // WEEK NAV
  // =========================
  void _goPrevWeek() => setState(() => _weekOffset--);
  void _goNextWeek() => setState(() => _weekOffset++);

  // =========================
  // INTERACTIONS
  // =========================
  bool _isInterested(String id) => _interestedIds.contains(id);

  Future<void> _toggleInterest(String id) async {
    final now = !_interestedIds.contains(id);

    setState(() {
      now ? _interestedIds.add(id) : _interestedIds.remove(id);
    });

    await _interestStore.save(_interestedIds);
    await _interestService.setInterested(eventId: id, interested: now);
  }

  void _openDetails(AgendaEvent e) {
    AgendaEventDetailsSheet.show(
      context,
      event: e,
      isConfirmed: _confirmedIds.contains(e.id),
      onPresenceConfirmed: () async {
        final alreadyConfirmed = _confirmedIds.contains(e.id);
      
      try {
        await _presenceService.setPresenca(
          eventId: e.id,
          confirmed: !alreadyConfirmed,
        );

        setState(() {
          alreadyConfirmed
            ? _confirmedIds.remove(e.id)
            : _confirmedIds.add(e.id);
        });

        await _presenceStore.save(_confirmedIds);
      } catch (err) {
        print('ERRO PRESENÇA: $err');
      }});
  }

  // =========================
  // HELPERS
  // =========================
  DateTime _startOfWeekSunday(DateTime d) {
    final date = DateTime(d.year, d.month, d.day);
    return date.subtract(Duration(days: d.weekday % 7));
  }

  DateTime _endOfWeekExclusive(DateTime start) =>
      start.add(const Duration(days: 7));

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  String _dowShortPt(DateTime d) {
    const days = ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB'];
    return days[d.weekday % 7];
  }

  String _monthShort(int m) => [
        'jan','fev','mar','abr','mai','jun',
        'jul','ago','set','out','nov','dez'
      ][m - 1];

  String _formatDayMonth(DateTime d) =>
      '${d.day} ${_monthShort(d.month)}';

  String _rangeLabel(DateTime a, DateTime b) =>
      '${_dowShortPt(a)}, ${_formatDayMonth(a)} — '
      '${_dowShortPt(b)}, ${_formatDayMonth(b)}';

  AgendaCategory _mapCategory(String title) {
    final t = title.toLowerCase();

    if (t.contains('culto')) return AgendaCategory.culto;
    if (t.contains('jovem')) return AgendaCategory.jovens;
    if (t.contains('célula')) return AgendaCategory.celula;
    if (t.contains('ensaio')) return AgendaCategory.ensaio;

    return AgendaCategory.evento;
  }

  // =========================
  // BUILD
  // =========================
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_AgendaCache>(
      future: _futureCache,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final all = snapshot.data!.events;
        final featured = _featured(all);
        final week = _weekEvents(all);

        final now = DateTime.now();
        final start =
            _startOfWeekSunday(now).add(Duration(days: 7 * _weekOffset));
        final end = _endOfWeekExclusive(start);

        return Scaffold(
          // =========================
          // 🔥 APPBAR RESTAURADA
          // =========================
          appBar: AppBar(
            title: const Text('Agenda'),
            actions: [
              IconButton(
                tooltip: 'Calendário do mês',
                icon: const Icon(Icons.calendar_month_rounded),
                onPressed: () {
                  if (!mounted) return;

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    backgroundColor: ColorStyle.fundoPrincipal,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    builder: (ctx) {
                      return AgendaMonthSheet(
                        allEvents: all,
                        onEventTap: (event) {
                          Navigator.pop(ctx);
                          _openDetails(event);
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),

          body: RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (featured.isNotEmpty) ...[
                  const Text(
                    'Em destaque',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 190,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: featured.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final e = featured[i];

                        return SizedBox(
                          width: 300,
                          child: Material(
                            borderRadius: BorderRadius.circular(16),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => _openDetails(e),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: e.imageUrl != null
                                        ? Image.network(
                                            e.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                _buildGradientFallback(),
                                          )
                                        : _buildGradientFallback(),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.2),
                                            Colors.black.withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${_dowShortPt(e.startAt)} • ${_formatTime(e.startAt)}',
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],

                Row(
                  children: [
                    const Text(
                      'Próximos eventos',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _goPrevWeek,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    IconButton(
                      onPressed: _goNextWeek,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),

                Text(_rangeLabel(start, end)),

                const SizedBox(height: 12),

                ...week.map((e) {
                  final liked = _isInterested(e.id);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      tileColor: ColorStyle.fundoSuperficie,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      title: Text(e.title),
                      subtitle: Text(
                        '${_dowShortPt(e.startAt)} • ${_formatTime(e.startAt)}',
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          color: liked ? Colors.red : null,
                        ),
                        onPressed: () => _toggleInterest(e.id),
                      ),
                      onTap: () => _openDetails(e),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =========================
// FALLBACK
// =========================
Widget _buildGradientFallback() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF0B0B0F),
          Color(0xFF4A148C),
          Color(0xFF7B1FA2),
        ],
      ),
    ),
  );
}

class _AgendaCache {
  final List<AgendaEvent> events;
  _AgendaCache(this.events);
}