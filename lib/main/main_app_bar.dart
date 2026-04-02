import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/midiapage/midia_page.dart';
import 'package:flutter_application_1/features/notifications/notifications_page.dart';

PreferredSizeWidget? buildMainAppBar(
  BuildContext context,
  int currentIndex,
  int unreadCount, {
  ValueChanged<MidiaFilter>? onMidiaFilterSelected,
}) {
  final bool center = currentIndex == 2;

  switch (currentIndex) {

    // =========================
    // 🎬 MÍDIA
    // =========================
    case 0:
      return AppBar(
        centerTitle: true,
        title: Text(
          'MÍDIA',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          PopupMenuButton<MidiaFilter>(
            icon: const Icon(Icons.tune_rounded),
            onSelected: (value) {
              onMidiaFilterSelected?.call(value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: MidiaFilter.all, child: Text('Todos')),
              PopupMenuItem(value: MidiaFilter.recents, child: Text('Recentes')),
              PopupMenuItem(value: MidiaFilter.featured, child: Text('Destaques')),
              PopupMenuItem(value: MidiaFilter.popular, child: Text('Populares')),
              PopupMenuItem(value: MidiaFilter.continueWatching, child: Text('Continuar assistindo')),
            ],
          ),
        ],
      );

    // =========================
    // 📅 AGENDA (SEM APPBAR)
    // =========================
    case 1:
      return null;

    // =========================
    // 🏠 HOME
    // =========================
    case 2:
      return AppBar(
        centerTitle: true,
        title: Text(
          'ADESP',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded),

                if (unreadCount > 0)
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      height: 16,
                      constraints: const BoxConstraints(minWidth: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Theme.of(context).appBarTheme.backgroundColor ??
                              Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
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
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsPage(),
                ),
              );
            },
          ),
        ],
      );

    // =========================
    // 💼 GABINETE
    // =========================
    case 3:
      return AppBar(
        centerTitle: center,
        title: Text(
          'Gabinete',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent_rounded),
            onPressed: () {},
          ),
        ],
      );

    // =========================
    // ⚙️ MAIS
    // =========================
    case 4:
      return AppBar(
        centerTitle: center,
        title: Text(
          'Mais opções',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {},
          ),
        ],
      );

    default:
      return AppBar(
        title: Text(
          'ADESP',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
  }
}