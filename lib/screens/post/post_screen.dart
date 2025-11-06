import 'package:flutter/material.dart';
import '../../data/models/post.dart';
import 'package:intl/intl.dart';

class PostScreen extends StatelessWidget {
  final Post post;

  const PostScreen({super.key, required this.post});

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Text(
          post.title,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hàng 1: Tác giả + ngày đăng
            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 14, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  post.authorName == null ? "Ẩn danh" : post.authorName!,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(width: 8),
                Text(
                  '· ${_formatDate(post.createdAt)}',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tiêu đề
            Text(
              post.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Nội dung
            Text(
              post.content,
              style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Thống kê
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _iconStat(Icons.favorite, post.likeCount, Colors.redAccent),
                _iconStat(Icons.comment, post.commentCount, Colors.blueAccent),
                _iconStat(Icons.remove_red_eye, post.views, Colors.grey),
              ],
            ),
            const SizedBox(height: 20),

            // Tags (nếu có)
            if (post.tags != null && post.tags!.isNotEmpty)
              Wrap(
                spacing: 8,
                children: post.tags!.map((tag) {
                  return Chip(
                    label: Text(tag),
                    backgroundColor: Colors.blueGrey.shade800,
                    labelStyle: const TextStyle(color: Colors.white),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _iconStat(IconData icon, int count, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
