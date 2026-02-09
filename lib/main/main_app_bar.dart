import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/notifications/notifications_page.dart';

AppBar  buildMainAppBar(BuildContext context, int currentIndex, int unreadCount) {
final bool center = currentIndex == 2;
switch (currentIndex) {
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
            icon: Stack(
              clipBehavior: Clip.none,
              children: [Icon(Icons.notifications_none_rounded), if(unreadCount>0) 
            Positioned(
              right: -1,
              top: -1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                height: 16,
                constraints: const BoxConstraints(minWidth: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Theme.of(context).appBarTheme.backgroundColor ??
                    Theme.of(context).colorScheme.surface,
                    width: 2,
                  )
                ),
                child: Center(
                  child: Text(
                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ))]),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()));
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