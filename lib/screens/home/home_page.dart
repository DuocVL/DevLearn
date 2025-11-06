import 'package:flutter/material.dart';
import '../../data/models/tutorial_summary.dart';
import '../../data/models/problem_summary.dart';
import '../../data/models/post.dart';
import '../widgets/tutorial_card.dart';
import '../widgets/problem_item.dart';
import '../widgets/post_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();

  // --- Dữ liệu giả để demo ---
  final List<TutorialSummary> tutorials = [
    TutorialSummary(id: '1', title: 'Flutter Basics'),
    TutorialSummary(id: '2', title: 'State Management'),
    TutorialSummary(id: '3', title: 'Firebase Integration'),
    TutorialSummary(id: '4', title: 'REST API in Dart'),
    TutorialSummary(id: '5', title: 'Animations in Flutter'),
  ];

  final List<ProblemSummary> problems = [
    ProblemSummary(id: '1', title: 'Two Sum', difficulty: 'Easy', acceptance: 47.5, solved: true, saved: true),
    ProblemSummary(id: '2', title: 'Binary Tree Inorder Traversal', difficulty: 'Medium', acceptance: 38.2, solved: false, saved: false),
    ProblemSummary(id: '3', title: 'Longest Substring Without Repeating', difficulty: 'Medium', acceptance: 31.7, solved: false, saved: true),
    ProblemSummary(id: '4', title: 'Median of Two Sorted Arrays', difficulty: 'Hard', acceptance: 28.6, solved: false, saved: false),
    ProblemSummary(id: '5', title: 'Merge Sorted Lists', difficulty: 'Easy', acceptance: 56.1, solved: true, saved: false),
  ];

  final List<Post> posts = [
    Post(
      id: '1',
      title: 'Follow-up on Offer Rollout Timeline After AA Round',
      content: 'I participated in the SSE hiring drive and my AA round was conducted on 3rd November...',
      authorId: null,
      authorName: null,
      tags: [],
      likeCount: 1,
      commentCount: 0,
      views: 2,
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      updatedAt: DateTime.now(),
      isLiked: true,
    ),
    Post(
      id: '2',
      title: 'Tips for Preparing Flutter Interview',
      content: 'Here are some key topics to prepare for Flutter developer interviews...',
      authorId: 'user1',
      authorName: 'DevGuy',
      tags: ['Flutter', 'Interview'],
      likeCount: 5,
      commentCount: 3,
      views: 25,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      updatedAt: DateTime.now(),
    ),
  ];

  // ----------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        title: const Text(
          'DevLearn',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Chưa có thông báo mới.")),
              );
            },
            tooltip: 'Thông báo',
          ),
        ],
      ),

      // ---------- BODY ----------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Tutorials
            const Text(
              "Bài học nổi bật",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tutorials.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => TutorialCard(tutorial: tutorials[index]),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Problems
            const Text(
              "Bài tập luyện tập",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...problems.map((p) => ProblemItem(problemSummary: p)).toList(),

            const SizedBox(height: 24),

            // 🔹 Posts
            const Text(
              "Bài viết mới",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...posts.map((p) => PostCard(post: p)).toList(),
          ],
        ),
      ),
    );
  }
}
