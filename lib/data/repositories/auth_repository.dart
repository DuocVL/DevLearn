import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/user.dart';
import 'package:devlearn/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final ApiClient _apiClient = apiClient;
  final _secureStorage = const FlutterSecureStorage();

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: accessTokenKey, value: accessToken);
    await _secureStorage.write(key: refreshTokenKey, value: refreshToken);
  }

  Future<User?> checkAuth() async {
    final hasToken = await _secureStorage.containsKey(key: accessTokenKey);
    if (hasToken) {
      return getProfile();
    }
    return null;
  }

  Future<User?> getProfile() async {
    try {
      final response = await _apiClient.get('/users/profile');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        await _saveTokens(response.data['accessToken'], response.data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        data: {'username': username, 'email': email, 'password': password},
      );
      return response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _secureStorage.read(key: refreshTokenKey);
    if (refreshToken == null) return false;

    try {
      final response = await _apiClient.post(
        '/refresh',
        data: {'refreshToken': refreshToken},
      );
      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        await _saveTokens(response.data['accessToken'], response.data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      await logout();
      return false;
    }
  }

  Future<void> logout() async {
    final refreshToken = await _secureStorage.read(key: refreshTokenKey);
    if (refreshToken != null) {
      try {
        await _apiClient.post('/auth/logout', data: {'refreshToken': refreshToken});
      } catch (e) {
        print("Failed to logout from server: $e");
      }
    }
    await _secureStorage.delete(key: accessTokenKey);
    await _secureStorage.delete(key: refreshTokenKey);
  }

  Future<bool> loginWithGoogle(String idToken) async {
    try {
      final response = await _apiClient.post('/auth/oauth/google', data: {'idToken': idToken});
      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        await _saveTokens(response.data['accessToken'], response.data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginWithGithub(String code) async {
    try {
      final response = await _apiClient.post('/auth/oauth/github', data: {'code': code});
      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        await _saveTokens(response.data['accessToken'], response.data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendResetCode(String email) async {
    try {
      final response = await _apiClient.post('/auth/forgot-password', data: {'email': email});
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> resetPassword(String email, String code, String newPassword) async {
    try {
      final response = await _apiClient.post(
        '/auth/reset-password',
        data: {'email': email, 'code': code, 'newPassword': newPassword},
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
