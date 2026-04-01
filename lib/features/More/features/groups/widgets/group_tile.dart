import 'package:flutter/material.dart';
import '../models/group_model.dart';

class GroupTile extends StatelessWidget{
  final GroupModel group;
  final VoidCallback onTap;

  const GroupTile({
    super.key,
    required this.group,
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
        leading: const Icon(Icons.group, color: Colors.white70,),
        title: Text(
          group.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          group.role,
          style: const TextStyle(color: Colors.white54),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white54,),
        onTap: onTap,
      ),
    );
  }
}