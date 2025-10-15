import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PostService {

  final baseUrl = 'http://localhost:4000/posts';
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

  Future<http.Response> updatePost() async {

  }

  Future<http.Response> deletePost() async {

  }

  Future<http.Response> getPost() async {

  }

  Future<http.Response> getPosts() async {

  }
  
}