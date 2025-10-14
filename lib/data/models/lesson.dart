class Lesson {
  final String id;
  final String title;
  final String content;
  final int order;
  final int likeCount;
  final int views;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
    required this.likeCount,
    required this.views,
  });

  factory Lesson.fromJson(Map<String, dynamic> json){
    return Lesson(
      id: json['id'], 
      title: json['title'], 
      content: json['content'], 
      order: json['order'], 
      likeCount: json['likeCount'], 
      views: json['view'],
    );
  }
}