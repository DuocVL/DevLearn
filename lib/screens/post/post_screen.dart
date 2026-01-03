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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(post.title, style: Theme.of(context).textTheme.titleLarge),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(radius: 16, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 16, color: Colors.white)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.authorName ?? 'Ẩn danh', style: Theme.of(context).textTheme.bodyMedium),
                                  const SizedBox(height: 2),
                                  Text('$timeago • ${post.views} lượt xem', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (post.tags != null && post.tags!.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: post.tags!
                                .map((tag) => Chip(label: Text(tag, style: Theme.of(context).textTheme.bodySmall)))
                                .toList(),
                          ),
                        const SizedBox(height: 10),
                        Text(post.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(post.content, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: BottomAppBar(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_alt_outlined),
                label: Text('${post.likeCount}'),
              ),
              TextButton.icon(
                onPressed: () => _showComments(context),
                icon: const Icon(Icons.comment_outlined),
                label: Text('${post.commentCount}'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined),
                label: const Text('Chia sẻ'),
              ),
            ],
          ),
        ),
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
