import 'package:flutter/material.dart';
import '../models/interested_model.dart';

class InterestedTile extends StatelessWidget {
  final InterestedModel interested;

  const InterestedTile(this.interested, {super.key});

  Color getStatusColor() {
    switch (interested.status) {
      case InterestedStatus.novo:
        return Colors.blue;
      case InterestedStatus.visitou:
        return Colors.orange;
      case InterestedStatus.membro:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(interested.name),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: getStatusColor().withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          interested.status.name,
          style: TextStyle(color: getStatusColor()),
        ),
      ),
    );
  }
}