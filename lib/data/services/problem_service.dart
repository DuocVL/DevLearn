import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProblemService {
  
  final baseUrl = 'http://localhost:4000/problem';
  final _storage = FlutterSecureStorage();

  Future<http.Response> getProblem(String problemId) async {
    final url = Uri.parse('$baseUrl/$problemId');
    final token = _storage.read(key: 'asset_token');

    final reponse = http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return reponse;
  }

}