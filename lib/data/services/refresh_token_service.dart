import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RefreshTokenService {

  String get baseUrl {
    final env = dotenv.env['BACKEND_URL'];
    if (env != null && env.isNotEmpty) return '${env.replaceAll(RegExp(r'/$'), '')}/refresh';
    // Default to Android emulator host when BACKEND_URL not provided
    return 'http://10.0.2.2:4000/refresh';
  }
  final _storage = const FlutterSecureStorage();

  Future<http.Response> refreshToken() async{
    final url = Uri.parse(baseUrl);
    final token = await _storage.read(key: 'refresh_token');

    // Send POST with refreshToken in body (server expects JSON or header)
    final response = await http.post(
      url,
      headers: <String, String>{ 'Content-Type': 'application/json' },
      body: jsonEncode({ 'refreshToken': token }),
    );

    return response;
  }

}