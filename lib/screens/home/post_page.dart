import 'package:flutter/material.dart';
import '../../data/models/post.dart';
import '../widgets/post_item.dart';
import '../../data/repositories/post_repository.dart';
import '../../routes/route_name.dart';

// Post list uses backend when available; falls back to empty list

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<Post> _posts = [];
  final _repo = PostRepository();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.pushNamed(context, RouteName.createPost);
          if (res == true) {
            await _loadPosts(refresh: true);
          }
        },
        backgroundColor: const Color(0xFF2E7DFF),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadPosts(refresh: true);
        },
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = _posts[index];
                  return PostCard(post: p);
                },
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts({bool refresh = false}) async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      if (refresh) _posts.clear();
      final list = await _repo.getPosts(page: 1, limit: 20);
      setState(() {
        _posts.addAll(list);
      });
    } catch (e) {
      // ignore
    } finally {
      setState(() => _loading = false);
    }
  }
}