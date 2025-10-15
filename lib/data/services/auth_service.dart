import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {

  final baseurl = 'http://localhost:4000/auth';
  final _storage = const FlutterSecureStorage();

  Future<http.Response> login (String email, String password) async{
      final url = Uri.parse('$baseurl/login');
      final reponse = http.post(
        url,
        headers: {  },
        body: jsonEncode({ email, password })
      );

      return reponse;
  }

  Future<http.Response> logout() async {
    final url = Uri.parse('$baseurl/logout');
    final token = await _storage.read(key: 'access_token');

    final reponse = http.post(
      url,
      headers: { 
        'Content-Type': 'application/json',
        'Authorzation': 'Bearer $token',
      }
    );

    return reponse;
  }

}