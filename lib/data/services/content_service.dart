
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ContentService {
  final String _baseUrl;

  ContentService() : _baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://10.0.2.2:4000';

  Future<dynamic> getFeaturedContent() async {
    final response = await http.get(Uri.parse('$_baseUrl/content/featured'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load featured content');
    }
  }

  Future<dynamic> getRecentContent() async {
    final response = await http.get(Uri.parse('$_baseUrl/content/recent'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recent content');
    }
  }
}
