import '../models/member_model.dart';
import '../models/report_model.dart';
import '../models/member_stats_model.dart';

class MemberStatsService {
  static MemberStatsModel calculate({
    required MemberModel member,
    required List<ReportModel> reports,
  }) {
    int presences = 0;
    int absences = 0;
    int consecutiveAbsences = 0;

    for (final report in reports) {
      final isPresent = report.presentMemberIds.contains(member.id);

      if (isPresent) {
        presences++;
      } else {
        absences++;
      }
    }

    //consecutivas (últimos relatórios)
    for (final report in reports) {
      if (!report.presentMemberIds.contains(member.id)) {
        consecutiveAbsences++;
      } else {
        break;
      }
    }

    final total = presences + absences;

    return MemberStatsModel(
      totalPresences: presences, 
      totalAbsences: absences, 
      presencePercentage: total == 0 ? 0 : presences / total, 
      consecutiveAbsences: consecutiveAbsences,
    );
  }
}