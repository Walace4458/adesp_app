import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/features/agenda/models/agenda_event.dart';
import 'package:flutter_application_1/features/agenda/service/agenda_actions_service.dart';

class AgendaEventDetailsSheet extends StatefulWidget {
  final AgendaEvent event;
  final AgendaActionsService actions;
  final bool isConfirmed;
  final VoidCallback? onPresenceConfirmed;

  const AgendaEventDetailsSheet({
    super.key,
    required this.event,
    required this.isConfirmed,
    this.actions = const AgendaActionsService(),
    this.onPresenceConfirmed,
  });

  static Future<void> show(
    BuildContext context, {
    required AgendaEvent event,
    required bool isConfirmed,
    AgendaActionsService actions = const AgendaActionsService(),
    VoidCallback? onPresenceConfirmed,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SheetSurface(
        child: AgendaEventDetailsSheet(
          event: event,
          isConfirmed: isConfirmed,
          actions: actions,
          onPresenceConfirmed: onPresenceConfirmed,
        ),
      ),
    );
  }

  @override
  State<AgendaEventDetailsSheet> createState() =>
      _AgendaEventDetailsSheetState();
}

class _AgendaEventDetailsSheetState extends State<AgendaEventDetailsSheet> {
  bool _confirmLoading = false;
  bool _calendarLoading = false;

  Color _alpha(Color c, double opacity) {
    final a = (opacity * 255).round().clamp(0, 255);
    return c.withAlpha(a);
  }

  String _monthShortPt(int month) {
    const m = [
      'jan','fev','mar','abr','mai','jun',
      'jul','ago','set','out','nov','dez'
    ];
    return m[month - 1];
  }

  String _dowShortPt(DateTime d) {
    switch (d.weekday) {
      case DateTime.monday: return 'SEG';
      case DateTime.tuesday: return 'TER';
      case DateTime.wednesday: return 'QUA';
      case DateTime.thursday: return 'QUI';
      case DateTime.friday: return 'SEX';
      case DateTime.saturday: return 'SÁB';
      case DateTime.sunday: return 'DOM';
      default: return '';
    }
  }

  String _formatDayMonth(DateTime d) =>
      '${d.day} ${_monthShortPt(d.month)}';

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';

  String _categoryLabel(AgendaCategory c) {
    switch (c) {
      case AgendaCategory.culto: return 'Culto';
      case AgendaCategory.jovens: return 'Jovens';
      case AgendaCategory.celula: return 'Célula';
      case AgendaCategory.evento: return 'Evento';
      case AgendaCategory.ensaio: return 'Ensaio';
      case AgendaCategory.outro: return 'Outro';
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;

    final hasDesc = e.description.trim().isNotEmpty;
    final hasBanner = (e.bannerUrl ?? '').trim().isNotEmpty;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: _alpha(ColorStyle.textoSecundario, .35),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 14),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if (hasBanner) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: AspectRatio(
                          aspectRatio: 16/9,
                          child: Image.network(
                            e.bannerUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Text(
                      e.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: ColorStyle.textoPrincipal,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _Pill(text: '${_dowShortPt(e.startAt)} • ${_formatDayMonth(e.startAt)}'),
                        _Pill(text: _formatTime(e.startAt)),
                        _Pill(text: _categoryLabel(e.category)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    if (e.location.trim().isNotEmpty)
                      _InfoRow(icon: Icons.place_rounded, text: e.location),

                    if (hasDesc) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Sobre',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ColorStyle.textoPrincipal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _alpha(ColorStyle.fundoSuperficie, .6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          e.description,
                          style: TextStyle(
                            color: ColorStyle.textoPrincipal,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 22),

                    Divider(color: _alpha(ColorStyle.textoSecundario, .15)),

                    const SizedBox(height: 16),

                    _ActionButton(
                      icon: Icons.ios_share_rounded,
                      label: 'Compartilhar',
                      onTap: () => widget.actions.shareEvent(context, e),
                    ),

                    const SizedBox(height: 10),

                    _ActionButton(
                      icon: Icons.event_available_rounded,
                      label: _calendarLoading
                          ? 'Adicionando...'
                          : 'Adicionar ao calendário',
                      onTap: _calendarLoading ? null : () async {
                        setState(() => _calendarLoading = true);
                        await widget.actions.addToCalendar(e);
                        if (mounted) {
                          setState(() => _calendarLoading = false);
                          _snack('Em breve: integração com calendário.');
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    _ActionButton(
                      icon: Icons.check_circle_rounded,
                      label: widget.isConfirmed
                          ? 'Presença confirmada'
                          : (_confirmLoading
                              ? 'Confirmando...'
                              : 'Confirmar presença'),
                      onTap: widget.isConfirmed || _confirmLoading
                          ? null
                          : () async {
                              setState(() => _confirmLoading = true);
                              final ok = await widget.actions.confirmPresence(e);
                              if (!mounted) return;

                              if (ok) {
                                widget.onPresenceConfirmed?.call();
                                Navigator.pop(context);
                              } else {
                                _snack('Não foi possível confirmar.');
                              }
                            },
                    ),

                    const SizedBox(height: 10),

                    _ActionButton(
                      icon: Icons.payments_rounded,
                      label: 'Pagamento (em breve)',
                      onTap: null,
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Fechar',
                        style: TextStyle(color: ColorStyle.textoSecundario),
                      ),
                    ),

                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetSurface extends StatelessWidget {
  final Widget child;
  const _SheetSurface({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorStyle.fundoPrincipal,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: child,
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: ColorStyle.textoSecundario.withAlpha(50),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: ColorStyle.textoSecundario,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: ColorStyle.textoSecundario),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorStyle.textoPrincipal,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: enabled
              ? ColorStyle.principal
              : ColorStyle.textoSecundario.withAlpha(40),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: ColorStyle.textoPrincipal),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: ColorStyle.textoPrincipal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}