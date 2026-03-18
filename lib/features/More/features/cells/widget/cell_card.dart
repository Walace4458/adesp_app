import 'package:flutter/material.dart';
import '../models/cell_model.dart';

class CellCard extends StatelessWidget {
  final CellModel cell;

  const CellCard({super.key, required this.cell});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.groups, color: Colors.blue),
        title: Text(cell.name),
        subtitle: Text("${cell.day} • ${cell.time}\nLíder: ${cell.leader}"),
        isThreeLine: true,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          print("Abrir célula ${cell.name}");
        },
      ),
    );
  }
}