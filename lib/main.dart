import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/main/main_page.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';

// ✅ IMPORT DO CONTROLLER
import 'package:flutter_application_1/features/gabinete/state/gabinete_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ✅ REGISTRA O CONTROLLER GLOBAL
        ChangeNotifierProvider(
          create: (_) => GabineteController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainPage(),
      ),
    );
  }
}