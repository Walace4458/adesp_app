import 'package:flutter/material.dart';

class TodayAgendaCard extends StatelessWidget{
 
  final String title;
  final String dataLabel;
  final String eventName;
  final VoidCallback? onTap;

  const TodayAgendaCard ({
    super.key,
    required this.title,
    required this.dataLabel,
    required this.eventName,
    this.onTap
  });
 
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 26,
              color: Theme.of(context).colorScheme.primary,
              
            ),
            SizedBox(width: 12,),
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium,),
            SizedBox(height: 6,),
            Text(dataLabel, style: Theme.of(context).textTheme.bodyMedium,),
            SizedBox(height: 4,),
            Text(eventName, style: Theme.of(context).textTheme.bodySmall,),
          ],
        ),
          ], 
        ),
        ),
        ),
      );
  }
}