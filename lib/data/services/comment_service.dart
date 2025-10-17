import 'dart:convert';
import 'package:devlearn/data/models/request/comment_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CommentService {
  
  final baseUrl = 'http://localhost:4000/comments';
  final _storage = const FlutterSecureStorage();

  Future<http.Response> addComment(CommentRequest request) async {

    final url = Uri.parse(baseUrl);
    final token = _storage.read(key: 'asset_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson())
    );

    return response;
  }

  Future<http.Response> updateComment(String commentId , String content ) async {
    final url = Uri.parse('$baseUrl/$commentId');
    final token = _storage.read(key: 'asset_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({ content }),
    );

    return response;
  }

  Future<http.Response> deletedComment( String commentId ) async {

    final url = Uri.parse('$baseUrl/$commentId');
    final token = _storage.read(key: 'asset_token');

    final response = await http.delete(
      url,
      headers: { 'Authorization': 'Bearer $token', },
    );

    return response;
  }

  Future<http.Response> getListComment( String targetId, String targetType, int page, int limit ) async {

    final url = Uri.http(
      baseUrl,
      '/$targetType/$targetId',
      {
        'page': page,
        'limit': limit,
      }
    );
    final token = _storage.read(key: 'asset_token');

    final response = await http.get(
      url,
      headers: { 'Authorization': 'Bearer $token', },
    );

    return response;
  }

  Future<http.Response> getListReply( String parentCommentId, int page , int limit ) async {

    final url = Uri.http(
      baseUrl,
      '/$parentCommentId',
      {
        'page': page,
        'limit': limit,
      }
    );
    final token = _storage.read(key: 'asset_token');

    final response = await http.get(
      url,
      headers: { 'Authorization': 'Bearer $token', },
    );

    return response;
  }


}