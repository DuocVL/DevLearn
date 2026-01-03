import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/data/models/tutorial.dart';
import 'package:devlearn/data/services/tutorial_service.dart';
import 'package:devlearn/features/lesson/lesson_screen.dart';
import 'package:flutter/material.dart';

class TutorialScreen extends StatefulWidget {
  final String tutorialId;
  const TutorialScreen({super.key, required this.tutorialId});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late Future<Tutorial> _tutorialFuture;
  final _tutorialService = TutorialService();

  @override
  void initState() {
    super.initState();
    _tutorialFuture = _tutorialService.getTutorialById(widget.tutorialId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<Tutorial>(
        future: _tutorialFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy hướng dẫn.'));
          }

          final tutorial = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 220.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(tutorial.title, style: const TextStyle(fontSize: 16)),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Placeholder for a background image
                      Container(color: theme.colorScheme.primary.withOpacity(0.1)),
                      Positioned(
                        bottom: 60,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tutorial.title,
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tutorial.description,
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tags and Views
                      Row(
                        children: [
                          Wrap(
                            spacing: 8.0,
                            children: tutorial.tags.map((tag) => Chip(label: Text(tag))).toList(),
                          ),
                          const Spacer(),
                          const Icon(Icons.visibility, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${tutorial.totalViews} lượt xem',
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Thanh tiến trình
                      if (tutorial.progress > 0) ...[
                        LinearProgressIndicator(
                          value: tutorial.progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(8),
                          color: theme.colorScheme.primary,
                          backgroundColor: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(tutorial.progress * 100).toStringAsFixed(0)}% hoàn thành',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text("Danh sách bài học", style: theme.textTheme.titleLarge)
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final lesson = tutorial.lessons[index];
                    return _LessonListItem(lesson: lesson);
                  },
                  childCount: tutorial.lessons.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LessonListItem extends StatelessWidget {
  final LessonSummary lesson;

  const _LessonListItem({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: lesson.isCompleted ? Colors.green : theme.colorScheme.primary,
        child: lesson.isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : Text(
                '${lesson.order}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
      title: Text(lesson.title),
      trailing: const Icon(Icons.play_circle_outline, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonScreen(lessonId: lesson.id),
          ),
        );
      },
    );
  }
}
