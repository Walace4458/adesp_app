import 'package:flutter/material.dart';
import '../models/my_events_item.dart';
import '../services/my_event_service.dart';

class MyEventDetailsPage extends StatefulWidget {
  final MyEventsItem item;

  const MyEventDetailsPage({
    super.key,
    required this.item,
  });

  @override
  State<MyEventDetailsPage> createState() => _MyEventDetailsPageState();
}

class _MyEventDetailsPageState extends State<MyEventDetailsPage> {
  late MyEventsItem item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  void _toggleInterest() {
    setState(() {
      MyEventService.toggleInterest(item);
    });
  }

  void _confirmPresence() {
    setState(() {
      MyEventService.confirm(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = item.event;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🎯 TÍTULO
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            // 📅 DATA
            Text(
              "${event.date.day}/${event.date.month}",
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 16),

            // 📝 DESCRIÇÃO
            Text(
              event.description,
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 20),

            // 🔥 STATUS
            Row(
              children: [
                _statusChip(
                  label: item.status == MyEventStatus.confirmed
                      ? "Confirmado"
                      : "Interessado",
                  color: item.status == MyEventStatus.confirmed
                      ? Colors.greenAccent
                      : Colors.pinkAccent,
                ),
              ],
            ),

            const Spacer(),

            // ❤️ BOTÕES
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _toggleInterest,
                    child: Text(
                      item.status == MyEventStatus.interested
                          ? "Remover interesse"
                          : "Tenho interesse ❤️",
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmPresence,
                    child: Text(
                      item.status == MyEventStatus.confirmed
                          ? "Confirmado ✅"
                          : "Confirmar presença",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color),
      ),
    );
  }
}