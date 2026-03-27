import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/More/features/insights/enums/insight_type.dart';

import '../models/insight_item.dart';
import '../../cells/models/member_model.dart';

class CellInsightsWidget extends StatelessWidget{
  final List<InsightItem> insights;
  final List<MemberModel> members;
  final Function(InsightItem) onTap;

  const CellInsightsWidget ({
    super.key,
    required this.insights,
    required this.members,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox();

    return Column(
      children: insights.map((insight) {
        final names = insight.relatedPeopleIds
              .map((id) => members.firstWhere((m) => m.id == id).name).toList();
        final displayNames = _buildNames(names);

        return GestureDetector(
          onTap: () => onTap(insight),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _getColor(context, insight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(insight.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4,),
                Text(
                  displayNames.isNotEmpty ? "$displayNames • ${insight.description}"
                  : insight.description,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _buildNames(List<String> names) {
    if (names.isEmpty) return "";

    if (names.length <= 2) {
      return names.join(", ");
    }

    return "${names[0]}, ${names[1]} +${names.length -2}";
  }

  Color _getColor(BuildContext context, InsightItem insight) {
    switch (insight.type) {
      case InsightType.alert:
        return Colors.red.withValues(alpha: 0.1);
      case InsightType.positive:
        return Colors.green.withValues(alpha: 0.1);
      case InsightType.neutral:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }
}