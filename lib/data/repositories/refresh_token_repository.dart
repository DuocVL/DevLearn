import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/refresh_token_service.dart';

class RefreshTokenRepository {

  final _refreshTokenService = RefreshTokenService();
  final _storage = const FlutterSecureStorage();

  /// Calls backend refresh and updates stored tokens. Returns true on success.
  Future<bool> refreshToken() async {
    final res = await _refreshTokenService.refreshToken();

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final access = data['accessToken'] ?? data['access_token'];
      final refresh = data['refreshToken'] ?? data['refresh_token'];
      if (access != null) await _storage.write(key: 'access_token', value: access.toString());
      if (refresh != null) await _storage.write(key: 'refresh_token', value: refresh.toString());
      return true;
    }
    return false;
  }

}