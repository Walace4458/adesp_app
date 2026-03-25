import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/cell_service.dart';
import 'report_page.dart';
import 'report_details_page.dart';

class ReportHistoryPage extends StatefulWidget {
  final String cellId;

  const ReportHistoryPage({
    super.key,
    required this.cellId,
  });

  @override
  State<ReportHistoryPage> createState() => _ReportHistoryPageState();
}

class _ReportHistoryPageState extends State<ReportHistoryPage> {
  late List<ReportModel> reports;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    reports = CellService.getReports(widget.cellId);
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 🔥 FUNDO PRETO
      appBar: AppBar(
        title: const Text("Relatórios"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: reports.isEmpty
          ? const Center(
              child: Text(
                "Nenhum relatório ainda",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final r = reports[index];

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReportDetailsPage(
                          report: r,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E), // 🔥 CARD ESCURO
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white10,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ================= DATA =================
                        Text(
                          formatDate(r.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // ================= RESUMO =================
                        Text(
                          "👥 ${r.newMembers.length} novos membros • ${r.newVisitors.length} visitantes",
                          style: const TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 6),

                        // ================= CONTRIBUIÇÃO =================
                        Text(
                          r.hadContribution
                              ? "💰 R\$ ${r.contributionValue?.toStringAsFixed(2).replaceAll('.', ',')}"
                              : "Sem contribuição",
                          style: TextStyle(
                            color: r.hadContribution
                                ? Colors.greenAccent
                                : Colors.white38,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ================= DESCRIÇÃO =================
                        Text(
                          r.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // ================= BOTÃO =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReportPage(cellId: widget.cellId),
            ),
          );

          setState(() {
            _loadReports();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}