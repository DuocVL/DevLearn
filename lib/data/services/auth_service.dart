import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  AuthService({String? baseUrl}) : baseurl = baseUrl ?? _envOrDefault();

  final String baseurl;

  static String _envOrDefault() {
    final env = dotenv.env['BACKEND_URL'];
    if (env != null && env.isNotEmpty) return '${env.replaceAll(RegExp(r'/$'), '')}/auth';
    // Default to Android emulator host if BACKEND_URL not provided.
    return 'http://10.0.2.2:4000/auth';
  }
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _jsonHeaders([String? token]) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    final t = token ?? await _storage.read(key: 'access_token');
    if (t != null && t.isNotEmpty) headers['Authorization'] = 'Bearer $t';
    return headers;
  }

  Future<http.Response> getProfile() async {
    final url = Uri.parse('$baseurl/me');
    final response = await http.get(url, headers: await _jsonHeaders());
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseurl/login');
    final response = await http.post(
      url,
      headers: await _jsonHeaders(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    return response;
  }

  /// If [refreshToken] provided, it's sent in body to revoke that specific refresh token.
  Future<http.Response> logout([String? refreshToken]) async {
    final url = Uri.parse('$baseurl/logout');
    if (refreshToken != null && refreshToken.isNotEmpty) {
      return await http.post(url, headers: await _jsonHeaders(), body: jsonEncode({ 'refreshToken': refreshToken }));
    }
    return await http.post(url, headers: await _jsonHeaders());
  }

  Future<http.Response> changePassword(String currentPassword, String newPassword) async {
    final url = Uri.parse('$baseurl/change-password');
    final response = await http.post(
      url,
      headers: await _jsonHeaders(),
      body: jsonEncode({'currentPassword': currentPassword, 'newPassword': newPassword}),
    );
    return response;
  }

  Future<http.Response> sendResetCode(String email) async {
    final url = Uri.parse('$baseurl/forgot/send-code');
    final response = await http.post(
      url,
      headers: await _jsonHeaders(),
      body: jsonEncode({'email': email}),
    );
    return response;
  }

  Future<http.Response> resetPassword(String email, String code, String newPassword) async {
    final url = Uri.parse('$baseurl/forgot/reset');
    final response = await http.post(
      url,
      headers: await _jsonHeaders(),
      body: jsonEncode({'email': email, 'code': code, 'newPassword': newPassword}),
    );
    return response;
  }

  // OAuth endpoints: expect backend to exchange tokens/codes and return access tokens
  Future<http.Response> loginWithGoogle(String idToken) async {
    final url = Uri.parse('$baseurl/oauth/google');
    final response = await http.post(
      url,
      headers: await _jsonHeaders(),
      body: jsonEncode({'idToken': idToken}),
    );
    return response;
  }

  Future<http.Response> loginWithGithub(String code) async {
    final url = Uri.parse('$baseurl/oauth/github');
    final response = await http.post(
      url,
      headers: await _jsonHeaders(),
      body: jsonEncode({'code': code}),
    );
    return response;
  }

  Future<http.Response> register(String username, String email, String password) async {
    final url = Uri.parse('$baseurl/register');
    final response = await http.post(
      url,
      headers: await _jsonHeaders(),
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );
    return response;
  }
}
