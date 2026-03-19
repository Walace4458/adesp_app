import 'package:flutter/material.dart';
import '../services/cell_service.dart';
import '../widget/cell_card.dart';
import 'cell_details_page.dart';

class MyCellsPage extends StatelessWidget{
  const MyCellsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cells = CellService.getMyCells();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Células"),
      ),
      body: ListView.builder(
        itemCount: cells.length,
        itemBuilder: (context, index) {
          final cell = cells[index];

          return CellCard(
            cell: cell,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CellDetailsPage(cell: cell),
                ),
              );
            },
          );
        },
      ),
    );
  }
}