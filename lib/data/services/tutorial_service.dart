import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/tutorial.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/main.dart';

class TutorialService {
  final ApiClient _apiClient = apiClient; // Sử dụng ApiClient toàn cục

  // Lấy danh sách các bản tóm tắt hướng dẫn
  Future<List<TutorialSummary>> getTutorials() async {
    try {
      final response = await _apiClient.get('/tutorials');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TutorialSummary.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Lấy một hướng dẫn đầy đủ bằng ID
  Future<Tutorial> getTutorialById(String id) async {
    try {
      final response = await _apiClient.get('/tutorials/$id');
      if (response.statusCode == 200) {
        return Tutorial.fromJson(response.data);
      }
      throw Exception('Không thể tải hướng dẫn');
    } catch (e) {
      print(e);
      throw Exception('Không thể tải hướng dẫn');
    }
  }
}
