import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/features/tutorial_detail/tutorial_detail_screen.dart';
import 'package:flutter/material.dart';

class TutorialCard extends StatelessWidget {
  final TutorialSummary tutorial;
  const TutorialCard({super.key, required this.tutorial});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias, // Ensures the InkWell ripple is clipped to the card's rounded corners
      child: InkWell(
        onTap: () {
          // Temporarily disabled until TutorialScreen is ready
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TutorialDetailScreen(tutorialSummary: tutorial),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tutorial.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                tutorial.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              if (tutorial.tags.isNotEmpty)
                Wrap(
                  spacing: 6.0,
                  runSpacing: 4.0,
                  children: tutorial.tags
                      .take(3) // Show a max of 3 tags to avoid overflow
                      .map((tag) => Chip(
                            label: Text(tag),
                            padding: EdgeInsets.zero,
                            labelStyle: theme.chipTheme.labelStyle?.copyWith(fontSize: 10),
                            backgroundColor: theme.chipTheme.backgroundColor,
                            side: BorderSide.none,
                          ))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
