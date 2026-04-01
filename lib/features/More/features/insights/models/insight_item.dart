import '../enums/insight_action_type.dart';
import '../enums/insight_type.dart';

class InsightItem {
  final InsightType type;
  final String title;
  final String description;
  final List<String> relatedPeopleIds;
  final List<String> relatedNames;
  final InsightActionType actionType;

  InsightItem({
    required this.type,
    required this.title,
    required this.description,
    required this.relatedPeopleIds,
    required this.actionType,
    required this.relatedNames,
  });
}