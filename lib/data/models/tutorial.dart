import 'lesson_summary.dart';
class Tutorial {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final int totalViews;
  final List<LessonSummary> lessons;
  final double progress;

  Tutorial({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.totalViews,
    required this.lessons,
    required this.progress,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json){
    return Tutorial(
      id: json['id'], 
      title: json['title'], 
      description: json['description'], 
      tags: json['tags'] as List<String>, 
      totalViews: json['totalViews'],
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => LessonSummary.fromJson(e))
          .toList(),
      progress: (json['progress'] ?? 0).toDouble(),
    );
  }
}