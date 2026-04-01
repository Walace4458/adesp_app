import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../services/event_service.dart';
import '../widgets/event_tile.dart';
import 'event_details_page.dart';

class EventsPage extends StatelessWidget {
  final String groupId;

  const EventsPage ({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    final events = EventService.getByGroup(groupId);

    return Scaffold(
      appBar: AppBar(title: const Text("Eventos"),),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: events.isEmpty
          ? const Center(
            child: Text(
              "Nenhum evento encontrado",
              style: TextStyle(color: Colors.white70),
            ),
          )
          : ListView(
            children: events.map((e) {
              return EventTile(
                event: e, 
                onTap: () {
                  Navigator.push(context, 
                    MaterialPageRoute(
                      builder: (_) => EventDetailsPage(event: e),
                    ),
                  );
                },
              );
            }).toList(),
          )
      ),
    );
  }
}