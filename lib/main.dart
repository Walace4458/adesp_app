import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_page.dart';

void main () {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: AppTheme.darkTheme,
    );
  }
}