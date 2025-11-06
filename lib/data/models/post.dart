class Post {
  final String id;
  final String title;
  final String content;
  final String? authorId;
  final String? authorName;
  final List<String>? tags;
  final int likeCount;
  final int commentCount;
  final int views;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;
  final bool isLiked;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.authorId,
    this.authorName,
    this.tags,
    required this.likeCount,
    required this.commentCount,
    required this.views,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      id: json['id'], 
      title: json['title'], 
      content: json['content'],
      authorId: json['authorId'] , 
      authorName: json['authorName'], 
      tags: (json['tags'] == null) ? [] : json['tags'],
      likeCount: json['likeCount'], 
      commentCount: json['commentCount'], 
      views: json['views'], 
      createdAt: json['createdAt'], 
      updatedAt: json['updatedAt'],
      imageUrl: json['imageUrl'],
      isLiked: json['like'] ?? false,
    );
  }

}