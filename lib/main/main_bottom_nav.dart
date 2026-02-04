import 'package:flutter/material.dart';

Widget buildMainBottomNav(
  BuildContext context, {
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return SafeArea(
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
                currentIndex: currentIndex,
          onTap: onTap,
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
    );
  }