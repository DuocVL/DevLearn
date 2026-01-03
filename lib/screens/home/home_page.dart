import 'package:devlearn/data/models/post.dart';
import 'package:devlearn/data/models/problem_summary.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/repositories/post_repository.dart';
import 'package:devlearn/data/repositories/problem_repository.dart';
import 'package:devlearn/data/repositories/tutorial_repository.dart';
import 'package:devlearn/screens/widgets/post_item.dart';
import 'package:devlearn/screens/widgets/problem_item.dart';
import 'package:devlearn/screens/widgets/tutorial_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TutorialRepository _tutorialRepository;
  late final ProblemRepository _problemRepository;
  late final PostRepository _postRepository;

  late Future<List<TutorialSummary>> _tutorialsFuture;
  late Future<List<ProblemSummary>> _problemsFuture;
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _tutorialRepository = TutorialRepository();
    _problemRepository = ProblemRepository();
    _postRepository = PostRepository();

    _loadData();
  }

  void _loadData() {
    _tutorialsFuture = _tutorialRepository.getTutorials();
    _problemsFuture = _problemRepository.getProblems();
    _postsFuture = _postRepository.getPosts();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DevLearn',
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Chưa có thông báo mới.")),
              );
            },
            tooltip: 'Thông báo',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildSectionTitle(theme, "Khóa học nổi bật"),
              _buildTutorialsSection(),
              const SizedBox(height: 24),
              _buildSectionTitle(theme, "Thử thách lập trình"),
              _buildProblemsSection(),
              const SizedBox(height: 24),
              _buildSectionTitle(theme, "Bài viết mới"),
              _buildPostsSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: theme.textTheme.titleLarge,
      ),
    );
  }

  Widget _buildTutorialsSection() {
    return FutureBuilder<List<TutorialSummary>>(
      future: _tutorialsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return SizedBox(
            height: 200,
            child: Center(child: Text('Lỗi tải khóa học: ${snapshot.error}')),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('Không có khóa học nào.')),
          );
        }
        final tutorials = snapshot.data!;
        return SizedBox(
          height: 200, // Adjusted height for the new card design
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            scrollDirection: Axis.horizontal,
            itemCount: tutorials.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 250, // Fixed width for horizontal cards
                child: TutorialCard(tutorial: tutorials[index]),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProblemsSection() {
    return FutureBuilder<List<ProblemSummary>>(
      future: _problemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải bài tập: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có bài tập nào.'));
        }
        final problems = snapshot.data!;
        return Column(
          children: problems
              .take(5) // Show first 5 problems
              .map((p) => ProblemItem(problemSummary: p))
              .toList(),
        );
      },
    );
  }

  Widget _buildPostsSection() {
    return FutureBuilder<List<Post>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi tải bài viết: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có bài viết nào.'));
        }
        final posts = snapshot.data!;
        return Column(
          children: posts.map((p) => PostItem(post: p)).toList(),
        );
      },
    );
  }
}

