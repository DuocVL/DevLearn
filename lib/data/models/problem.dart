import 'package:devlearn/data/models/example.dart';

class Problem {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final List<String>? tags;
  final List<Example>? examples;
  final List<String>? constraints; 
  final List<String>? hints;
  final int likeCount;
  final int commentCount;
  final int totalSubmissions;
  final int acceptedSubmissions;

  Problem({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    this.tags,
    this.examples,
    this.constraints,
    this.hints,
    required this.likeCount,
    required this.commentCount,
    required this.totalSubmissions,
    required this.acceptedSubmissions,
  });

  factory Problem.fromJson(Map<String, dynamic> json){
    return Problem(
      id: json['id'],
      title: json['title'], 
      description: json['description'], 
      difficulty: json['difficulty'], 
      tags: (json['tags'] == null) ? [] : json['tags'],
      examples: (json['examples'] == null) ? [] : (json['examples'] as List).map((itemJson) => Example.fromJson(itemJson)).toList(),
      constraints: (json['constraints'] == null) ? [] : json['constraints'],
      hints: (json['hints'] == null) ? [] : json['hints'],
      likeCount: json['likeCount'], 
      commentCount: json['commentCount'], 
      totalSubmissions: json['totalSubmissions'], 
      acceptedSubmissions: json['acceptedSubmissions'],
    );
  }
}