import 'package:devlearn/data/repositories/post_repository.dart';
import 'package:devlearn/data/repositories/problem_repository.dart';
import 'package:devlearn/widgets/post_item.dart';
import 'package:devlearn/widgets/problem_item.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _problemRepo = ProblemRepository();
  final _postRepo = PostRepository();

  late Future<List<dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<List<dynamic>> _fetchData() {
    // Tải cả hai nguồn dữ liệu cùng lúc
    final futureProblems = _problemRepo.getProblems(limit: 5); // Lấy 5 bài toán
    final futurePosts = _postRepo.getPosts(limit: 5); // Lấy 5 bài viết
    return Future.wait([futureProblems, futurePosts]);
  }

  Future<void> _refresh() async {
    setState(() {
      _dataFuture = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi tải dữ liệu: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Không có dữ liệu.'),
            );
          }

          final problems = snapshot.data![0];
          final posts = snapshot.data![1];

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSectionTitle(context, 'Bài tập nổi bật'),
              ...problems.map((p) => ProblemItem(problemSummary: p)).toList(),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Bài viết gần đây'),
              ...posts.map((p) => PostItem(post: p)).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
