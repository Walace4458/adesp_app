import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/auth_storage.dart';

class ApiService {
  static const String baseUrl = "http://172.22.57.193:3000";

  static final AuthStorage _storage = AuthStorage();

  // =========================
  // 🔥 GET
  // =========================
  static Future<dynamic> get(String endpoint) async {
    final token = await _storage.getAccessToken();

    print('🌐 GET: $baseUrl$endpoint');
    print('🔑 TOKEN: $token');

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  // =========================
  // 🔥 POST
  // =========================
  static Future<dynamic> post(String endpoint, Map body) async {
    final token = await _storage.getAccessToken();

    print('🌐 POST: $baseUrl$endpoint');
    print('📦 BODY: $body');
    print('🔑 TOKEN: $token');

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // =========================
  // 🔥 RESPONSE HANDLER
  // =========================
  static dynamic _handleResponse(http.Response response) {
    print('📡 STATUS: ${response.statusCode}');
    print('📡 RESPONSE: ${response.body}');

    final data = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : null;

    // ✅ sucesso
    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    }

    // ❌ erro de autenticação
    if (response.statusCode == 401) {
      throw Exception(data?['error'] ?? 'Não autorizado');
    }

    // ❌ outros erros
    throw Exception(data?['error'] ?? 'Erro na requisição');
  }
}