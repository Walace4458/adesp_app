import 'package:flutter/material.dart';
import '../features/agenda/agenda_page.dart';
import '../features/gabinete/gabinete_page.dart';
import '../features/home/home_page.dart';
import '../features/contribuição/mais_page.dart';
import '../features/midiapage/midia_page.dart';

import 'main_app_bar.dart';
import 'main_bottom_nav.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

@override
  State<MainPage> createState() => _MainPageState ();
}

class _MainPageState extends State<MainPage>{
 int _currentIndex = 2;
 int unreadCount = 1;
 MidiaFilter _midiaFilter = MidiaFilter.all;

  @override
  Widget build(BuildContext context) {
    
    final _pages = [MidiaPage(filter: _midiaFilter), AgendaPage(), HomePage(), GabinetePage(), MaisPage()];
    
    return Scaffold(
      appBar: buildMainAppBar(context, _currentIndex, unreadCount, onMidiaFilterSelected: _currentIndex == 0 ? (filter) {
        setState(() => _midiaFilter = filter);
      }
      :null,
      ),
        body: _pages[_currentIndex],
        bottomNavigationBar: buildMainBottomNav(context, currentIndex: _currentIndex, onTap: (index){
          setState(() => _currentIndex = index);
        }),
    );
  }
}

