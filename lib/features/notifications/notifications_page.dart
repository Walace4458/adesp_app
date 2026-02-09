import 'package:flutter/material.dart';
import 'notifications_new_tab.dart';
import 'notifications_read_tab.dart';
import 'models/notifications_items.dart';

class NotificationsPage extends StatefulWidget{
  const NotificationsPage({super.key});

  @override State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

    final List<NotificationItem> _newItems =[
    NotificationItem(
      id: '1', 
      title: 'Culto Hoje', 
      message: 'Culto hoje às 20:00 horas. Não falte!', 
      dateLabel: 'Hoje • 18:30')
  ];

  
  final List<NotificationItem> _readItems = [
    NotificationItem(
      id: '2', 
      title: 'Culto Amanhã', 
      message: "Cultuo amanhã às 18:00 horas. Não falte!", 
      dateLabel: 'Aamanhã • 18:30')
  ];

  void _markAsRead(NotificationItem notif) {
    setState(() {
      _newItems.removeWhere((n) => n.id == notif.id);
      _readItems.insert(0, notif);
    });
  }

  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
    length: 2,
   child: Scaffold(
    appBar: AppBar(
      bottom: const TabBar(tabs: [Tab(text: 'Novas',), Tab(text: 'Lidas',)]),
      centerTitle: true,
      title: Text('Notíficações', style: Theme.of(context).textTheme.titleMedium,),
    ),
    body: TabBarView(children: [NewTab(items: _newItems, onMarkAsRead: _markAsRead), ReadTab(items: _readItems)]), 
   ));
  }
}