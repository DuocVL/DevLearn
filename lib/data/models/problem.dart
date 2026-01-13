class Problem {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final List<String> tags;
  final List<Example> examples;
  final List<String> constraints;
  final List<StarterCode> starterCode;
  final int likeCount;

  Problem({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.tags,
    required this.examples,
    required this.constraints,
    required this.starterCode,
    required this.likeCount,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['_id'], // SỬA: Backend dùng '_id'
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? 'Unknown',
      tags: List<String>.from(json['tags'] ?? []),
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) => Example.fromJson(e))
              .toList() ??
          [],
      constraints: List<String>.from(json['constraints'] ?? []),
      starterCode: (json['starterCode'] as List<dynamic>?)
              ?.map((e) => StarterCode.fromJson(e))
              .toList() ??
          [],
      likeCount: json['likeCount'] ?? 0,
    );
  }
}

class Example {
  final String input;
  final String output;
  final String? explanation;

  Example({
    required this.input,
    required this.output,
    this.explanation,
  });

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      input: json['input'] ?? '',
      output: json['output'] ?? '',
      explanation: json['explanation'],
    );
  }
}

class StarterCode {
  final String language;
  final String code;

  StarterCode({required this.language, required this.code});

  factory StarterCode.fromJson(Map<String, dynamic> json) {
    return StarterCode(
      language: json['language'] ?? 'plaintext',
      code: json['code'] ?? '',
    );
  }
}
