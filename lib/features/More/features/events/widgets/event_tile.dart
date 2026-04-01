import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventTile extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventTile({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.event_rounded, color: Colors.white70,),
        title: Text(
          event.title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "${event.date.day}/${event.date.month} às ${event.date.hour}:${event.date.minute}",
          style: const TextStyle(color: Colors.white54),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white54,),
        onTap: onTap,
      ),
    );
  }
}