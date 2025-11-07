class LessonSummary {
  final String id;
  final String title;
  final int order;
  final bool isCompleted;

  LessonSummary({
    required this.id,
    required this.title,
    required this.order,
    this.isCompleted = false,
  });

  factory LessonSummary.fromJson(Map<String, dynamic> json){
    return LessonSummary(
      id: json['id'], 
      title: json['title'], 
      order: json['order'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}