import 'package:devlearn/data/models/lesson.dart';

class Tutorial {
  final String id;
  final String title;
  final String description;
  final List<LessonSummary> lessons;
  final List<String> tags;
  final int totalViews;
  final double progress;

  Tutorial({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    required this.tags,
    required this.totalViews,
    required this.progress,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      lessons: (json['lessons'] as List)
          .map((i) => LessonSummary.fromJson(i))
          .toList(),
      tags: List<String>.from(json['tags'] ?? []),
      totalViews: json['totalViews'] ?? 0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
