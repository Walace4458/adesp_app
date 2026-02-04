import 'package:flutter/material.dart';
import 'notifications_new_tab.dart';
import 'notifications_read_tab.dart';

class NotificationsPage extends StatefulWidget{
  const NotificationsPage({super.key});

  @override State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
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
    body: TabBarView(children: [NewTab(), ReadTab()]),
   ));
  }
}