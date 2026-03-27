import '../../cells/models/member_model.dart';
import '../../cells/models/report_model.dart';

import '../models/insight_item.dart';
import '../enums/insight_action_type.dart';
import '../enums/insight_type.dart';

class CellInsightsService {

  List<InsightItem> generateInsights({
    required List<MemberModel> members,
    required List<ReportModel> reports, // ✅ CORRIGIDO
  }) {
    final List<InsightItem> insights = []; // ✅ nome corrigido

    if (reports.isEmpty || members.isEmpty) return insights;

    // ordena por data (mais recente primeiro)
    reports.sort((a, b) => b.date.compareTo(a.date));

    final recentReports = reports.take(2).toList();

    insights.addAll(_generateAbsentMembersInsight(members, recentReports));
    insights.addAll(_generateVisitorsInsight(reports));

    return insights; // ✅ ESSENCIAL
  }

  // =========================
  // FALTANTES
  // =========================
  List<InsightItem> _generateAbsentMembersInsight(
    List<MemberModel> members,
    List<ReportModel> reports, // ✅ CORRIGIDO
  ) {
    if (reports.isEmpty) return [];

    final absentIds = <String>[];

    for (final member in members) {
      bool wasAbsentAll = true;

      for (final report in reports) {
        if (report.presentMemberIds.contains(member.id)) {
          wasAbsentAll = false;
          break;
        }
      }

      if (wasAbsentAll) {
        absentIds.add(member.id);
      }
    }

    if (absentIds.isEmpty) return [];

    return [
      InsightItem(
        type: InsightType.alert,
        title: "Pessoas ausentes",
        description: "${absentIds.length} membro(s) não vêm há semanas",
        relatedPeopleIds: absentIds,
        actionType: InsightActionType.openMemberDetails,
      ),
    ];
  }

  // =========================
  // VISITANTES
  // =========================
  List<InsightItem> _generateVisitorsInsight(List<ReportModel> reports) {
    int totalVisitors = 0;

    for (final report in reports.take(2)) {
      totalVisitors += report.newVisitors.length; // ✅ CORRIGIDO
    }

    if (totalVisitors == 0) return [];

    return [
      InsightItem(
        type: InsightType.positive,
        title: "Novos visitantes",
        description: "$totalVisitors visitante(s) recentes",
        relatedPeopleIds: [],
        actionType: InsightActionType.openVisitorsList,
      ),
    ];
  }
}