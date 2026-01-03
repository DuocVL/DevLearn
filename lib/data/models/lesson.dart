class Lesson {
  final String id;
  final String title;
  final String content;

  Lesson({required this.id, required this.title, required this.content});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
    );
  }
}

class LessonSummary {
  final String id;
  final String title;

  LessonSummary({required this.id, required this.title});

  factory LessonSummary.fromJson(Map<String, dynamic> json) {
    return LessonSummary(
      id: json['_id'],
      title: json['title'],
    );
  }
}
