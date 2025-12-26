import 'package:flutter/material.dart';
import '../../data/models/lesson_summary.dart';
import '../../data/models/tutorial.dart'; 
import '../lesson/lesson_screen.dart';

class TutorialScreen extends StatefulWidget {
  final String tutorialId;

  const TutorialScreen({super.key, required this.tutorialId});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
 late Tutorial tutorial;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tutorial = // Lấy dữ liệu tutorial từ ID (giả sử bạn có hàm fetchTutorialById)
        Tutorial(
      id: '1',
      title: 'Flutter Basics',
      description: 'Learn the basics of Flutter development.',
      tags: ['Flutter', 'Mobile', 'Dart'],
      totalViews: 1200,
      lessons: [
        LessonSummary(id: 'l1', title: 'Introduction to Flutter', order: 1, isCompleted: true),
        LessonSummary(id: 'l2', title: 'Widgets and Layouts', order: 2, isCompleted: false),
        LessonSummary(id: 'l3', title: 'State Management', order: 3, isCompleted: false),
      ],
      progress: 0.33,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tutorial.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tổng lượt xem
            Row(
              children: [
                const Icon(Icons.remove_red_eye, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${tutorial.totalViews} lượt xem',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),

            // Thanh tiến trình
            LinearProgressIndicator(
              value: tutorial.progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),
            Text(
              '${(tutorial.progress * 100).toStringAsFixed(0)}% hoàn thành',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Tags
            Wrap(
              spacing: 8,
              children: tutorial.tags
                  .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.blue.shade50,
                        labelStyle: const TextStyle(color: Colors.blue),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Mô tả
            Text(
              tutorial.description,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 24),

            // Danh sách bài học
            const Text(
              "Danh sách bài học",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...tutorial.lessons.map((lesson) => ListTile(
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.blue.shade100,
                    child: Text('${lesson.order}',
                        style: const TextStyle(color: Colors.blue)),
                  ),
                  title: Text(lesson.title),
                  trailing: lesson.isCompleted
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.circle_outlined, color: Colors.grey),
                  onTap: () {
                    // chuyển sang LessonScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonScreen(idLesson: lesson.id),
                      ),
                    );
                  },
                )
              ),
          ],
        ),
      ),
    );
  }
}
