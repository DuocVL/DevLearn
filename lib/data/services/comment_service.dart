import 'dart:convert';
import 'package:devlearn/data/models/request/comment_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class CommentService {
  
  final String baseUrl;
  CommentService({String? baseUrl}) : baseUrl = baseUrl ?? _envOrDefault();

  static String _envOrDefault() {
    final env = dotenv.env['BACKEND_URL'];
    if (env != null && env.isNotEmpty) return '${env.replaceAll(RegExp(r'/$'), '')}/comments';
    // Default to Android emulator host when BACKEND_URL not provided
    return 'http://10.0.2.2:4000/comments';
  }
  final _storage = const FlutterSecureStorage();

  Future<http.Response> addComment(CommentRequest request) async {

    final url = Uri.parse(baseUrl);
    final token = await _storage.read(key: 'access_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    return response;
  }

  Future<http.Response> updateComment(String commentId , String content ) async {
    final url = Uri.parse('$baseUrl/$commentId');
    final token = await _storage.read(key: 'access_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({ 'content': content }),
    );

    return response;
  }

  Future<http.Response> deletedComment( String commentId ) async {

    final url = Uri.parse('$baseUrl/$commentId');
    final token = await _storage.read(key: 'access_token');

    final response = await http.delete(
      url,
      headers: { if (token != null) 'Authorization': 'Bearer $token' },
    );

    return response;
  }

  Future<http.Response> getListComment( String targetId, String targetType, int page, int limit ) async {

    final uri = Uri.parse('$baseUrl/$targetType/$targetId').replace(queryParameters: {
      'page': '$page',
      'limit': '$limit',
    });
    final token = await _storage.read(key: 'access_token');

    final response = await http.get(
      uri,
      headers: { if (token != null) 'Authorization': 'Bearer $token' },
    );

    return response;
  }

  Future<http.Response> getListReply( String parentCommentId, int page , int limit ) async {

    final uri = Uri.parse('$baseUrl/$parentCommentId').replace(queryParameters: {
      'page': '$page',
      'limit': '$limit',
    });
    final token = await _storage.read(key: 'access_token');

    final response = await http.get(
      uri,
      headers: { if (token != null) 'Authorization': 'Bearer $token' },
    );

    return response;
  }


}