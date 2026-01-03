import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProblemService {
  ProblemService({String? baseUrl}) : _baseUrl = baseUrl ?? _envOrDefault();

  final String _baseUrl;
  final _storage = const FlutterSecureStorage();

  static String _envOrDefault() {
    final env = dotenv.env['BACKEND_URL'];
    if (env != null && env.isNotEmpty) return '${env.replaceAll(RegExp(r'/$'), '')}/problems';
    // Default to Android emulator host when BACKEND_URL not provided
    return 'http://10.0.2.2:4000/problems';
  }

  Future<http.Response> getProblems({int page = 1, int limit = 20, String? difficulty, String? tag}) async {
    final query = <String, String>{'page': '$page', 'limit': '$limit'};
    if (difficulty != null) query['difficulty'] = difficulty;
    if (tag != null) query['tag'] = tag;
    final uri = Uri.parse(_baseUrl).replace(queryParameters: query);
    final token = await _storage.read(key: 'access_token');
    final response = await http.get(uri, headers: <String, String>{'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'});
    return response;
  }

  Future<http.Response> getProblem(String problemId) async {
    final uri = Uri.parse('$_baseUrl/$problemId');
    final token = await _storage.read(key: 'access_token');
    final response = await http.get(uri, headers: <String, String>{'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'});
    return response;
  }
}