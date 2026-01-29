import 'package:flutter/material.dart';
import 'home/agenda_page.dart';
import 'home/gabinete_page.dart';
import 'home/home_page.dart';
import 'home/mais_page.dart';
import 'home/midia_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

@override
  State<MainPage> createState() => _MainPageState ();
}

class _MainPageState extends State<MainPage>{
 int _currentIndex = 2;

  final _pages = [MidiaPage(), AgendaPage(), HomePage(), GabinetePage(), MaisPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ADESP', style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: (){}
            )
          ],
      ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(icon: Icon(Icons.ondemand_video_rounded) , label: "Mídia",),
          BottomNavigationBarItem(icon:Icon(Icons.calendar_month_rounded), label: "Agenda" ,),
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.forum_rounded), label: "Gabinete"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: "Mais"),
        ]),
      );
  }
}

