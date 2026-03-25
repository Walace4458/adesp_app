import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/report_model.dart';
import '../services/cell_service.dart';

class ReportPage extends StatefulWidget {
  final String cellId;

  const ReportPage({super.key, required this.cellId});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int step = 0;

  final List<String> churchPeople = [
    "João Silva",
    "Maria Souza",
    "Carlos Lima",
    "Ana Paula",
    "Pedro Santos"
  ];

  List<String> newMembers = [];
  List<String> newVisitors = [];

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  bool hadContribution = false;

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Relatório"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildStep(),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (step) {
      case 0:
        return _lastReport();
      case 1:
        return _peopleStep();
      case 2:
        return _meetingStep();
      default:
        return const SizedBox();
    }
  }

  // ================= STEP 1 =================

  Widget _lastReport() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Último Relatório",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _card("Novos Membros", "2"),
              _card("Novos Visitantes", "1"),
              _card("Membros", "10"),
              _card("Não Foram", "2"),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "A célula foi muito boa, tivemos comunhão e visitantes.",
              style: TextStyle(color: Colors.white),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => step++),
              child: const Text("Continuar"),
            ),
          )
        ],
      ),
    );
  }

  Widget _card(String title, String value) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ================= STEP 2 =================

  Widget _peopleStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Pessoas",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _openSelector(true),
              child: const Text("Adicionar Membro"),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _openSelector(false),
              child: const Text("Adicionar Visitante"),
            ),
          ),

          const SizedBox(height: 20),

          _listPreview("Novos Membros", newMembers),
          _listPreview("Novos Visitantes", newVisitors),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => step++),
              child: const Text("Continuar"),
            ),
          )
        ],
      ),
    );
  }

  Widget _listPreview(String title, List<String> list) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          if (list.isEmpty)
            const Text("Nenhum adicionado",
                style: TextStyle(color: Colors.white54)),
          ...list.map((e) => Text("• $e",
              style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  // ================= MODAL =================

  void _openSelector(bool isMember) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (_) {
        List<String> filtered = List.from(churchPeople);
        final controller = TextEditingController();

        return StatefulBuilder(builder: (context, setModal) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Buscar pessoa",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setModal(() {
                      filtered = churchPeople
                          .where((p) =>
                              p.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: ListView(
                    children: filtered.map((name) {
                      return ListTile(
                        title: Text(name,
                            style: const TextStyle(color: Colors.white)),
                        onTap: () {
                          setState(() {
                            if (isMember) {
                              newMembers.add(name);
                            } else {
                              newVisitors.add(name);
                            }
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),

                ElevatedButton(
                  onPressed: () => _addNewPerson(isMember),
                  child: const Text("Cadastrar novo"),
                )
              ],
            ),
          );
        });
      },
    );
  }

  void _addNewPerson(bool isMember) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text("Novo Cadastro",
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "Nome",
            labelStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final name = nameController.text;
              if (name.isEmpty) return;

              setState(() {
                churchPeople.add(name);
                if (isMember) {
                  newMembers.add(name);
                } else {
                  newVisitors.add(name);
                }
              });

              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          )
        ],
      ),
    );
  }

  // ================= STEP 3 =================

  Widget _meetingStep() {
    final canSave = _descriptionController.text.isNotEmpty &&
        (!hadContribution || _valueController.text.isNotEmpty);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Resumo",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: _descriptionController,
            style: const TextStyle(color: Colors.white),
            onChanged: (_) => setState(() {}),
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Descreva a reunião...",
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),

          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text("Teve contribuição?",
                style: TextStyle(color: Colors.white)),
            value: hadContribution,
            onChanged: (v) {
              setState(() {
                hadContribution = v;
                if (!v) _valueController.clear();
              });
            },
          ),

          if (hadContribution)
            TextField(
              controller: _valueController,
              style: const TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CurrencyFormatter(),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Valor",
                labelStyle: TextStyle(color: Colors.white54),
              ),
            ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canSave ? _save : null,
              child: const Text("Salvar Relatório"),
            ),
          )
        ],
      ),
    );
  }

  // ================= SAVE =================

  void _save() {
    double? value;

    if (hadContribution) {
      final digits =
          _valueController.text.replaceAll(RegExp(r'\D'), '');
      value = double.tryParse(digits) != null
          ? double.parse(digits) / 100
          : null;
    }

    CellService.addReport(
      widget.cellId,
      ReportModel(
        id: DateTime.now().toString(),
        cellId: widget.cellId,
        date: DateTime.now(),
        newMembers: newMembers,
        newVisitors: newVisitors,
        description: _descriptionController.text,
        hadContribution: hadContribution,
        contributionValue: value,
      ),
    );

    Navigator.pop(context);
  }
}

// ================= FORMATADOR =================

class _CurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) return newValue;

    final value = double.parse(digits) / 100;
    final text = "R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}";

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}