import 'dart:convert';
import 'refresh_token_repository.dart';
import '../services/post_service.dart';
import '../models/post.dart';

class PostRepository {

  final _postService = PostService();
  final _refreshTokenRepository = RefreshTokenRepository();

  Future<Post?> addPost(String title, String content, List<String> tags, bool anonymous) async {

    final res = await _postService.addPost(title, content, tags, anonymous);

    if(res.statusCode == 201){
      final json = jsonDecode(res.body);
      return Post.fromJson(json);
    } else if(res.statusCode == 401){
      final statusRefresh = await _refreshTokenRepository.refreshToken();

      if(statusRefresh){
        final res2 = await _postService.addPost(title, content, tags, anonymous);
        final data = jsonDecode(res2.body);
        return Post.fromJson(data);
      }
    }
    return null;
  }

  Future<List<Post>> getPosts({int page = 1, int limit = 20, String? tag}) async {
    final res = await _postService.getPosts(page: page, limit: limit, tag: tag);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final data = json['data'] as List<dynamic>? ?? [];
      return data.map((e) => Post.fromJson(e)).toList();
    } else if (res.statusCode == 401) {
      final ok = await _refreshTokenRepository.refreshToken();
      if (ok) {
        final res2 = await _postService.getPosts(page: page, limit: limit, tag: tag);
        if (res2.statusCode == 200) {
          final json = jsonDecode(res2.body);
          final data = json['data'] as List<dynamic>? ?? [];
          return data.map((e) => Post.fromJson(e)).toList();
        }
      }
    }
    return [];
  }

  
  
}