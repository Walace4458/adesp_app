import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

import '../gabinete/data/mock_gabinete_repository.dart';
import '../gabinete/models/gabinete_enums.dart';
import '../gabinete/models/gabinete_slot.dart';
import '../gabinete/service/gabinete_slot_hold_service.dart';
import '../gabinete/state/gabinete_controller.dart';

class GabinetePage extends StatefulWidget {
  const GabinetePage({super.key});

  @override
  State<GabinetePage> createState() => _GabinetePageState();
}

class _GabinetePageState extends State<GabinetePage> {
  final _repo = MockGabineteRepository();
  late final GabineteSlotHoldService _holdService;
  late final GabineteController _controller;

  // Debug user/admin
  final String _userId = 'user_1';
  final String _adminUserId = 'admin_1';

  DateTime _selectedDay = DateTime.now();

  String? _selectedCategoryId;
  final _nameCtrl = TextEditingController(text: 'Victor');
  final _whatsCtrl = TextEditingController(text: '21999999999');
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _holdService = GabineteSlotHoldService(repository: _repo);
    _controller = GabineteController(repo: _repo, holdService: _holdService);

    _controller.addListener(() => setState(() {}));
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _controller.init();

    _selectedCategoryId = _controller.state.categories.isNotEmpty
        ? _controller.state.categories.first.id
        : null;

    await _loadDayRange();
    await _controller.loadMyRequests(_userId);
  }

  DateTime get _dayStart =>
      DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
  DateTime get _dayEndExclusive => _dayStart.add(const Duration(days: 1));

  Future<void> _loadDayRange() async {
    await _controller.loadRange(_dayStart, _dayEndExclusive);
  }

  Future<void> _changeDay(DateTime newDay) async {
    // ✅ TROCA 1: se mudou o dia, cancela hold (evita hold “fantasma”)
    await _controller.cancelHold(_userId);
    if (!mounted) return;

    setState(() => _selectedDay = newDay);
    await _loadDayRange();
  }

  String _hhmm(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Future<void> _onHoldSlot(GabineteSlot slot) async {
    await _controller.holdSlot(slot: slot, userId: _userId);

    final hold = _holdService.currentHold;
    if (hold == null || !mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) {
        return _GabineteRequestSheet(
          controller: _controller,
          userId: _userId,
          selectedCategoryId: _selectedCategoryId,
          onCategoryChanged: (v) => setState(() => _selectedCategoryId = v),
          nameCtrl: _nameCtrl,
          whatsCtrl: _whatsCtrl,
          noteCtrl: _noteCtrl,
        );
      },
    ).whenComplete(() async {
      // Se fechou sem confirmar, libera hold (se já foi consumido, não tem efeito)
      await _controller.cancelHold(_userId);
      if (!mounted) return;
      await _controller.loadMyRequests(_userId);
      await _loadDayRange();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameCtrl.dispose();
    _whatsCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = _controller.state;
    final slots = _controller.buildFixedSlotsForDay(_selectedDay);
    final hold = _holdService.currentHold;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // Banner de erro
          if (s.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorStyle.principal.withValues(alpha: 0.12),
                border: Border.all(
                  color: ColorStyle.principal.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                s.errorMessage!,
                style: const TextStyle(color: ColorStyle.textoPrincipal),
              ),
            ),

          // Controles do dia
          Row(
            children: [
              _MiniChipButton(
                label: 'Ontem',
                onTap: () async =>
                    _changeDay(_selectedDay.subtract(const Duration(days: 1))),
              ),
              const SizedBox(width: 8),
              _MiniChipButton(
                label: 'Hoje',
                onTap: () async => _changeDay(DateTime.now()),
              ),
              const SizedBox(width: 8),
              _MiniChipButton(
                label: 'Amanhã',
                onTap: () async =>
                    _changeDay(_selectedDay.add(const Duration(days: 1))),
              ),
              const Spacer(),
              Text(
                '${_selectedDay.day.toString().padLeft(2, '0')}/${_selectedDay.month.toString().padLeft(2, '0')}',
                style: const TextStyle(color: ColorStyle.textoSecundario),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Text(
                'Horários disponíveis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorStyle.textoPrincipal,
                ),
              ),
              const Spacer(),
              if (hold != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: ColorStyle.principal.withValues(alpha: 0.18),
                    border: Border.all(
                      color: ColorStyle.principal.withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Text(
                    'Selecionando…',
                    style: TextStyle(
                      color: ColorStyle.textoPrincipal,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          ...slots.map((slot) {
            final blocked = _controller.isSlotBlockedByRangeRequests(slot.key);
            final isHeld = hold?.slotKey == slot.key;
            final isPast = _controller.isSlotInPast(slot);

            return _SlotTile(
              start: _hhmm(slot.start),
              end: _hhmm(slot.endExclusive),
              isBlocked: blocked,
              isHeld: isHeld,
              isPast: isPast, // ✅ TROCA 2: diferenciar passado no visual
              onHold:
                  (blocked || isHeld || isPast) ? null : () => _onHoldSlot(slot),
            );
          }),

          const SizedBox(height: 20),

          const Text(
            'Meus pedidos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorStyle.textoPrincipal,
            ),
          ),
          const SizedBox(height: 8),

          if (s.myRequests.isEmpty)
            const Text(
              'Nenhum pedido ainda.',
              style: TextStyle(color: ColorStyle.textoSecundario),
            )
          else
            ...s.myRequests.map((r) {
              final title =
                  '${_hhmm(r.slot.start)}–${_hhmm(r.slot.endExclusive)} • ${r.status.name}';
              final subtitle =
                  'Categoria: ${r.categoryId}\nNome: ${r.memberNameSnapshot}';

              return Card(
                child: ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(color: ColorStyle.textoPrincipal),
                  ),
                  subtitle: Text(
                    subtitle,
                    style: const TextStyle(color: ColorStyle.textoSecundario),
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<GabineteRequestStatus>(
                    onSelected: (st) async {
                      await _controller.adminSetStatus(
                        requestId: r.id.value,
                        adminUserId: _adminUserId,
                        status: st,
                      );
                      await _controller.loadMyRequests(_userId);
                      await _loadDayRange();
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: GabineteRequestStatus.confirmed,
                        child: Text('Admin: Confirmar'),
                      ),
                      PopupMenuItem(
                        value: GabineteRequestStatus.cancelled,
                        child: Text('Admin: Cancelar'),
                      ),
                      PopupMenuItem(
                        value: GabineteRequestStatus.completed,
                        child: Text('Admin: Concluir'),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _MiniChipButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MiniChipButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: ColorStyle.fundoSuperficie,
          border: Border.all(
            color: ColorStyle.fundoSuperficie.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: ColorStyle.textoPrincipal, fontSize: 12),
        ),
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  final String start;
  final String end;
  final bool isBlocked;
  final bool isHeld;
  final bool isPast;
  final VoidCallback? onHold;

  const _SlotTile({
    required this.start,
    required this.end,
    required this.isBlocked,
    required this.isHeld,
    required this.isPast,
    required this.onHold,
  });

  @override
  Widget build(BuildContext context) {
    final status = isHeld
        ? 'SELECIONADO'
        : isPast
            ? 'PASSADO'
            : isBlocked
                ? 'OCUPADO'
                : 'LIVRE';

    final statusColor = isHeld
        ? ColorStyle.principal
        : (isPast || isBlocked)
            ? ColorStyle.textoSecundario
            : ColorStyle.textoPrincipal;

    return Card(
      child: ListTile(
        title: Text(
          '$start–$end',
          style: const TextStyle(color: ColorStyle.textoPrincipal),
        ),
        subtitle: Text(status, style: TextStyle(color: statusColor)),
        trailing: onHold == null
            ? null
            : FilledButton(
                onPressed: onHold,
                child: const Text('Segurar'),
              ),
      ),
    );
  }
}

class _GabineteRequestSheet extends StatelessWidget {
  final GabineteController controller;
  final String userId;

  final String? selectedCategoryId;
  final ValueChanged<String?> onCategoryChanged;

  final TextEditingController nameCtrl;
  final TextEditingController whatsCtrl;
  final TextEditingController noteCtrl;

  const _GabineteRequestSheet({
    required this.controller,
    required this.userId,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    required this.nameCtrl,
    required this.whatsCtrl,
    required this.noteCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final s = controller.state;
    final hold = controller.holdService.currentHold;

    return DraggableScrollableSheet(
      initialChildSize: 0.58,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: ColorStyle.fundoSuperficie,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: ColorStyle.textoSecundario.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Agendar Gabinete',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorStyle.textoPrincipal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                hold == null
                    ? 'Hold não encontrado'
                    : 'Tempo para confirmar: ${hold.expiresAt}',
                style: const TextStyle(
                  color: ColorStyle.textoSecundario,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedCategoryId,
                items: s.categories
                    .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.label),
                        ))
                    .toList(),
                onChanged: onCategoryChanged,
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: whatsCtrl,
                decoration: const InputDecoration(labelText: 'WhatsApp'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(labelText: 'Observação'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      await controller.cancelHold(userId);
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        if (selectedCategoryId == null) return;

                        await controller.submitRequest(
                          userId: userId,
                          categoryId: selectedCategoryId!,
                          name: nameCtrl.text,
                          whatsapp: whatsCtrl.text,
                          note: noteCtrl.text,
                        );

                        if (controller.state.errorMessage == null &&
                            context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Pedido enviado! Aguarde confirmação.'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Confirmar pedido'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}