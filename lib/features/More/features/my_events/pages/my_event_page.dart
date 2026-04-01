import 'package:flutter/material.dart';

import '../services/my_event_service.dart';
import '../widgets/my_event_tile.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final confirmed = MyEventService.getConfirmed();
    final interested = MyEventService.getInterested();

    return Scaffold(
      appBar: AppBar(title: const Text("Meus Eventos")),
      backgroundColor: const Color(0xFF121212),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          if (confirmed.isNotEmpty) ...[
            const Text(
              "Confirmados",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...confirmed.map((e) => MyEventTile(item: e)),
            const SizedBox(height: 20),
          ],

          if (interested.isNotEmpty) ...[
            const Text(
              "Interesse",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...interested.map((e) => MyEventTile(item: e)),
          ],

          if (confirmed.isEmpty && interested.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  "Nenhum evento salvo ainda",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
        ],
      ),
    );
  }
}