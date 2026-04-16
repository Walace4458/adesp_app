import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/controllers/auth_controllers.dart';
import '/main/main_page.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    // 🔥 Aqui depois você vai usar token real
    final isLogged = auth.isLogged;

    if (isLogged) {
      return const MainPage();
    } else {
      return LoginScreen();
    }
  }
}