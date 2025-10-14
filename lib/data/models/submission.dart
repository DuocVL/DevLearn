class Submission {
  final String id;
  final String language;
  final String code;
  final String status;
  final int runtime;
  final int memory;
  final DateTime createdAt;

  Submission({
    required this.id,
    required this.language,
    required this.code,
    required this.status,
    required this.runtime,
    required this.memory,
    required this.createdAt,
  });

  factory Submission.fromJson(Map<String, dynamic> json){
    return Submission(
      id: json['id'], 
      language: json['language'], 
      code: json['code'], 
      status: json['status'], 
      runtime: json['runtime'], 
      memory: json['memory'], 
      createdAt: json['createdAt'],
    );
  }
}