import 'dart:convert';
import 'package:devlearn/data/models/post.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  final _storage = const FlutterSecureStorage();

  Future<List<Post>> getPosts({int page = 1, int limit = 20}) async {
    final baseUrl = dotenv.env['BACKEND_URL'];
    if (baseUrl == null) {
      throw Exception('BACKEND_URL not found in .env file');
    }

    final token = await _storage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('Access token not found');
    }

    final uri = Uri.parse('$baseUrl/posts').replace(
      queryParameters: {
        'page': '$page',
        'limit': '$limit',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // The backend returns { data: [...], pagination: {...} }
      final body = json.decode(response.body);
      final List<dynamic> postsJson = body['data'];
      return postsJson
          .map((json) => Post.fromJson(json))
          .toList();
    } else {
      final body = json.decode(response.body);
      final errorMessage = body['message'] ?? 'Failed to load posts';
      throw Exception(errorMessage);
    }
  }

  Future<Post> addPost(String title, String content, List<String> tags, bool anonymous) async {
    final baseUrl = dotenv.env['BACKEND_URL'];
    if (baseUrl == null) {
      throw Exception('BACKEND_URL not found in .env file');
    }

    final token = await _storage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'title': title,
        'content': content,
        'tags': tags,
        'anonymous': anonymous,
      }),
    );

    if (response.statusCode == 201) {
      final body = json.decode(response.body);
      return Post.fromJson(body['post']);
    } else {
      final body = json.decode(response.body);
      final errorMessage = body['message'] ?? 'Failed to create post';
      throw Exception(errorMessage);
    }
  }
}

