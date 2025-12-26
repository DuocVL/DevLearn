class Progress {
  final String userId;
  final String tutorialId;
  final List<String> completedLessons;
  final String? lastLesson;
  final DateTime createdAt;
  final DateTime updatedAt;

  Progress({
    required this.userId,
    required this.tutorialId,
    required this.completedLessons,
    this.lastLesson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      userId: json['userId'],
      tutorialId: json['tutorialId'],
      completedLessons: List<String>.from(json['completedLessons'] ?? []),
      lastLesson: json['lastLesson'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}