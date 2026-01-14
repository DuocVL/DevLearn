import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/post.dart';
import 'package:devlearn/main.dart';

class PostRepository {
  final ApiClient _apiClient = apiClient;

  // Lấy danh sách các bài viết với phân trang
  Future<List<Post>> getPosts({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '/posts',
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      // SỬA LỖI: Xử lý đúng cấu trúc JSON trả về từ server
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData['data'] is List) {
          final postsJson = responseData['data'] as List;
          return postsJson.map((json) => Post.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      // Trả về danh sách rỗng nếu không có dữ liệu hoặc cấu trúc sai
      return [];
    } catch (e) {
      print(e);
      throw Exception('Failed to load posts: $e');
    }
  }

  // THÊM: Phương thức tạo bài viết mới
  Future<void> addPost(String title, String content, List<String> tags, bool anonymous) async {
    try {
      final response = await _apiClient.post(
        '/posts',
        data: {
          'title': title,
          'content': content,
          'tags': tags,
          'anonymous': anonymous,
        },
      );

      // Backend trả về 201 Created khi thành công
      if (response.statusCode != 201) {
        // Ném lỗi nếu server không trả về mã thành công
        throw Exception('Failed to create post. Server responded with ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to create post: $e');
    }
  }
}
