class LessonSummary {
  final String id;
  final String title;
  final int order;

  LessonSummary({
    required this.id,
    required this.title,
    required this.order,
  });

  factory LessonSummary.fromJson(Map<String, dynamic> json){
    return LessonSummary(
      id: json['id'], 
      title: json['title'], 
      order: json['order'],
    );
  }
}