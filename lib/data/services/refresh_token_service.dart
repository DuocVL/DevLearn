import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RefreshTokenService {

  final baseUrl = 'http://localhost:4000/refresh';
  final _storage = const FlutterSecureStorage();

  Future<http.Response> refreshToken() async{
    final url = Uri.parse(baseUrl);
    final token = _storage.read(key: 'refresh_token');

    final reponse = http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token'
      }
    );

    return reponse;
  }

}