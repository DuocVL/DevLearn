import 'package:devlearn/screens/post/post_screen.dart';
import 'package:flutter/material.dart';
import '../../data/models/post.dart';
import '../../core/utils/helpers.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    final timeago = timeAgo(widget.post.createdAt);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(post: widget.post),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + tên + thời gian
              Row(
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    (widget.post.authorName == null) ? "Ẩn danh" : widget.post.authorName!,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '· $timeago',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
      
              const SizedBox(height: 8),
      
              // Tiêu đề
              Text(
                widget.post.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      
              const SizedBox(height: 4),
      
              // Nội dung
              Text(
                widget.post.content.length > 100
                    ? '${widget.post.content.substring(0, 100)}...'
                    : widget.post.content,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
      
              const SizedBox(height: 8),
      
              // Like - View - Comment
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      setState(() => isLiked = !isLiked);
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isLiked ? Colors.amberAccent : Colors.white30),
                        borderRadius: BorderRadius.circular(30),
                        color: isLiked
                            ? Colors.amberAccent.withOpacity(0.15)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                            color: isLiked ? Colors.amber : Colors.white54,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.post.likeCount + (isLiked ? 1 : 0) - (widget.post.isLiked ? 1 : 0)}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _iconStat(Icons.remove_red_eye_outlined, widget.post.views),
                  const SizedBox(width: 16),
                  _iconStat(Icons.comment_outlined, widget.post.commentCount),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconStat(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 16),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
      ],
    );
  }


}
