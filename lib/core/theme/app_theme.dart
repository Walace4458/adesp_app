import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ColorStyle.fundoPrincipal,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF7C4DFF),
      surface: ColorStyle.fundoPrincipal,
      onSecondary: ColorStyle.fundoSuperficie,
      onPrimary: Colors.white,
      onSurface: ColorStyle.textoPrincipal,
    ),
   appBarTheme: AppBarTheme(
      backgroundColor: ColorStyle.fundoSuperficie,
      foregroundColor: ColorStyle.textoPrincipal,
    ),
    textTheme: TextTheme(
      titleMedium: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        color: ColorStyle.textoPrincipal,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: ColorStyle.textoPrincipal,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: ColorStyle.textoSecundario,
      ),
    ),
    cardTheme: CardThemeData(
      color: ColorStyle.fundoSuperficie,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xFF7C4DFF),
      unselectedItemColor: Color(0xFFB3B3B3),
      backgroundColor: ColorStyle.fundoSuperficie,
      elevation: 0,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      selectedIconTheme: const IconThemeData(size: 24),
      unselectedIconTheme: const IconThemeData(size: 24),
      
    )
  );
}