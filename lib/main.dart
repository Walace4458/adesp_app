import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/main_page.dart';
import 'core/theme/app_theme.dart';

void main () {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: AppTheme.darkTheme,
    );
  }
}