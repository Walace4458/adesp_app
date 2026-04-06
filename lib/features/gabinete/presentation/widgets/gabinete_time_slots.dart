import 'package:flutter/material.dart';
import '../../models/gabinete_slot.dart';

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
    return GridView.builder(
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, i) {
        final slot = slots[i];

        return GestureDetector(
          onTap: () => onSelectSlot(slot),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                '${slot.start.hour}:00',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}