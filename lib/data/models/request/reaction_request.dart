class ReactionRequest {

  final String targetType;
  final String targetId;
  final String reaction;

  ReactionRequest({
    required this.targetType,
    required this.targetId,
    required this.reaction
  });

  Map<String,dynamic> toJson(){
    return {
      'targetType': targetType,
      'targetId': targetId,
      'reaction': reaction,
    };
  }
  
}