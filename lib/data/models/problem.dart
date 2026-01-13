/// SỬA ĐỔI HOÀN TOÀN FILE NÀY ĐỂ ĐỒNG BỘ VỚI SERVER

// 1. Đổi tên class Example -> Testcase và cập nhật trường cho khớp với `testcaseSchema`
class Testcase {
  final String input;
  final String output;
  final bool isHidden;

  Testcase({
    required this.input,
    required this.output,
    required this.isHidden,
  });

  factory Testcase.fromJson(Map<String, dynamic> json) {
    return Testcase(
      input: json['input'] as String? ?? '',
      output: json['output'] as String? ?? '',
      isHidden: json['isHidden'] as bool? ?? false,
    );
  }
}

class StarterCode {
  final String language;
  final String code;

  StarterCode({required this.language, required this.code});

  factory StarterCode.fromJson(Map<String, dynamic> json) {
    return StarterCode(
      language: json['language'] as String? ?? 'plaintext',
      code: json['code'] as String? ?? '',
    );
  }
}

// 2. Cập nhật toàn bộ class Problem
class Problem {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final List<String> tags;
  final List<Testcase> testcases; // SỬA: Đổi từ examples -> testcases
  final List<StarterCode> starterCode;
  final int totalSubmissions;     // SỬA: Thêm trường này
  final int acceptedSubmissions;  // SỬA: Thêm trường này

  Problem({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.tags,
    required this.testcases,
    required this.starterCode,
    required this.totalSubmissions,
    required this.acceptedSubmissions,
  });

  // 3. Cập nhật lại hoàn toàn hàm fromJson
  factory Problem.fromJson(Map<String, dynamic> json) {
    // Kỹ thuật an toàn để xử lý danh sách có thể chứa null
    final safeTags = (json['tags'] as List<dynamic>? ?? [])
        .map((tag) => tag as String?)
        .where((tag) => tag != null)
        .cast<String>()
        .toList();

    final safeTestcases = (json['testcases'] as List<dynamic>? ?? [])
        .map((t) => Testcase.fromJson(t))
        .toList();

    final safeStarterCode = (json['starterCode'] as List<dynamic>? ?? [])
        .map((sc) => StarterCode.fromJson(sc))
        .toList();

    return Problem(
      id: json['_id'] as String? ?? '', // Backend dùng '_id'
      title: json['title'] as String? ?? 'No Title',
      description: json['description'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'Unknown',
      tags: safeTags, 
      testcases: safeTestcases,
      starterCode: safeStarterCode,
      totalSubmissions: json['totalSubmissions'] as int? ?? 0,
      acceptedSubmissions: json['acceptedSubmissions'] as int? ?? 0,
    );
  }
}
