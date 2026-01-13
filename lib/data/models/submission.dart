// Dựa trên submissionSchema từ backend

class Submission {
  final String id;
  final String problemId;
  final String userId;
  final String language;
  final String code;
  final String status;
  final SubmissionResult result;
  final double runtime; // Đơn vị: ms
  final double memory;  // Đơn vị: KB
  final DateTime createdAt;

  Submission({
    required this.id,
    required this.problemId,
    required this.userId,
    required this.language,
    required this.code,
    required this.status,
    required this.result,
    required this.runtime,
    required this.memory,
    required this.createdAt,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['_id'] as String? ?? '',
      problemId: json['problemId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      language: json['language'] as String? ?? 'unknown',
      code: json['code'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
      result: SubmissionResult.fromJson(json['result'] ?? {}),
      runtime: (json['runtime'] as num?)?.toDouble() ?? 0.0,
      memory: (json['memory'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class SubmissionResult {
  final int passedCount;
  final int totalCount;
  final FailedTestcase? failedTestcase;
  final String? error;

  SubmissionResult({
    required this.passedCount,
    required this.totalCount,
    this.failedTestcase,
    this.error,
  });

  factory SubmissionResult.fromJson(Map<String, dynamic> json) {
    return SubmissionResult(
      passedCount: json['passedCount'] as int? ?? 0,
      totalCount: json['totalCount'] as int? ?? 0,
      failedTestcase: json['failedTestcase'] != null 
          ? FailedTestcase.fromJson(json['failedTestcase'])
          : null,
      error: json['error'] as String?,
    );
  }
}

class FailedTestcase {
  final String input;
  final String expectedOutput;
  final String userOutput;

  FailedTestcase({
    required this.input,
    required this.expectedOutput,
    required this.userOutput,
  });

  factory FailedTestcase.fromJson(Map<String, dynamic> json) {
    return FailedTestcase(
      input: json['input'] as String? ?? '',
      expectedOutput: json['expectedOutput'] as String? ?? '',
      userOutput: json['userOutput'] as String? ?? '',
    );
  }
}
