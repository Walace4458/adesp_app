import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/gabinete_controller.dart';
import '../models/gabinete_slot.dart';

import '../presentation/widgets/gabinete_calendar.dart';
import '../presentation/widgets/gabinete_time_slots.dart';
import '../presentation/widgets/gabinete_bottom_sheet.dart';

class GabinetePage extends StatefulWidget {
  const GabinetePage({super.key});

  @override
  State<GabinetePage> createState() => _GabinetePageState();
}

class _GabinetePageState extends State<GabinetePage> {
  DateTime selectedDate = DateTime.now();

  bool _isGabineteDay(DateTime date) {
    return date.weekday == DateTime.tuesday ||
        date.weekday == DateTime.thursday;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<GabineteController>();
      controller.init();
      _loadDay(controller);
    });
  }

  void _loadDay(GabineteController controller) {
    final start = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final end = start.add(const Duration(days: 1));

    controller.loadRange(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GabineteController>();
    final isAvailableDay = _isGabineteDay(selectedDate);

    final slots = isAvailableDay
        ? controller.buildFixedSlotsForDay(selectedDate)
        : <GabineteSlot>[];

    return SafeArea(
      child: Column(
        children: [
          // 📅 CALENDÁRIO
          SizedBox(
            height: 320,
            child: GabineteCalendar(
              selectedDate: selectedDate,
              onSelectDate: (date) {
                setState(() => selectedDate = date);
                _loadDay(controller);
              },
            ),
          ),

          const SizedBox(height: 10),

          // STATUS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  isAvailableDay ? Icons.check_circle : Icons.cancel,
                  color: isAvailableDay ? Colors.green : Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  isAvailableDay
                      ? 'Dia disponível'
                      : 'Gabinetes apenas Terça e Quinta',
                  style: TextStyle(
                    color:
                        isAvailableDay ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ⏰ CONTEÚDO
          Expanded(
            child: isAvailableDay
                ? GabineteTimeSlots(
                    slots: slots,
                    onSelectSlot: (slot) async {
                      final ok = controller.selectSlot(slot);
                      if (!ok) return;

                      final result = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => GabineteBottomSheet(
                          onConfirm: ({
                            required String name,
                            required String phone,
                            required String categoryId,
                            required String note,
                          }) async {
                            await controller.submitRequest(
                              userId: 'user_mock',
                              categoryId: categoryId,
                              name: name,
                              whatsapp: phone,
                              note: note,
                            );

                            if (!ctx.mounted) return;

                            Navigator.pop(ctx, true); // ✅ CONFIRMOU
                          },
                          onCancel: () {
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx, false); // ✅ CANCELOU
                          },
                        ),
                      );

                      // 🔥 CONTROLE CENTRALIZADO (SEM BUG)
                      if (result != true) {
                        controller.cancelSelection();
                      }
                    },
                  )
                : const Center(
                    child: Text(
                      'Gabinetes apenas\nTerça e Quinta',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}