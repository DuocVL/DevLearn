import 'dart:convert';

import '../services/auth_service.dart' ;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {

  final _authService = AuthService();
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async{
    final res = await _authService.login(email, password);

    if(res.statusCode == 200){
      final data = jsonDecode(res.body);
      // Support multiple possible key names from backend
      final access = data['accessToken'] ?? data['assetToken'] ?? data['token'] ?? data['access_token'];
      final refresh = data['refreshToken'] ?? data['refresh_token'];

      if (access != null) await _storage.write(key: 'access_token', value: access.toString());
      if (refresh != null) await _storage.write(key: 'refresh_token', value: refresh.toString());
      return true;
    }else {
      return false;
    }

  }

  Future<bool> logout() async {
    final res = await _authService.logout();
    
    if(res.statusCode == 200){
      await _storage.deleteAll();

      return true;
    }else{
      return false;
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    final res = await _authService.changePassword(currentPassword, newPassword);
    return res.statusCode == 200;
  }

  Future<bool> register(String username, String email, String password) async {
    final res = await _authService.register(username, email, password);
    if (res.statusCode == 200) {
      // Optionally store tokens if backend returns them
      try {
        final data = jsonDecode(res.body);
        final access = data['accessToken'] ?? data['assetToken'] ?? data['token'] ?? data['access_token'];
        final refresh = data['refreshToken'] ?? data['refresh_token'];
        if (access != null) await _storage.write(key: 'access_token', value: access.toString());
        if (refresh != null) await _storage.write(key: 'refresh_token', value: refresh.toString());
      } catch (_) {}
      return true;
    }
    return false;
  }

  Future<bool> sendResetCode(String email) async {
    final res = await _authService.sendResetCode(email);
    return res.statusCode == 200;
  }

  Future<bool> resetPassword(String email, String code, String newPassword) async {
    final res = await _authService.resetPassword(email, code, newPassword);
    return res.statusCode == 200;
  }

  Future<bool> loginWithGoogle(String idToken) async {
    final res = await _authService.loginWithGoogle(idToken);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final access = data['accessToken'] ?? data['assetToken'] ?? data['token'] ?? data['access_token'];
      final refresh = data['refreshToken'] ?? data['refresh_token'];
      if (access != null) await _storage.write(key: 'access_token', value: access.toString());
      if (refresh != null) await _storage.write(key: 'refresh_token', value: refresh.toString());
      return true;
    }
    return false;
  }

  Future<bool> loginWithGithub(String code) async {
    final res = await _authService.loginWithGithub(code);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final access = data['accessToken'] ?? data['assetToken'] ?? data['token'] ?? data['access_token'];
      final refresh = data['refreshToken'] ?? data['refresh_token'];
      if (access != null) await _storage.write(key: 'access_token', value: access.toString());
      if (refresh != null) await _storage.write(key: 'refresh_token', value: refresh.toString());
      return true;
    }
    return false;
  }

}