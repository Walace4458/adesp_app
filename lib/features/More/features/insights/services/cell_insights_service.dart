import '../../cells/models/member_model.dart';
import '../../cells/models/report_model.dart';

import '../models/insight_item.dart';
import '../enums/insight_action_type.dart';
import '../enums/insight_type.dart';

class CellInsightsService {
  List<InsightItem> generateInsights({
    required List<MemberModel> members,
    required List<ReportModel> reports,
  }) {
    final List<InsightItem> insights = [];

    if (reports.isEmpty || members.isEmpty) return insights;

    // 🔥 NÃO muta lista original
    final sortedReports = [...reports]
      ..sort((a, b) => b.date.compareTo(a.date));

    final recentReports = sortedReports.take(2).toList();

    insights.addAll(_generateAbsentMembersInsight(members, recentReports));
    insights.addAll(_generateVisitorsInsight(recentReports));

    return insights;
  }

  // =========================
  // 🔥 AUSENTES (COM NOMES)
  // =========================
  List<InsightItem> _generateAbsentMembersInsight(
    List<MemberModel> members,
    List<ReportModel> reports,
  ) {
    if (reports.isEmpty) return [];

    final absentIds = <String>[];

    for (final member in members) {
      int absences = 0;

      for (final report in reports) {
        if (!report.presentMemberIds.contains(member.id)) {
          absences++;
        }
      }

      // 🔥 regra: faltou nas últimas 2 reuniões
      if (absences >= 2) {
        absentIds.add(member.id);
      }
    }

    if (absentIds.isEmpty) return [];

    final relatedNames = members
        .where((m) => absentIds.contains(m.id))
        .map((e) => e.name)
        .toList();

    final preview = relatedNames.take(2).join(', ');

    final text = relatedNames.length > 2
        ? "$preview e +${relatedNames.length - 2} não vêm há semanas"
        : "$preview não vêm há semanas";

    return [
      InsightItem(
        type: InsightType.alert,
        title: "Pessoas ausentes",
        description: text,
        relatedPeopleIds: absentIds,
        relatedNames: relatedNames, // 🔥 NOVO
        actionType: InsightActionType.openMemberDetails,
      ),
    ];
  }

  // =========================
  // 🔥 VISITANTES (COM NOMES)
  // =========================
  List<InsightItem> _generateVisitorsInsight(List<ReportModel> reports) {
    final visitorNames = <String>[];

    for (final report in reports) {
      visitorNames.addAll(report.newVisitors);
    }

    if (visitorNames.isEmpty) return [];

    final preview = visitorNames.take(2).join(', ');

    final text = visitorNames.length > 2
        ? "$preview e +${visitorNames.length - 2} visitantes"
        : "$preview visitante(s) recente(s)";

    return [
      InsightItem(
        type: InsightType.positive,
        title: "Novos visitantes",
        description: text,
        relatedPeopleIds: [], // não tem ID mesmo
        relatedNames: visitorNames, // 🔥 ESSENCIAL PRA CORRIGIR SEU BUG
        actionType: InsightActionType.openVisitorsList,
      ),
    ];
  }
}