import 'package:devlearn/data/models/post.dart';
import 'package:devlearn/data/repositories/post_repository.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:devlearn/widgets/post_item.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _repo = PostRepository();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    _postsFuture = _repo.getPosts(page: 1, limit: 20);
  }

  Future<void> _refresh() async {
    setState(() {
      _fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Lỗi tải bài viết',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.article_outlined, size: 56, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text('Chưa có bài viết nào', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              );
            }

            final posts = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80), // Padding for FAB
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostItem(post: posts[index]);
              },
            );
          },
        ),
      );
  }
}