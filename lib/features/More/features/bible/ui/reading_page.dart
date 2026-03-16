import 'package:flutter/material.dart';

import '../data/reading_plan_repository.dart';
import '../models/reading_plan.dart';

class ReadingPage extends StatelessWidget{
  const ReadingPage ({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ReadingPlanRepository();
    final readings = repository.getReadings();
    final bool completed;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leitura"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16), 
        itemCount: readings.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12,),
        itemBuilder: (context, index) {
          final reading = readings[index];

          return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                color: 
                Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _showReadingDetails (context, reading),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.menu_book_rounded, size: 22,),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Text(
                                reading.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            if (reading.completed)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'Concluído',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 10,),
                        Text(
                          '${reading.book} ${reading.chapter}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          reading.day,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        if (reading.description != null) ...[
                          const SizedBox(height: 10,),
                          Text(
                            reading.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 14,),
                        LinearProgressIndicator(
                          value: reading.progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          reading.completed
                            ? '100% lido' : '${(reading.progress * 100). toInt()}% lido',
                            style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }, 
      ),
    );
  }

  void _showReadingDetails(BuildContext context, ReadingPlan reading) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ), 
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reading.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8,),
                Text(
                  '${reading.book} ${reading.chapter}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4,),
                Text(
                  reading.day,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                if (reading.comment != null) ...[
                  const SizedBox(height: 16,),
                  Text(reading.comment!),
                ],
                const SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const Text('Abrir leitura'),
                  ),
                ),
              ],
            ),
          ),
        );
        
      },
    );
  }
}
class ReadingProgressService {
  final Set<String> _completedReadings = {};

  bool isCompleted(String readingId) {
    return _completedReadings.contains(readingId);
  }

  void markAsRead(String readingId) {
    _completedReadings.add(readingId);
  }

  void unmarkAsRead(String readingId) {
    _completedReadings.remove(readingId);
  }
}