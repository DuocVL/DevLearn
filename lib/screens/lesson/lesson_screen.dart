import 'package:flutter/material.dart';
import 'dart:convert'; // để giả lập dữ liệu JSON
import 'dart:async';
import '../../data/models/lesson.dart';

class LessonScreen extends StatefulWidget {
  final String idLesson; // ✅ nhận id từ ngoài truyền vào

  const LessonScreen({super.key, required this.idLesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  Lesson? _lesson; // dữ liệu bài học sau khi tải
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchLesson(widget.idLesson); // ✅ gọi API khi mở màn hình
  }

  Future<void> fetchLesson(String id) async {
    try {
      // 🔹 ví dụ: giả lập gọi API bằng Future.delayed
      await Future.delayed(const Duration(seconds: 1));

      // 🔹 dữ liệu mẫu (thay bằng dữ liệu từ API thật)
      const jsonData = '''
      {
        "id": "l001",
        "title": "Giới thiệu về Dart",
        "content": "Dart là ngôn ngữ lập trình được sử dụng trong Flutter...",
        "order": 1,
        "likeCount": 120,
        "view": 520
      }
      ''';

      final data = json.decode(jsonData);
      setState(() {
        _lesson = Lesson.fromJson(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 trạng thái đang tải
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 🔹 trạng thái lỗi
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Bài học")),
        body: Center(child: Text("Lỗi tải dữ liệu: $_error")),
      );
    }

    // 🔹 hiển thị nội dung bài học
    return Scaffold(
      appBar: AppBar(title: Text(_lesson!.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              _lesson!.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("Lượt thích: ${_lesson!.likeCount}"),
            Text("Lượt xem: ${_lesson!.views}"),
            const SizedBox(height: 20),
            Text(
              _lesson!.content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}