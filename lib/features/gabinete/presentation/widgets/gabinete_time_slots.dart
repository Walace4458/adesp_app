import 'package:flutter/material.dart';
import '../../models/gabinete_slot.dart';
import '../../state/gabinete_controller.dart';
import 'package:provider/provider.dart';

class GabineteTimeSlots extends StatelessWidget {
  final List<GabineteSlot> slots;
  final Function(GabineteSlot) onSelectSlot;

  const GabineteTimeSlots({
    super.key,
    required this.slots,
    required this.onSelectSlot,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GabineteController>();

    // =========================
    // FILTRA DISPONÍVEIS
    // =========================
    final availableSlots = slots.where((slot) {
      return !controller.isSlotInPast(slot) &&
          !controller.isSlotBlockedByRangeRequests(slot.key);
    }).toList();

    final isLastSlots = availableSlots.length <= 2;

    return Column(
      children: [
        // =========================
        // ALERTA ÚLTIMOS HORÁRIOS
        // =========================
        if (isLastSlots && availableSlots.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              '🔥 Últimos horários disponíveis',
              style: TextStyle(
                color: Colors.orange.shade300,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        // =========================
        // GRID
        // =========================
        Expanded(
          child: GridView.builder(
            itemCount: slots.length,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (_, i) {
              final slot = slots[i];

              final isPast = controller.isSlotInPast(slot);
              final isBlocked =
                  controller.isSlotBlockedByRangeRequests(slot.key);

              final isAvailable = !isPast && !isBlocked;

              Color bgColor;
              Color textColor;
              TextDecoration? decoration;

              if (isPast) {
                bgColor = Colors.grey.withOpacity(0.3);
                textColor = Colors.white30;
                decoration = TextDecoration.lineThrough;
              } else if (isBlocked) {
                bgColor = Colors.red.withOpacity(0.7);
                textColor = Colors.white70;
              } else {
                bgColor = Colors.deepPurple;
                textColor = Colors.white;
              }

              return GestureDetector(
                onTap: isAvailable ? () => onSelectSlot(slot) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: isAvailable
                        ? Border.all(color: Colors.purpleAccent, width: 1)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${slot.start.hour.toString().padLeft(2, '0')}:00',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: decoration,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}