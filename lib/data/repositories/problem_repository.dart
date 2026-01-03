import 'dart:convert';
import 'package:devlearn/data/models/problem_summary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProblemRepository {
  final _storage = const FlutterSecureStorage();

  Future<List<ProblemSummary>> getProblems(
      {int page = 1, int limit = 20, String? difficulty}) async {
    final baseUrl = dotenv.env['BACKEND_URL'];
    if (baseUrl == null) {
      throw Exception('BACKEND_URL not found in .env file');
    }

    final token = await _storage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('Access token not found');
    }

    final queryParameters = {
      'page': '$page',
      'limit': '$limit',
    };

    if (difficulty != null && difficulty.toLowerCase() != 'all') {
      queryParameters['difficulty'] = difficulty.toLowerCase();
    }

    final uri = Uri.parse('$baseUrl/problems').replace(
      queryParameters: queryParameters,
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> problemsJson = json.decode(response.body);
      return problemsJson.map((json) {
        final int total = json['totalSubmissions'] as int? ?? 0;
        final int accepted = json['acceptedSubmissions'] as int? ?? 0;
        final double acceptanceRate =
            (total > 0) ? (accepted / total) * 100 : 0.0;

        json['acceptance'] = acceptanceRate;
        json['solved'] = false;
        json['saved'] = false;

        return ProblemSummary.fromJson(json);
      }).toList();
    } else {
      final body = json.decode(response.body);
      final errorMessage = body['message'] ?? 'Failed to load problems';
      throw Exception(errorMessage);
    }
  }
}