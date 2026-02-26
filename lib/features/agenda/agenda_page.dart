import 'package:flutter/material.dart';

import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/features/agenda/data/agenda_repository.dart';
import 'package:flutter_application_1/features/agenda/data/mock_agenda_repository.dart';
import 'package:flutter_application_1/features/agenda/models/agenda_event.dart';

// >>> IMPORTS NOVOS (ajuste o caminho se precisar)
import 'package:flutter_application_1/features/agenda/service/agenda_interest_service.dart';
import 'package:flutter_application_1/features/agenda/service/agenda_interest_store.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final AgendaRepository _repo = MockAgendaRepository();
  late Future<List<AgendaEvent>> _future;

  int _weekOffset = 0; // 0 semana atual, -1 passada, +1 próxima

  // ❤️ Interesse (local + backend)
  final _interestStore = AgendaInterestStore();
  final _interestService = const AgendaInterestService();

  Set<String> _interestedIds = <String>{};
  bool _interestLoaded = false;

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchEvents();

    _interestStore.load().then((ids) {
      if (!mounted) return;
      setState(() {
        _interestedIds = ids;
        _interestLoaded = true;
      });
    });
  }

  void _reload() {
    setState(() {
      _future = _repo.fetchEvents();
    });
  }

  void _goPrevWeek() => setState(() => _weekOffset -= 1);
  void _goNextWeek() => setState(() => _weekOffset += 1);
  void _goThisWeek() => setState(() => _weekOffset = 0);

  // ---- helpers sem withOpacity (usa alpha)
  Color _alpha(Color c, double opacity) {
    final a = (opacity * 255).round().clamp(0, 255);
    return c.withAlpha(a);
  }

  // semana começa em DOMINGO
  DateTime _startOfWeekSunday(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final daysSinceSunday = d.weekday % 7; // dom=0, seg=1 ... sáb=6
    return d.subtract(Duration(days: daysSinceSunday));
  }

  DateTime _endOfWeekExclusive(DateTime startOfWeek) {
    return startOfWeek.add(const Duration(days: 7));
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
        return 'SEX';
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

  String _formatDayMonth(DateTime d) => '${d.day} ${_monthShortPt(d.month)}';

  String _formatTime(DateTime d) {
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String _rangeLabel(DateTime start, DateTime endInclusive) {
    return '${_dowShortPt(start)}, ${_formatDayMonth(start)} — '
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

  void _snack(String msg) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(msg)));
  }

  TextStyle _sectionTitleStyle(BuildContext context) {
    final base = Theme.of(context).textTheme.titleMedium;
    return (base ?? const TextStyle()).copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: ColorStyle.textoPrincipal,
    );
  }

  // =========================
  // ❤️ Toggle do interesse
  // =========================
  Future<void> _toggleInterest(String eventId) async {
    if (!_interestLoaded) return;

    final wasInterested = _interestedIds.contains(eventId);
    final newInterested = !wasInterested;

    // 1) muda na hora (UX)
    setState(() {
      if (newInterested) {
        _interestedIds.add(eventId);
      } else {
        _interestedIds.remove(eventId);
      }
    });

    // 2) salva local (persistência)
    await _interestStore.save(_interestedIds);

    // 3) backend (stub hoje)
    final ok = await _interestService.setInterested(
      eventId: eventId,
      interested: newInterested,
    );

    // 4) se falhar, reverte
    if (!ok && mounted) {
      setState(() {
        if (wasInterested) {
          _interestedIds.add(eventId);
        } else {
          _interestedIds.remove(eventId);
        }
      });
      await _interestStore.save(_interestedIds);
      _snack('Não foi possível salvar seu interesse.');
    }
  }

  bool _isInterested(String eventId) => _interestedIds.contains(eventId);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final baseWeekStart =
        _startOfWeekSunday(now).add(Duration(days: 7 * _weekOffset));
    final baseWeekEndExclusive = _endOfWeekExclusive(baseWeekStart);
    final baseWeekEndInclusive =
        baseWeekEndExclusive.subtract(const Duration(days: 1));

    return Scaffold(
      appBar: AppBar(title: const Text('Agenda')),
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
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _reload,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final all = snapshot.data ?? const <AgendaEvent>[];
          final featured = _featured(all);
          final weekEvents =
              _eventsInRange(all, baseWeekStart, baseWeekEndExclusive);

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ====== DESTAQUES ======
                if (featured.isNotEmpty) ...[
                  Text('Em destaque', style: _sectionTitleStyle(context)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 190,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: featured.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final e = featured[index];
                        final liked = _isInterested(e.id);

                        return _FeaturedCard(
                          title: e.title,
                          subtitle:
                              '${_dowShortPt(e.startAt)} • ${_formatDayMonth(e.startAt)} • ${_formatTime(e.startAt)}',
                          location: e.location,
                          category: _categoryLabel(e.category),

                          isInterested: liked,
                          onHeartTap: () => _toggleInterest(e.id),

                          onTap: () => _snack('Abrir detalhes: ${e.title}'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // ====== HEADER SEMANA ======
                Row(
                  children: [
                    Text('Próximos eventos', style: _sectionTitleStyle(context)),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Semana passada',
                      onPressed: _goPrevWeek,
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    IconButton(
                      tooltip: 'Próxima semana',
                      onPressed: _goNextWeek,
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _rangeLabel(baseWeekStart, baseWeekEndInclusive),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorStyle.textoSecundario,
                      ),
                ),
                const SizedBox(height: 12),

                // ====== LISTA DA SEMANA ======
                if (weekEvents.isEmpty)
                  _EmptyWeek(
                    isCurrentWeek: _weekOffset == 0,
                    onGoThisWeek: _goThisWeek,
                    bg: _alpha(ColorStyle.fundoSuperficie, 0.60),
                  )
                else
                  ...weekEvents.map((e) {
                    final liked = _isInterested(e.id);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _WeekEventCard(
                        dow: _dowShortPt(e.startAt),
                        day: e.startAt.day.toString().padLeft(2, '0'),
                        title: e.title,
                        time: _formatTime(e.startAt),
                        location: e.location,
                        category: _categoryLabel(e.category),
                        bg: _alpha(ColorStyle.fundoSuperficie, 0.60),
                        border: _alpha(ColorStyle.textoSecundario, 0.18),

                        isInterested: liked,
                        onHeartTap: () => _toggleInterest(e.id),

                        onTap: () => _snack('Abrir detalhes: ${e.title}'),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String location;
  final String category;

  final bool isInterested;
  final VoidCallback onHeartTap;

  final VoidCallback onTap;

  const _FeaturedCard({
    required this.title,
    required this.subtitle,
    required this.location,
    required this.category,
    required this.isInterested,
    required this.onHeartTap,
    required this.onTap,
  });

  Color _alpha(Color c, double opacity) {
    final a = (opacity * 255).round().clamp(0, 255);
    return c.withAlpha(a);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Material(
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  _alpha(ColorStyle.principal, 0.95),
                  _alpha(ColorStyle.fundoSuperficie, 0.95),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _Chip(
                        text: category,
                        bg: _alpha(ColorStyle.textoPrincipal, 0.14),
                        border: _alpha(ColorStyle.textoPrincipal, 0.14),
                        textColor: ColorStyle.textoPrincipal,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: onHeartTap,
                        icon: Icon(
                          isInterested
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isInterested
                              ? ColorStyle.textoPrincipal
                              : _alpha(ColorStyle.textoPrincipal, 0.80),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ColorStyle.textoPrincipal,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _alpha(ColorStyle.textoPrincipal, 0.85),
                        ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.place_rounded,
                        size: 16,
                        color: _alpha(ColorStyle.textoPrincipal, 0.85),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _alpha(ColorStyle.textoPrincipal, 0.85),
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekEventCard extends StatelessWidget {
  final String dow;
  final String day;
  final String title;
  final String time;
  final String location;
  final String category;
  final Color bg;
  final Color border;

  final bool isInterested;
  final VoidCallback onHeartTap;

  final VoidCallback onTap;

  const _WeekEventCard({
    required this.dow,
    required this.day,
    required this.title,
    required this.time,
    required this.location,
    required this.category,
    required this.bg,
    required this.border,
    required this.isInterested,
    required this.onHeartTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      color: bg,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 54,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dow,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorStyle.textoSecundario,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        day,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: ColorStyle.textoPrincipal,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ColorStyle.textoPrincipal,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$time • $location',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorStyle.textoSecundario,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _Chip(
                        text: category,
                        bg: Colors.transparent,
                        border: border,
                        textColor: ColorStyle.textoSecundario,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onHeartTap,
                  icon: Icon(
                    isInterested
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isInterested
                        ? ColorStyle.principal
                        : ColorStyle.textoSecundario,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: ColorStyle.textoSecundario,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color bg;
  final Color border;
  final Color textColor;

  const _Chip({
    required this.text,
    required this.bg,
    required this.border,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
      ),
    );
  }
}

class _EmptyWeek extends StatelessWidget {
  final bool isCurrentWeek;
  final VoidCallback onGoThisWeek;
  final Color bg;

  const _EmptyWeek({
    required this.isCurrentWeek,
    required this.onGoThisWeek,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nenhum evento nesta semana.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorStyle.textoPrincipal,
                ),
          ),
          if (!isCurrentWeek) ...[
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: onGoThisWeek,
              child: const Text('Voltar para semana atual'),
            ),
          ],
        ],
      ),
    );
  }
}