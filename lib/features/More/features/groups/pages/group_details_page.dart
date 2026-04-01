import 'package:flutter/material.dart';

import '../../events/pages/event_page.dart';
import '../models/group_model.dart';

class GroupDetailsPage extends StatelessWidget {
  final GroupModel group;

  const GroupDetailsPage({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
      ),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.description,
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 20,),

            const Text(
              "Membros",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10,),

            ...group.memberNames.map((name) {
              return ListTile(
                leading: const Icon(Icons.person, color: Colors.white70,),
                title: Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventsPage(groupId: group.id),
                  ),
                );
              },
              child: const Text("Ver eventos"),
            )
          ],
        ),
      ),
    );
  }
}