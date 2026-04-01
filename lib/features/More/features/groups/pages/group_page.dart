import 'package:flutter/material.dart';

import '../models/group_model.dart';
import '../services/group_service.dart';
import '../widgets/group_tile.dart';
import 'group_details_page.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key,});

  @override
  Widget build(BuildContext context) {
    final groups = GroupService.getAll();

    return Scaffold(
      appBar: AppBar(title: const Text("Grupos"),),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: groups.isEmpty
          ? const Center(
            child: Text(
              "Você não participa de nenhum grupo",
              style: TextStyle(color: Colors.white70),
            ),
          )
          : ListView(
            children: groups.map((g) {
              return GroupTile(
                group: g, 
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => GroupDetailsPage(group: g),
                  ),);
                }
              );
            }).toList(),
          ),
      ),
    );
  }
}