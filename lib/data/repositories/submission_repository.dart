import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/submission.dart';
import 'package:devlearn/main.dart';

class SubmissionRepository {
  final ApiClient _apiClient = apiClient;

  // Lấy lịch sử nộp bài
  Future<List<Submission>> getSubmissions({required String problemId}) async {
    try {
      final response = await _apiClient.get(
        '/submissions',
        queryParameters: {'problemId': problemId},
      );
      
      // SỬA: Dữ liệu nằm trong key 'submissions' theo code backend mới
      if (response.statusCode == 200 && response.data['submissions'] != null) {
        final List<dynamic> submissionsJson = response.data['submissions'];
        return submissionsJson.map((json) => Submission.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Failed to load submissions: $e');
      throw Exception('Failed to load submissions: $e');
    }
  }

  // THÊM: Tạo một lần nộp bài mới
  Future<String> createSubmission({required String problemId, required String language, required String code}) async {
    try {
      final response = await _apiClient.post(
        '/submissions',
        data: {
          'problemId': problemId,
          'language': language,
          'code': code,
        },
      );

      if (response.statusCode == 201 && response.data['submissionId'] != null) {
        return response.data['submissionId'];
      } else {
        throw Exception('Failed to create submission: Invalid response from server');
      }
    } catch (e) {
      print('Failed to create submission: $e');
      // Ném lỗi để UI có thể bắt và hiển thị thông báo
      throw Exception('Failed to create submission: $e');
    }
  }
}
