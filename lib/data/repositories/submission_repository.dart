import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/submission.dart';
import 'package:devlearn/main.dart';

class SubmissionRepository {
  final ApiClient _apiClient = apiClient;

  // Lấy lịch sử nộp bài cho một problem cụ thể
  Future<List<Submission>> getSubmissions({required String problemId, String? userId}) async {
    try {
      // Xây dựng các query parameters để lọc
      final Map<String, dynamic> queryParams = {
        'problemId': problemId,
      };

      // (Tùy chọn) Nếu có userId, chỉ lấy các bài nộp của user đó
      if (userId != null) {
        queryParams['userId'] = userId;
      }

      final response = await _apiClient.get('/submissions', queryParameters: queryParams);

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> submissionsJson = response.data['data'];
        return submissionsJson.map((json) => Submission.fromJson(json)).toList();
      }

      return []; // Trả về danh sách rỗng nếu không có dữ liệu

    } catch (e) {
      print('Failed to load submissions: $e');
      // Ném lại lỗi để UI có thể xử lý
      throw Exception('Failed to load submissions: $e');
    }
  }
}
