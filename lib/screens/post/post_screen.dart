import 'package:flutter/material.dart';
import '../../data/models/post.dart';
import '../../core/utils/helpers.dart';

class PostScreen extends StatelessWidget {
  final Post post;
  const PostScreen({super.key, required this.post});

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const CommentBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeago = timeAgo(post.createdAt);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Text(post.title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 70),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hàng thông tin
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 14, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post.authorName ?? "Ẩn danh",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.remove_red_eye, color: Colors.white38, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${post.views}',
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.access_time, color: Colors.white38, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        timeago,
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Tag
                  if (post.tags != null && post.tags!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: post.tags!
                          .map((tag) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 12),

                  // Tiêu đề
                  Text(
                    post.title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Nội dung
                  Text(
                    post.content,
                    style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),
          ),

          // Thanh dưới cố định
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1E),
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _bottomButton(Icons.arrow_upward, post.likeCount),
                  _bottomButton(Icons.comment_outlined, post.commentCount, onTap: () {
                    _showComments(context);
                  }),
                  _bottomButton(Icons.share_outlined, 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButton(IconData icon, int count, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ================= Comment BottomSheet =================

class CommentBottomSheet extends StatelessWidget {
  const CommentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) => Column(
        children: [
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text("Bình luận", style: TextStyle(color: Colors.white, fontSize: 16)),
          const Divider(color: Colors.white24),

          // Danh sách comment (tạm rỗng)
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: 0, // sau này thay bằng comments.length
              itemBuilder: (context, index) => const SizedBox.shrink(),
            ),
          ),

          // Ô nhập bình luận
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF0D0D0D),
              border: Border(top: BorderSide(color: Colors.white12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Viết bình luận...",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF1C1C1E),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
