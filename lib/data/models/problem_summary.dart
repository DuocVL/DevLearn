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
    String id = (json['_id'] ?? json['id'] ?? '').toString();
    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    return ProblemSummary(
      id: id,
      title: (json['title'] ?? '').toString(),
      difficulty: (json['difficulty'] ?? 'Unknown').toString(),
      acceptance: toDouble(json['acceptance']),
      solved: json['solved'] == true,
      saved: json['saved'] == true,
    );
  }
}