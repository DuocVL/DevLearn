class ProblemSummary {
  final String id;
  final String title;
  final String difficulty;
  final double acceptance;
  final bool solved;
  final bool saved;

  ProblemSummary({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.acceptance,
    required this.solved,
    required this.saved,
  });

  factory ProblemSummary.fromJson(Map<String, dynamic> json){
    return ProblemSummary(
      id: json['id'], 
      title: json['title'], 
      difficulty: json['difficulty'], 
      acceptance: json['acceptance'], 
      solved: json['solved'], 
      saved: json['saved'],
    );
  }
}