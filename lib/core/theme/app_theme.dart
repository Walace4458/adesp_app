import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: ColorStyle.fundoPrincipal,
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
  );
}