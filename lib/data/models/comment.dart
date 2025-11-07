class Comment {

  final String id;
  final String authorId;
  final String authorName;
  final String? parentCommentId;
  final String content;
  final int likeCount;
  final int replyCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.parentCommentId,
    required this.content,
    required this.likeCount,
    required this.replyCount,
    required this.createdAt,
    required this.updatedAt,
  }); 

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
      id: json['id'], 
      authorId: json['authorId'], 
      authorName: json['authorName'],
      parentCommentId: json['parentCommentId'], 
      content: json['content'], 
      likeCount: json['likeCount'], 
      replyCount: json['replyCount'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}