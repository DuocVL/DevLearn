import 'package:devlearn/data/models/author.dart';

class TutorialSummary {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final Author? author;
  final int totalViews;
  final int lessonCount;
  final bool saved;
  final DateTime createdAt;

  TutorialSummary({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    this.author,
    required this.totalViews,
    required this.lessonCount,
    required this.saved,
    required this.createdAt,
  });

  factory TutorialSummary.fromJson(Map<String, dynamic> json) {
    return TutorialSummary(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      totalViews: json['totalViews'] ?? 0,
      lessonCount: json['lessonCount'] ?? 0,
      saved: json['saved'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
