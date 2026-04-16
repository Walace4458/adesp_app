import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/auth_gate.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/main/main_page.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';

// CONTROLLERS
import 'package:flutter_application_1/features/gabinete/state/gabinete_controller.dart';
import 'package:flutter_application_1/features/auth/controllers/auth_controllers.dart';

// TELA DE LOGIN
import 'package:flutter_application_1/features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GabineteController(),
        ),

        // 🔥 NOVO: AuthController
        ChangeNotifierProvider(
          create: (_) => AuthController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,

        // 🔥 AO INVÉS DE IR DIRETO PRA MAIN
        home: const SplashScreen(),
      ),
    );
  }
}