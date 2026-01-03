import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/main.dart';

class LessonService {
  final ApiClient _apiClient = apiClient;

  Future<Lesson> getLessonById(String id) async {
    try {
      final response = await _apiClient.get('/lessons/$id');
      if (response.statusCode == 200) {
        return Lesson.fromJson(response.data);
      }
      throw Exception('Failed to load lesson');
    } catch (e) {
      print(e);
      throw Exception('Failed to load lesson');
    }
  }
}
