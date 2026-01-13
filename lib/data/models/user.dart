class User {
  final String id;
  // SỬA: Đổi tên thuộc tính để đồng bộ
  final String username;
  final String email;
  final String? avatarUrl;
  final int solvedCount;
  final int postCount;
  final int followerCount;

  User({
    required this.id,
    // SỬA: Cập nhật constructor
    required this.username,
    required this.email,
    this.avatarUrl,
    this.solvedCount = 0,
    this.postCount = 0,
    this.followerCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userData = json.containsKey('user') ? json['user'] as Map<String, dynamic> : json;

    return User(
      id: userData['_id'] ?? '',
      // SỬA: Gán vào thuộc tính `username` mới
      username: userData['username'] ?? 'No Name',
      email: userData['email'] ?? '',
      avatarUrl: userData['avatarUrl'],
      solvedCount: userData['solvedCount'] ?? 0,
      postCount: userData['postCount'] ?? 0,
      followerCount: userData['followerCount'] ?? 0,
    );
  }
}
