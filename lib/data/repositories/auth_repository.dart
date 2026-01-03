import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/user.dart';
import 'package:devlearn/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final ApiClient _apiClient = apiClient; // Sử dụng ApiClient toàn cục
  final _secureStorage = const FlutterSecureStorage();
  static const String _authTokenKey = 'auth_token';

  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: _authTokenKey);
    return token != null;
  }

  Future<User?> getProfile() async {
    try {
      final response = await _apiClient.get('/auth/profile');
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
      if (response.statusCode == 200 && response.data['token'] != null) {
        await _secureStorage.write(key: _authTokenKey, value: response.data['token']);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );
       if (response.statusCode == 201 && response.data['token'] != null) {
        await _secureStorage.write(key: _authTokenKey, value: response.data['token']);
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
      final response = await _apiClient.post('/auth/forgot/send-code', data: {'email': email});
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> resetPassword(String email, String code, String newPassword) async {
    try {
      final response = await _apiClient.post(
        '/auth/forgot/reset',
        data: {'email': email, 'code': code, 'newPassword': newPassword},
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginWithGoogle(String idToken) async {
    try {
      final response = await _apiClient.post('/auth/oauth/google', data: {'idToken': idToken});
      if (response.statusCode == 200 && response.data['token'] != null) {
        await _secureStorage.write(key: _authTokenKey, value: response.data['token']);
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
      if (response.statusCode == 200 && response.data['token'] != null) {
        await _secureStorage.write(key: _authTokenKey, value: response.data['token']);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _authTokenKey);
    // Tùy chọn: Gọi một điểm cuối đăng xuất phía máy chủ
    // await _apiClient.post('/auth/logout');
  }
}
