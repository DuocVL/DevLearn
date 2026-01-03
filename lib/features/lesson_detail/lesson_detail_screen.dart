import 'package:devlearn/data/models/tutorial.dart';
import 'package:devlearn/data/services/lesson_service.dart';
import 'package:flutter/material.dart';
import 'package:devlearn/data/models/lesson.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LessonDetailScreen extends StatefulWidget {
  final LessonSummary lessonSummary;
  const LessonDetailScreen({super.key, required this.lessonSummary});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  late Future<Lesson> _lessonFuture;
  final _lessonService = LessonService();

  @override
  void initState() {
    super.initState();
    _lessonFuture = _lessonService.getLessonById(widget.lessonSummary.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lessonSummary.title)),
      body: FutureBuilder<Lesson>(
        future: _lessonFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Lesson not found.'));
          }

          final lesson = snapshot.data!;
          return Markdown(
            data: lesson.content,
            padding: const EdgeInsets.all(16.0),
          );
        },
      ),
    );
  }
}
