import 'package:flutter/material.dart';

import '../models/member_model.dart';
import '../services/cell_service.dart';
import '../services/member_stats_service.dart';

class MemberDetailsPage extends StatelessWidget {
  final MemberModel member;
  final String cellId;

  const MemberDetailsPage({
    super.key,
    required this.member,
    required this.cellId,
  });

  @override
  Widget build(BuildContext context) {
    final reports = CellService.getReports(cellId);

    final stats = MemberStatsService.calculate(member: member, reports: reports);

    return Scaffold(
      appBar: AppBar(
        title: Text(member.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _card("Presenças", stats.totalPresences.toString()),
            _card("Faltas", stats.totalAbsences.toString()),
            _card("Frequência", "${(stats.presencePercentage * 100).toStringAsFixed(0)}%"),
            _card("Faltas seguidas", stats.consecutiveAbsences.toString()),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 6,),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}