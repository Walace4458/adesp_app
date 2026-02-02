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

  AppBar _buildAppBar(BuildContext context) {
    final bool center = _currentIndex == 2;
    switch (_currentIndex) {
    case 0: // Mídia
      return AppBar(
        centerTitle: true,
        title: Text('MÍDIA', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune_rounded),
            onSelected: (value) {
              // aqui depois você liga com backend/filtro real
              // por enquanto só teste/print
              // ignore: avoid_print
              print('Filtro Mídia: $value');
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'recentes', child: Text('Recentes')),
              PopupMenuItem(value: 'populares', child: Text('Populares')),
              PopupMenuItem(value: 'ao_vivo', child: Text('Ao vivo')),
            ],
          ),
        ],
      );

    case 1: // Agenda
      return AppBar(
        centerTitle: center,
        title: Text('Agenda do mês', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: () {
              // depois: abrir calendário / seletor de mês
            },
          ),
        ],
      );

    case 2: // Home
      return AppBar(
        centerTitle: true,
        title: Text('ADESP', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              // depois: abrir notificações
            },
          ),
        ],
      );

    case 3: // Gabinete
      return AppBar(
        centerTitle: center,
        title: Text('Gabinete', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent_rounded),
            onPressed: () {
              // depois: abrir chat/atendimento
            },
          ),
        ],
      );

    case 4: // Mais
      return AppBar(
        centerTitle: center,
        title: Text('Mais opções', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          // “perfil do usuário do lado”
          IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: () {
              // depois: abrir página de perfil/conta
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              // depois: abrir configurações
            },
          ),
        ],
      );

    default:
      return AppBar(
        title: Text('ADESP', style: Theme.of(context).textTheme.titleMedium),
      );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
        body: _pages[_currentIndex],
        bottomNavigationBar: SafeArea(
          child: Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                    color: Colors.black.withValues(alpha: 89)
                  )
                ]
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
          BottomNavigationBarItem(icon: Icon(Icons.ondemand_video_rounded) , label: "Mídia",),
          BottomNavigationBarItem(icon:Icon(Icons.calendar_month_rounded), label: "Agenda" ,),
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.forum_rounded), label: "Gabinete"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: "Mais"),
        ]
              ),
            ),
            ),
          ),
          ),
    );
  }
}

