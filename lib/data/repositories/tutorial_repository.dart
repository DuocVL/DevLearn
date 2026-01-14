import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/main.dart';

class TutorialRepository {
  final ApiClient _apiClient = apiClient;

  Future<Map<String, dynamic>> getTutorials({int page = 1, int limit = 10, String? tag}) async {
    try {
      final response = await _apiClient.get('/tutorials', queryParameters: {
        'page': page,
        'limit': limit,
        if (tag != null) 'tag': tag,
      });

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> tutorialJson = response.data['data'];
        final tutorials = tutorialJson.map((json) => TutorialSummary.fromJson(json)).toList();
        
        return {
          'tutorials': tutorials,
          'pagination': response.data['pagination'],
        };
      } else {
        return {'tutorials': [], 'pagination': {}};
      }
    } catch (e) {
      print('Failed to load tutorials: $e');
      throw Exception('Failed to load tutorials: $e');
    }
  }

  // Các hàm khác như getTutorialById, createTutorial sẽ được thêm vào đây sau
}
