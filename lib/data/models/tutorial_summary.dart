class TutorialSummary {
  final String id;
  final String title;

  TutorialSummary({
    required this.id,
    required this.title,
  });

  factory TutorialSummary.fromJson(Map<String, dynamic> json){
    return TutorialSummary(
      id: json['id'], 
      title: json['title'],
    );
  }
}