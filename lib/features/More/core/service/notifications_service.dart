import '../../features/cells/models/member_model.dart';

class NotificationService {
  static void checkAlerts(List<MemberModel> members) {
    for (final m in members) {
      if (m.isBirthday) {
        // DEBUG (console)
        print("🎂 Hoje é aniversário de ${m.name}");
      }
    }
  }
}