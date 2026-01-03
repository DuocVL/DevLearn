import 'dart:convert';
import 'package:devlearn/data/models/request/reaction_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ReactionService {
  
  final String baseUrl;
  ReactionService({String? baseUrl}) : baseUrl = baseUrl ?? _envOrDefault();

  static String _envOrDefault() {
    final env = dotenv.env['BACKEND_URL'];
    if (env != null && env.isNotEmpty) return '${env.replaceAll(RegExp(r'/$'), '')}/reactions';
    // Default to Android emulator host when BACKEND_URL not provided
    return 'http://10.0.2.2:4000/reactions';
  }
  final _storage = const FlutterSecureStorage();

  Future<http.Response> postReaction(ReactionRequest request) async {

    final url = Uri.parse(baseUrl);
    final token = await _storage.read(key: 'access_token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request),
    );

    return response;
  }

  Future<http.Response> patchReaction( String reactionId, String reaction ) async {

    final url = Uri.parse('$baseUrl/$reactionId');
    final token = await _storage.read(key: 'access_token');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({ 'reaction': reaction }),
    );

    return response;
  }

  Future<http.Response> deleteReaction( String reactionId ) async {

    final url = Uri.parse('$baseUrl/$reactionId');
    final token = await _storage.read(key: 'access_token');

    final response = await http.delete(
      url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return response;
  }

  Future<http.Response> getReaction( String targetType, String targetId ) async {
    
    final url = Uri.parse('$baseUrl/$targetType/$targetId');
    final token = await _storage.read(key: 'access_token');

    final response = await http.get(
      url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return response;
  }
}