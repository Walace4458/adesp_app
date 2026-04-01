import 'package:flutter/material.dart';

import '../models/insight_item.dart';
import '../enums/insight_type.dart';

class InsightCard extends StatelessWidget{
  final InsightItem insight;
  final VoidCallback onTap;

  const InsightCard ({
    super.key,
    required this.insight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _getColor(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(_getIcon(), color: Colors.black,),
            const SizedBox(
              width: 8,
            ),
            Expanded(child: Text(
              insight.description,
              style: const TextStyle(color: Colors.black),
            )),
          ],
        ),
      ),
    );
  }

  Color _getColor() {
    switch (insight.type) {
      case InsightType.alert:
        return Colors.red.withValues(alpha: 0.1);
      case InsightType.positive:
        return Colors.green.withValues(alpha: 0.1);
      case InsightType.neutral:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }

  IconData _getIcon() {
    switch (insight.type) {
      case InsightType.alert:
        return Icons.warning_rounded;
      case InsightType.positive:
        return Icons.trending_up_rounded;
      case InsightType.neutral:
        return Icons.info_outline_rounded;
    }
  }
}