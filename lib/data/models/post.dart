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

  factory Post.fromJson(Map<String, dynamic> json) {
    String id = (json['_id'] ?? json['id'] ?? '').toString();
    String title = (json['title'] ?? '').toString();
    String content = (json['content'] ?? '').toString();
    String? authorId =
        json['authorId']?.toString() ?? json['author_id']?.toString();
    String? authorName =
        json['authorName']?.toString() ?? json['author_name']?.toString();

    List<String> tags = [];
    if (json['tags'] is List) {
      tags = (json['tags'] as List)
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }

    int toIntSafe(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      if (v is num) return v.toInt();
      return 0;
    }

    DateTime parseDate(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is DateTime) return v;
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    int likeCount = toIntSafe(json['likeCount'] ?? json['likes'] ?? 0);
    int commentCount = toIntSafe(json['commentCount'] ?? json['comments'] ?? 0);
    int views = toIntSafe(json['views'] ?? 0);

    DateTime createdAt = parseDate(
      json['createdAt'] ?? json['created_at'] ?? json['created'],
    );
    DateTime updatedAt = parseDate(
      json['updatedAt'] ?? json['updated_at'] ?? json['updated'],
    );

    String? imageUrl =
        json['imageUrl']?.toString() ?? json['image_url']?.toString();

    bool isLiked = false;
    if (json['isLiked'] != null) {
      final v = json['isLiked'];
      if (v is bool) isLiked = v;
      if (v is String) isLiked = v.toLowerCase() == 'true';
      if (v is num) isLiked = v != 0;
    } else if (json['like'] != null) {
      final v = json['like'];
      if (v is bool) isLiked = v;
      if (v is String) isLiked = v.toLowerCase() == 'true';
      if (v is num) isLiked = v != 0;
    }

    return Post(
      id: id,
      title: title,
      content: content,
      authorId: authorId,
      authorName: authorName,
      tags: tags,
      likeCount: likeCount,
      commentCount: commentCount,
      views: views,
      createdAt: createdAt,
      updatedAt: updatedAt,
      imageUrl: imageUrl,
      isLiked: isLiked,
    );
  }
}
