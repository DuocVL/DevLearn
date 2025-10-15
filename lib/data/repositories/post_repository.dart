import 'dart:convert';
import 'refresh_token_repository.dart';
import '../services/post_service.dart';
import '../models/post.dart';

class PostRepository {

  final _postService = PostService();

  Future<Post> addPost(String title, String content, List<String> tags, bool anonymous) async {

    final res = await _postService.addPost(title, content, tags, anonymous);

    if(res.statusCode == 201){
      final json = jsonDecode(res.body);
      return Post.fromJson(json);
    } else if(res.statusCode ==)
  }
  
}