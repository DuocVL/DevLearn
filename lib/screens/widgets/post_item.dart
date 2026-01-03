import 'package:devlearn/data/models/post.dart';
import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late bool isLiked;
  late int localLikeCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLiked;
    localLikeCount = widget.post.likeCount;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        localLikeCount++;
      } else {
        localLikeCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeAgo = _formatTimeAgo(widget.post.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(post: widget.post)));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author and Time ago
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      widget.post.authorName?.isNotEmpty == true
                          ? widget.post.authorName![0].toUpperCase()
                          : 'A',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.authorName ?? 'Anonymous',
                        style: theme.textTheme.labelLarge,
                      ),
                      Text(
                        timeAgo,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title and Content
              Text(
                widget.post.title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                widget.post.content,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurface.withOpacity(0.8)),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Tags
              if (widget.post.tags?.isNotEmpty == true)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 4.0,
                    children: widget.post.tags!
                        .map((tag) => Chip(
                              label: Text(tag),
                              padding: EdgeInsets.zero,
                              labelStyle: theme.chipTheme.labelStyle?.copyWith(fontSize: 10),
                              backgroundColor: theme.chipTheme.backgroundColor,
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),
                ),
              
              const Divider(),
              
              // Stats and Like button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _iconStat(theme, Icons.thumb_up_alt_outlined, localLikeCount),
                      const SizedBox(width: 20),
                      _iconStat(theme, Icons.comment_outlined, widget.post.commentCount),
                      const SizedBox(width: 20),
                      _iconStat(theme, Icons.remove_red_eye_outlined, widget.post.views),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.redAccent : colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: _toggleLike,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconStat(ThemeData theme, IconData icon, int count) {
    return Row(
      children: [
        Icon(icon,
            color: theme.colorScheme.onSurface.withOpacity(0.6), size: 16),
        const SizedBox(width: 6),
        Text(
          '$count',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8)),
        ),
      ],
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

