import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../core/storage/auth_storage.dart';

class AuthController extends ChangeNotifier {
  bool isLoading = false;
  bool isLogged = false;
  String? error;

  static const String baseUrl = "http://172.22.57.193:3000";

  final AuthStorage _storage = AuthStorage();

  // =========================
  // 🔥 LOGIN
  // =========================
  Future<bool> login(String email, String password, {bool remember = false}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'senha': password,
        }),
      );

      print("🔐 LOGIN STATUS: ${response.statusCode}");
      print("🔐 LOGIN BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];

        if (token == null || token.toString().isEmpty) {
          error = "Token inválido retornado pelo backend";
          isLoading = false;
          notifyListeners();
          return false;
        }

        await _storage.saveTokens(
          accessToken: token,
          refreshToken: token,
        );

        isLogged = true;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = data['error'] ?? 'Erro ao fazer login';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("❌ LOGIN ERROR: $e");

      error = 'Erro de conexão com o servidor';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // =========================
  // 🔥 REGISTER (CORRIGIDO)
  // =========================
  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'), // 🔥 CORRIGIDO AQUI
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'senha': password,
        }),
      );

      print("🧾 REGISTER STATUS: ${response.statusCode}");
      print("🧾 REGISTER BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = data['error'] ?? 'Erro ao cadastrar';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("❌ REGISTER ERROR: $e");

      error = 'Erro de conexão com o servidor';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // =========================
  // 🔥 VERIFICAR LOGIN
  // =========================
  Future<void> loadLogin() async {
    final token = await _storage.getAccessToken();

    print("🔐 LOAD LOGIN TOKEN: $token");

    isLogged = token != null;
    notifyListeners();
  }

  // =========================
  // 🔥 LOGOUT
  // =========================
  Future<void> logout() async {
    await _storage.clearTokens();

    isLogged = false;
    notifyListeners();
  }

  // =========================
  // 🔥 PEGAR TOKEN
  // =========================
  Future<String?> getToken() async {
    return await _storage.getAccessToken();
  }

  // =========================
  // 🔥 LIMPAR ERRO
  // =========================
  void clearErro() {
    error = null;
    notifyListeners();
  }
}