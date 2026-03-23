import 'package:flutter/material.dart';
import '../models/interested_model.dart';

class InterestedTile extends StatelessWidget {
  final InterestedModel interested;

  const InterestedTile(this.interested, {super.key});

  @override
  Widget build(BuildContext context) {
    Color statusColor;

    switch (interested.status.name) {
      case 'novo':
        statusColor = Colors.blue;
        break;
      case 'visitou':
        statusColor = Colors.orange;
        break;
      case 'membro':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50, // 🔥 fundo claro correto
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, color: Colors.white),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              interested.name,
              style: const TextStyle(
                color: Colors.black, // 🔥 TEXTO FORÇADO
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              interested.status.name,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}