import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title),),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.description,
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 20,),

            Text(
              "Data: ${event.date.day}/${event.date.month}",
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 10,),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Presença confirma (futuro)"),)
                );
              },
              child: const Text("Confirmar presença"),
            ),
          ],
        ),
      ),
    );
  }
}