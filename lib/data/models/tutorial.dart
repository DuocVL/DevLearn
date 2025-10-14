class Tutorial {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final int totalViews;
  
  Tutorial({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.totalViews,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json){
    return Tutorial(
      id: json['id'], 
      title: json['title'], 
      description: json['description'], 
      tags: json['tags'] as List<String>, 
      totalViews: json['totalViews'],
    );
  }
}