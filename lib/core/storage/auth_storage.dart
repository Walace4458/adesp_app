import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // =========================
  // SALVAR TOKENS
  // =========================
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    // 🔥 evita salvar token inválido
    if (accessToken.isEmpty) {
      throw Exception("AccessToken vazio não pode ser salvo");
    }

    await _storage.write(
      key: _accessTokenKey,
      value: accessToken,
    );

    // só salva refresh token se for válido
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(
        key: _refreshTokenKey,
        value: refreshToken,
      );
    }
  }

  // =========================
  // GET ACCESS TOKEN
  // =========================
  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: _accessTokenKey);

    // 🔥 evita " " ou string vazia passando como válido
    if (token == null || token.isEmpty) {
      return null;
    }

    return token;
  }

  // =========================
  // GET REFRESH TOKEN
  // =========================
  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: _refreshTokenKey);

    if (token == null || token.isEmpty) {
      return null;
    }

    return token;
  }

  // =========================
  // LIMPAR TOKENS
  // =========================
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // =========================
  // 🔥 DEBUG (MUITO ÚTIL PRA VOCÊ AGORA)
  // =========================
  Future<void> debugPrintTokens() async {
    final access = await getAccessToken();
    final refresh = await getRefreshToken();

    print("🔐 ACCESS TOKEN: $access");
    print("🔐 REFRESH TOKEN: $refresh");
  }
}