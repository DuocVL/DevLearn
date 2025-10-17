class CommentRequest {

  final String targetId;
  final String targetType;
  final String? parentCommentId;
  final String content;
  final bool anonymous;

  CommentRequest({
    required this.targetId,
    required this.targetType,
    this.parentCommentId,
    required this.content,
    required this.anonymous,
  });

  Map<String, dynamic> toJson() {
    return {
      'targetId': targetId,
      'targetType': targetType,
      if(parentCommentId != null) 'parentCommentId': parentCommentId,
      'content': content,
      'anonymous': anonymous,
    };
  }
}