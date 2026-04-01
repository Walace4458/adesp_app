import 'package:flutter/material.dart';
import '../models/followup_model.dart';
import '../services/followup_service.dart';

class FollowUpTile extends StatelessWidget {
  final FollowUpModel followUp;
  final VoidCallback onUpdate;

  const FollowUpTile({
    super.key,
    required this.followUp,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: followUp.isDone
          ? Colors.green.withValues(alpha: 0.1)
          : Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          followUp.isDone
            ? Icons.check_circle_rounded
            : Icons.warning_rounded,
          color: followUp.isDone ? Colors.green : Colors.red,
        ),
        title: Text(
          followUp.memberName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: followUp.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(followUp.reason),

        //Ações

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: () {
                FollowUpService.toggleDone(followUp.id);
                onUpdate();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                FollowUpService.remove(followUp.id);
                onUpdate();
              },
            ),
          ],
        ),
      ),
    );
  }
}