import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PostService {
  PostService({String? baseUrl}) : _baseUrl = baseUrl ?? _envOrDefault();

  final String _baseUrl;
  final _storage = const FlutterSecureStorage();

  static String _envOrDefault() {
    final env = dotenv.env['BACKEND_URL'];
    if (env != null && env.isNotEmpty) return '${env.replaceAll(RegExp(r'/$'), '')}/posts';
    // Default to Android emulator host when BACKEND_URL not provided
    return 'http://10.0.2.2:4000/posts';
  }

  Future<http.Response> addPost(String title, String content, List<String> tags, bool anonymous) async {
    final uri = Uri.parse(_baseUrl);
    final token = await _storage.read(key: 'access_token');
    final response = await http.post(uri,
        headers: <String, String>{'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'},
        body: jsonEncode({'title': title, 'content': content, 'tags': tags, 'anonymous': anonymous}));
    return response;
  }

  Future<http.Response> getPosts({int page = 1, int limit = 20, String? tag}) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: <String, String>{'page': '$page', 'limit': '$limit', if (tag != null) 'tag': tag});
    final token = await _storage.read(key: 'access_token');
    final response = await http.get(uri, headers: <String, String>{'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'});
    return response;
  }

  Future<http.Response> getPost(String postId) async {
    final uri = Uri.parse('$_baseUrl/$postId');
    final token = await _storage.read(key: 'access_token');
    final response = await http.get(uri, headers: <String, String>{'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'});
    return response;
  }
}