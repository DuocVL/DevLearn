import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TutorialCard extends StatelessWidget {
  final TutorialSummary tutorial;

  const TutorialCard({super.key, required this.tutorial});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.compact(locale: 'en_US');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          // TODO: Điều hướng đến màn hình chi tiết tutorial
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sẽ mở chi tiết: ${tutorial.title}')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Text(
                tutorial.title,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Mô tả ngắn
              Text(
                tutorial.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Các thẻ tag
              Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: tutorial.tags
                    .map((tag) => Chip(
                          label: Text(tag, style: theme.textTheme.bodySmall),
                          backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: BorderSide.none,
                        ))
                    .toList(),
              ),
              const Divider(height: 24),

              // Thông tin tác giả và chỉ số
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        // TODO: Thêm ảnh đại diện của tác giả
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          tutorial.author?.username.substring(0, 1).toUpperCase() ?? 'A',
                          style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tutorial.author?.username ?? 'Anonymous',
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildInfoChip(context, Icons.bar_chart_rounded, numberFormat.format(tutorial.totalViews)),
                      const SizedBox(width: 8),
                      _buildInfoChip(context, Icons.menu_book_rounded, '${tutorial.lessonCount} bài'),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 14, color: theme.textTheme.bodySmall?.color),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
