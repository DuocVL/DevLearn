import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/user.dart';
import 'package:devlearn/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final ApiClient _apiClient = apiClient;
  final _secureStorage = const FlutterSecureStorage();

  // Cập nhật khóa để quản lý hai token (đã chuyển thành public)
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  // Lưu cả hai token
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

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );
      if (response.statusCode == 201 && response.data['accessToken'] != null) {
        await _saveTokens(response.data['accessToken'], response.data['refreshToken']);
        return true;
      }
      return false;
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
        '/auth/refresh-token', // Đảm bảo điểm cuối này tồn tại trên máy chủ của bạn
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        await _saveTokens(response.data['accessToken'], response.data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      await logout(); // Đăng xuất nếu không thể làm mới token
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: accessTokenKey);
    await _secureStorage.delete(key: refreshTokenKey);
  }

  // Các phương thức OAuth cũng cần được cập nhật để lưu cả hai token
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

  // Các phương thức khác không thay đổi
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
}
