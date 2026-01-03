import 'package:devlearn/data/models/lesson.dart';
import 'package:devlearn/data/services/lesson_service.dart';
import 'package:flutter/material.dart';

class LessonScreen extends StatefulWidget {
  final String lessonId;
  const LessonScreen({super.key, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late Future<Lesson> _lessonFuture;
  final _lessonService = LessonService();

  @override
  void initState() {
    super.initState();
    _lessonFuture = _lessonService.getLessonById(widget.lessonId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài học'), // Tiêu đề mặc định
      ),
      body: FutureBuilder<Lesson>(
        future: _lessonFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy bài học.'));
          }

          final lesson = snapshot.data!;

          // Cập nhật tiêu đề AppBar sau khi có dữ liệu
          return Scaffold(
            appBar: AppBar(title: Text(lesson.title)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.content, // Hiển thị nội dung bài học
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
