class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int solvedCount;
  final int postCount;
  final int followerCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.solvedCount = 0,
    this.postCount = 0,
    this.followerCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      solvedCount: json['solvedCount'] ?? 0,
      postCount: json['postCount'] ?? 0,
      followerCount: json['followerCount'] ?? 0,
    );
  }
}
