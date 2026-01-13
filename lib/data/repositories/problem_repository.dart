import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/problem.dart'; // SỬA: Import model Problem chi tiết
import 'package:devlearn/data/models/problem_summary.dart';
import 'package:devlearn/main.dart';

class ProblemRepository {
  final ApiClient _apiClient = apiClient;

  // Lấy danh sách bài toán (tóm tắt) với phân trang và bộ lọc
  Future<List<ProblemSummary>> getProblems({int page = 1, int limit = 20, String? difficulty}) async {
    try {
      Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (difficulty != null && difficulty != 'All') {
        queryParams['difficulty'] = difficulty;
      }

      final response = await _apiClient.get('/problems', queryParameters: queryParams);

      if (response.statusCode == 200 && response.data['data'] != null) {
        List<dynamic> problemsJson = response.data['data'];
        return problemsJson.map((json) => ProblemSummary.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print(e);
      throw Exception('Failed to load problems: $e');
    }
  }

  // THÊM: Lấy chi tiết một bài toán bằng ID
  Future<Problem> getProblemById(String problemId) async {
    try {
      final response = await _apiClient.get('/problems/$problemId');

      if (response.statusCode == 200) {
        // Dữ liệu chi tiết của bài toán nằm trong response.data
        return Problem.fromJson(response.data);
      }
      throw Exception('Failed to load problem details. Status code: ${response.statusCode}');
    } catch (e) {
      print(e);
      throw Exception('Failed to load problem details: $e');
    }
  }
}
