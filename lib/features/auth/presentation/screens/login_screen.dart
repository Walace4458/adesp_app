import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controllers.dart'; 
import '../../../../main/main_page.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = false; // 🔥 NOVO

  void handleLogin() async {
    final auth = context.read<AuthController>();

    final success = await auth.login(
      emailController.text.trim(),
      passwordController.text.trim(),
      remember: rememberMe, // 🔥 ESSENCIAL
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // 🔥 LOGO
              Image.asset(
                'assets/images/logo.png',
                height: 100,
              ),

              const SizedBox(height: 30),

              Text(
                'Bem-vindo de volta',
                style: theme.textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              Text(
                'Entre para continuar',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              // EMAIL
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // SENHA
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔥 CHECKBOX MANTER CONECTADO
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text("Manter conectado"),
                ],
              ),

              const SizedBox(height: 10),

              // BOTÃO LOGIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: auth.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Entrar'),
                ),
              ),

              // ERRO
              if (auth.error != null) ...[
                const SizedBox(height: 10),
                Text(
                  auth.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],

              const SizedBox(height: 30),

              // DIVISOR
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("ou"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              // GOOGLE LOGIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    // implementar depois
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Entrar com Google'),
                ),
              ),

              const SizedBox(height: 20),

              // REGISTRAR
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text('Não tem conta? Criar conta'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}