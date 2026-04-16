import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import '../../controllers/auth_controllers.dart';
import '../../../../main/main_page.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String fullText =
      "ADESP • Sua casa espiritual.\nFique por dentro de tudo.";
  String displayedText = "";

  @override
  void initState() {
    super.initState();

    _initApp();
    _startAnimations();
    _startTyping();
  }

  // 🔥 INICIALIZA LOGIN + NAVEGA
  Future<void> _initApp() async {
    final auth = context.read<AuthController>();

    await auth.loadLogin();

    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            auth.isLogged ? const MainPage() : const LoginScreen(),
      ),
    );
  }

  // 🎬 ANIMAÇÃO DA LOGO
  void _startAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.forward();
  }

  // ⌨️ TEXTO DIGITANDO
  void _startTyping() async {
    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 35));
      if (!mounted) return;
      setState(() {
        displayedText += fullText[i];
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🎬 LOGO ANIMADA
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ⌨️ TEXTO DIGITANDO
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  displayedText,
                  key: ValueKey(displayedText),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}