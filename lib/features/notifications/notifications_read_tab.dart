import 'package:flutter/material.dart';
import 'notifications_page_details.dart';
import 'models/notifications_items.dart';
import 'models/empty_state.dart';

class ReadTab extends StatelessWidget {

  final List<NotificationItem> items;

  const ReadTab({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {

    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.notifications_none_rounded,
        title: 'Sem novas notificações',
        subtitle: 'Quando houver algo novo, vai aparecer aqui.',
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final notif = items[index];

        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsPageDetails
              (title: notif.title, message: notif.message, date: notif.dateLabel)));
            },
            child: Padding(padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif.title, style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4,),
                Text(
                  "Toque para ver detalhes", style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            ),
            ),
          ),
        );
      }
    );
  }
}