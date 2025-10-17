import 'dart:convert';
import 'package:devlearn/data/models/request/reaction_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ReactionService {
  
  final baseUrl = 'http://localhost:4000/reactions/';
  final _storage = const FlutterSecureStorage();

  Future<http.Response> postReaction(ReactionRequest request) async {

    final url = Uri.parse(baseUrl);
    final token = _storage.read(key: 'asset_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request),
    );

    return response;
  }

  Future<http.Response> patchReaction( String reactionId, String reaction ) async {

    final url = Uri.http(
      baseUrl,
      reactionId,
    );
    final token = _storage.read(key: 'asset_token');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({ reaction }),
    );

    return response;
  }

  Future<http.Response> deleteReaction( String reactionId ) async {

    final url = Uri.http(
      baseUrl,
      reactionId,
    );
    final token = _storage.read(key: 'asset_token');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }

  Future<http.Response> getReaction( String targetType, String targetId ) async {
    
    final url = Uri.http(
      baseUrl,
      '$targetType/$targetId',
    );
    final token = _storage.read(key: 'asset_token');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }
}