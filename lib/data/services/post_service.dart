import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PostService {

  final baseUrl = 'http://localhost:4000/posts/';
  final _storage = const FlutterSecureStorage();

  Future<http.Response> addPost(String title, String content, List<String> tags, bool anonymous) async {

    final url = Uri.parse(baseUrl);
    final token = _storage.read(key: 'asset_token');

    final reponse = http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({ title, content, tags, anonymous }),
    );

    return reponse;
  }

  Future<http.Response> updatePost(String? title, String? content, List<String>? tags, bool? anonymous, bool? hiden) async {
    final url = Uri.parse(baseUrl);
    final token = _storage.read(key: 'asset_token');

    final reponse = http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({ title, content, tags, anonymous, hiden }),
    );

    return reponse;
  }

  Future<http.Response> deletePost(String postId) async {
    final url = Uri.parse(baseUrl);
    final token = _storage.read(key: 'asset_token');

    final reponse = http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({ postId }),
    );
    
    return reponse;
  }

  Future<http.Response> getPost(String postId) async {
    final url = Uri.http(
      baseUrl,
      postId,
    );
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