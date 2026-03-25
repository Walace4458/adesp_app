import 'dart:math';
import 'package:flutter/material.dart';

import '../models/report_model.dart';
import '../services/cell_service.dart';
import 'report_page.dart';
import 'report_history_page.dart';

class DashboardPage extends StatefulWidget {
  final String cellId;

  const DashboardPage({
    super.key,
    required this.cellId,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<ReportModel> reports;
  late List<ReportModel> last7DaysReports;

  int membersCount = 0;
  int interestedCount = 0;

  int totalMembers7Days = 0;
  int totalVisitors7Days = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    reports = CellService.getReports(widget.cellId);

    reports.sort((a, b) => a.date.compareTo(b.date));

    final now = DateTime.now();

    last7DaysReports = reports.where((r) {
      final diff = now.difference(r.date).inDays;
      return diff >= 0 && diff <= 7;
    }).toList();

    totalMembers7Days =
        last7DaysReports.fold(0, (sum, r) => sum + r.newMembers.length);

    totalVisitors7Days =
        last7DaysReports.fold(0, (sum, r) => sum + r.newVisitors.length);

    membersCount = CellService.getMembers(widget.cellId).length;
    interestedCount = CellService.getInterested(widget.cellId).length;
  }

  @override
  Widget build(BuildContext context) {
    final lastReport = reports.isNotEmpty ? reports.last : null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Visão Geral",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _stat("Membros", membersCount),
                          _stat("Interessados", interestedCount),
                        ],
                      ),
                    ],
                  ),
                ),

                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Distribuição (últimos 7 dias)",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        height: 200,
                        child: CustomPaint(
                          painter: _PieChartPainter(
                            members: totalMembers7Days,
                            visitors: totalVisitors7Days,
                          ),
                          child: Container(), // 🔥 ESSENCIAL
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _legend(Colors.greenAccent, "Membros", totalMembers7Days),
                          _legend(Colors.blueAccent, "Visitantes", totalVisitors7Days),
                        ],
                      ),

                      if (totalMembers7Days == 0 && totalVisitors7Days == 0)
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Sem dados nos últimos 7 dias",
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                    ],
                  ),
                ),

                _card(
                  child: lastReport == null
                      ? const Text(
                          "Nenhum relatório ainda",
                          style: TextStyle(color: Colors.white70),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Último Relatório",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              lastReport.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white70),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "👥 ${lastReport.newMembers.length} membros • ${lastReport.newVisitors.length} visitantes",
                              style: const TextStyle(color: Colors.white),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              lastReport.hadContribution
                                  ? "💰 R\$ ${lastReport.contributionValue?.toStringAsFixed(2).replaceAll('.', ',')}"
                                  : "Sem contribuição",
                              style: TextStyle(
                                color: lastReport.hadContribution
                                    ? Colors.greenAccent
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                ),

                _card(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ReportPage(cellId: widget.cellId),
                              ),
                            );

                            setState(() => _loadData());
                          },
                          child: const Text("Novo Relatório"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReportHistoryPage(
                                  cellId: widget.cellId,
                                ),
                              ),
                            );

                            setState(() => _loadData());
                          },
                          child: const Text("Ver Histórico"),
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

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _stat(String title, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        )
      ],
    );
  }

  Widget _legend(Color color, String label, int value) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 6),
        Text(
          "$label ($value)",
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

// ================= PIE CHART =================

class _PieChartPainter extends CustomPainter {
  final int members;
  final int visitors;

  _PieChartPainter({
    required this.members,
    required this.visitors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = members + visitors;
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final paintMembers = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;

    final paintVisitors = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    final membersAngle = (members / total) * 2 * pi;
    final visitorsAngle = (visitors / total) * 2 * pi;

    double startAngle = -pi / 2;

    canvas.drawArc(rect, startAngle, membersAngle, true, paintMembers);

    startAngle += membersAngle;

    canvas.drawArc(rect, startAngle, visitorsAngle, true, paintVisitors);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}