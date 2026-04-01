import 'package:flutter/material.dart';
import '../models/my_events_item.dart';
import '../pages/my_event_details_page.dart';

class MyEventTile extends StatelessWidget {
  final MyEventsItem item;

  const MyEventTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final event = item.event;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyEventDetailsPage(item: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              item.status == MyEventStatus.confirmed
                  ? Icons.check_circle
                  : Icons.favorite,
              color: item.status == MyEventStatus.confirmed
                  ? Colors.greenAccent
                  : Colors.pinkAccent,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${event.date.day}/${event.date.month} • ${event.description}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            Text(
              item.status == MyEventStatus.confirmed
                  ? "Confirmado"
                  : "Interessado",
              style: TextStyle(
                color: item.status == MyEventStatus.confirmed
                    ? Colors.greenAccent
                    : Colors.pinkAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}