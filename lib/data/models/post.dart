class Post {
  final String id;
  final String title;
  final String content;
  final String? authorId;
  final String? authorName;
  final List<String> tags;
  final int likeCount;
  final int commentCount;
  final int views;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;
  final bool isLiked;
  final bool isAnonymous;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.authorId,
    this.authorName,
    required this.tags,
    required this.likeCount,
    required this.commentCount,
    required this.views,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.isLiked = false,
    required this.isAnonymous,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // Helper functions from the original model
    int toIntSafe(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    DateTime parseDate(dynamic v) {
      if (v == null) return DateTime.now();
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    // --- START OF FIX ---

    // Correctly parse author information from the nested 'author' object
    String? authorId;
    String? authorName;
    final bool isAnonymous = json['anonymous'] as bool? ?? false;

    if (!isAnonymous && json['author'] != null && json['author'] is Map<String, dynamic>) {
      final authorJson = json['author'] as Map<String, dynamic>;
      authorId = (authorJson['_id'] ?? authorJson['id'])?.toString();
      final firstName = authorJson['firstName']?.toString() ?? '';
      final lastName = authorJson['lastName']?.toString() ?? '';
      authorName = '$firstName $lastName'.trim();
      if (authorName.isEmpty) {
        authorName = 'Anonymous User'; // Fallback if name fields are empty
      }
    } else {
      authorName = 'Anonymous';
    }

    // --- END OF FIX ---

    return Post(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      authorId: authorId,
      authorName: authorName,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      likeCount: toIntSafe(json['likeCount']),
      commentCount: toIntSafe(json['commentCount']),
      views: toIntSafe(json['views']),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      imageUrl: json['imageUrl']?.toString(),
      isLiked: json['isLiked'] as bool? ?? false,
      isAnonymous: isAnonymous,
    );
  }
}
