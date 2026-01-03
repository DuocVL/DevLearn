import 'package:flutter/material.dart';

class ProblemBottomActions extends StatelessWidget {
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isDisliked;
  final bool isSaved;

  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onComment;
  final VoidCallback onSave;

  const ProblemBottomActions({
    super.key,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.isDisliked,
    required this.isSaved,
    required this.onLike,
    required this.onDislike,
    required this.onComment,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, -1),
            blurRadius: 6,
          ),
        ],
        border: Border(
          top: BorderSide(color: cs.onSurface.withOpacity(0.08)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 👍 LIKE BOX
          _actionBox(
            context,
            active: isLiked,
            icon: isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
            value: likes,
            onTap: onLike,
          ),

          // 👎 DISLIKE BOX
          _actionBox(
            context,
            active: isDisliked,
            icon:
                isDisliked ? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined,
            value: null,
            onTap: onDislike,
          ),

          // 💬 COMMENTS
          GestureDetector(
            onTap: onComment,
            child: Row(
              children: [
                Icon(Icons.comment_outlined,
                    color: cs.onSurface.withOpacity(0.85), size: 22),
                const SizedBox(width: 6),
                Text(
                  comments.toString(),
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: cs.onSurface.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // ⭐ SAVE
          GestureDetector(
            onTap: onSave,
            child: Icon(
              isSaved ? Icons.star : Icons.star_border,
              color: isSaved ? Colors.amber : cs.onSurface.withOpacity(0.9),
              size: 26,
            ),
          )
        ],
      ),
    );
  }

  // 🔹 CUSTOM LIKE / DISLIKE BOX
  Widget _actionBox(
    BuildContext context, {
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
    int? value,
  }) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? cs.primary.withOpacity(0.15) : cs.surfaceVariant.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active
                ? cs.primary
                : cs.onSurface.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? cs.primary : cs.onSurface.withOpacity(0.85),
            ),
            if (value != null) ...[
              const SizedBox(width: 6),
              Text(
                value.toString(),
                style: TextStyle(
                  color: active ? cs.primary : cs.onSurface.withOpacity(0.85),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
