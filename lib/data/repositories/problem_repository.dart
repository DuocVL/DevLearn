import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/problem_summary.dart'; // SỬA: Import model từ tệp riêng
import 'package:devlearn/main.dart';

// ĐÃ XÓA: Định nghĩa class ProblemSummary đã được chuyển đi

class ProblemRepository {
  final ApiClient _apiClient = apiClient;

  // Lấy danh sách bài toán với phân trang và bộ lọc
  Future<List<ProblemSummary>> getProblems({int page = 1, int limit = 20, String? difficulty}) async {
    try {
      Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      // Chỉ thêm difficulty vào query nếu nó không phải là "All" hoặc null
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
      // Ném lại lỗi để UI có thể xử lý
      throw Exception('Failed to load problems: $e');
    }
  }
}
