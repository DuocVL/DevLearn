class Author {
  final String id;
  final String username;
  final String? avatar;

  Author({required this.id, required this.username, this.avatar});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? 'Anonymous',
      avatar: json['avatar'],
    );
  }
}
