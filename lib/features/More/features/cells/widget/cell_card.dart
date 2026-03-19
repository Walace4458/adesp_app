import 'package:flutter/material.dart';
import '../models/cell_model.dart';

class CellCard extends StatelessWidget {
  final CellModel cell;
  final VoidCallback onTap;

  const CellCard({
    super.key,
    required this.cell,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        onTap: onTap,
        title: Text(cell.name),
        subtitle: Text("${cell.day} • ${cell.time}"),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}