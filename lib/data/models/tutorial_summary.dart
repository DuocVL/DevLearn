class TutorialSummary {
  final String id;
  final String title;
  final String description;
  final List<String> tags;

  TutorialSummary({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
  });

  factory TutorialSummary.fromJson(Map<String, dynamic> json) {
    return TutorialSummary(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    );
  }
}