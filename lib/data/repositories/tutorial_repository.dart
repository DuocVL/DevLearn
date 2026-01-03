import 'dart:convert';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TutorialRepository {
  final _storage = const FlutterSecureStorage();

  Future<List<TutorialSummary>> getTutorials() async {
    final baseUrl = dotenv.env['BACKEND_URL'];
    if (baseUrl == null) {
      throw Exception('BACKEND_URL not found in .env file');
    }

    final token = await _storage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/tutorials'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> tutorialsJson = json.decode(response.body);
      return tutorialsJson
          .map((json) => TutorialSummary.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load tutorials: ${response.statusCode}');
    }
  }
}
