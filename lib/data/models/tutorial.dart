import 'package:devlearn/data/models/lesson.dart';

class Tutorial {
  final String id;
  final String title;
  final String description;
  final List<LessonSummary> lessons;

  Tutorial({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      lessons: (json['lessons'] as List)
          .map((i) => LessonSummary.fromJson(i))
          .toList(),
    );
  }
}

class TutorialSummary {
  final String id;
  final String title;

  TutorialSummary({required this.id, required this.title});

  factory TutorialSummary.fromJson(Map<String, dynamic> json) {
    return TutorialSummary(
      id: json['_id'],
      title: json['title'],
    );
  }
}
