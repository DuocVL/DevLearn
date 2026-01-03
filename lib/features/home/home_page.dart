import 'package:devlearn/data/models/post.dart';
import 'package:devlearn/data/models/problem_summary.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/services/content_service.dart';
import 'package:devlearn/widgets/post_item.dart';
import 'package:devlearn/widgets/problem_item.dart';
import 'package:devlearn/widgets/tutorial_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ContentService _contentService;
  late Future<Map<String, dynamic>> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentService = ContentService();
    _loadContent();
  }

  void _loadContent() {
    _contentFuture = _fetchContent();
  }

  Future<Map<String, dynamic>> _fetchContent() async {
    final results = await Future.wait([
      _contentService.getFeaturedContent(),
      _contentService.getRecentContent(),
    ]);
    return {
      'featured': results[0],
      'recent': results[1],
    };
  }

  Future<void> _refresh() async {
    setState(() {
      _loadContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _contentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load content.'),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final featured = snapshot.data!['featured'];
          final recent = snapshot.data!['recent'];

          final tutorials = (featured['tutorials'] as List)
              .map((data) => TutorialSummary.fromJson(data))
              .toList();
          final problems = (featured['problems'] as List)
              .map((data) => ProblemSummary.fromJson(data))
              .toList();
          final posts = (recent['posts'] as List)
              .map((data) => Post.fromJson(data))
              .toList();

          return RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text('Home'),
                  floating: true,
                  snap: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(context, 'Featured Tutorials'),
                        _buildTutorialsList(tutorials),
                        const SizedBox(height: 24),
                        _buildSectionTitle(context, 'Featured Problems'),
                        _buildProblemsList(problems),
                        const SizedBox(height: 24),
                        _buildSectionTitle(context, 'Recent Posts'),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return PostItem(post: posts[index]);
                    },
                    childCount: posts.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildTutorialsList(List<TutorialSummary> tutorials) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tutorials.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 250,
            child: TutorialCard(tutorial: tutorials[index]),
          );
        },
      ),
    );
  }

  Widget _buildProblemsList(List<ProblemSummary> problems) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: problems.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 200,
            child: ProblemItem(problemSummary: problems[index]),
          );
        },
      ),
    );
  }
}