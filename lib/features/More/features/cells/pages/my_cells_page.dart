import 'package:flutter/material.dart';
import '../models/cell_model.dart';
import '../services/cell_service.dart';
import '../widget/cell_card.dart';

class MyCellsPage extends StatefulWidget {
  const MyCellsPage({super.key});

  @override
  State<MyCellsPage> createState() => _MyCellsPageState();
}

class _MyCellsPageState extends State<MyCellsPage> {

  List<CellModel> cells = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCells();
  }

  Future<void> loadCells() async {
    cells = await CellService.getMyCells();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Células"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cells.isEmpty
              ? const Center(child: Text("Você não participa de nenhuma célula"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cells.length,
                  itemBuilder: (context, index) {
                    return CellCard(cell: cells[index]);
                  },
                ),
    );
  }
}