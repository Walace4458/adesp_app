import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/report_model.dart';

class ReportDetailsPage extends StatelessWidget {
  final ReportModel report;

  const ReportDetailsPage({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy').format(report.date); // 🔥 corrigido

    return Scaffold(
      backgroundColor: Colors.black, // 🔥 fundo preto
      appBar: AppBar(
        title: const Text("Detalhes do Relatório"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title("Data"),
                      const SizedBox(height: 6),
                      _text(date),
                    ],
                  ),
                ),

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title("Resumo"),
                      const SizedBox(height: 8),
                      _text(report.description),
                    ],
                  ),
                ),

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title("Novos Membros"),
                      const SizedBox(height: 8),
                      if (report.newMembers.isEmpty)
                        _text("Nenhum", isSecondary: true),
                      ...report.newMembers.map((e) => _text("• $e")),
                    ],
                  ),
                ),

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title("Novos Visitantes"),
                      const SizedBox(height: 8),
                      if (report.newVisitors.isEmpty)
                        _text("Nenhum", isSecondary: true),
                      ...report.newVisitors.map((e) => _text("• $e")),
                    ],
                  ),
                ),

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title("Contribuição"),
                      const SizedBox(height: 8),
                      Text(
                        report.hadContribution
                            ? _formatCurrency(report.contributionValue)
                            : "Não houve contribuição",
                        style: TextStyle(
                          color: report.hadContribution
                              ? Colors.greenAccent
                              : Colors.white38,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= COMPONENTES =================

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // 🔥 preto elevado (não chapado)
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  Widget _text(String text, {bool isSecondary = false}) {
    return Text(
      text,
      style: TextStyle(
        color: isSecondary ? Colors.white60 : Colors.white,
      ),
    );
  }

  String _formatCurrency(double? value) {
    if (value == null) return "R\$ 0,00";
    return "R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}";
  }
}