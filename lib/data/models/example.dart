class Example {
  final String order;
  final String input;
  final String output;
  final String? explanation;
  Example({
    required this.order,
    required this.input,
    required this.output,
    this.explanation,
  });

  factory Example.fromJson(Map<String, dynamic> json){
    return Example(
        order: json['order'],
        input: json['input'],
        output: json['output'],
        explanation: json['explanation'],
      );
  }
}