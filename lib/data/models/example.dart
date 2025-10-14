class Example {
  final String input;
  final String output;
  final String? explanation;
  Example({
    required this.input,
    required this.output,
    this.explanation,
  });

  factory Example.fromJson(Map<String, dynamic> json){
    return Example(
        input: json['input'],
        output: json['output'],
        explanation: json['explanation'],
      );
  }
}