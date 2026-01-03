import 'package:devlearn/data/models/problem_summary.dart';
import 'package:devlearn/screens/problem/problem_screen.dart';
import 'package:flutter/material.dart';

class ProblemItem extends StatefulWidget {
  final ProblemSummary problemSummary;
  const ProblemItem({super.key, required this.problemSummary});

  @override
  State<ProblemItem> createState() => _ProblemItemState();
}

class _ProblemItemState extends State<ProblemItem> {
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    isSaved = widget.problemSummary.saved;
  }

  Color _getDifficultyColor(BuildContext context, String difficulty) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return isLight ? Colors.green.shade700 : Colors.greenAccent.shade400;
      case 'medium':
        return isLight ? Colors.orange.shade800 : Colors.amberAccent.shade400;
      case 'hard':
        return isLight ? Colors.red.shade700 : Colors.redAccent.shade400;
      default:
        return Colors.grey.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final p = widget.problemSummary;
    final difficultyColor = _getDifficultyColor(context, p.difficulty);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProblemScreen(idProblem: p.id),
          //   ),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (p.solved)
                Icon(
                  Icons.check_circle,
                  color: Colors.green.withOpacity(0.8),
                  size: 20,
                )
              else
                Icon(
                  Icons.circle_outlined,
                  color: colorScheme.onSurface.withOpacity(0.2),
                  size: 20,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          p.difficulty,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: difficultyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.insights,
                          size: 14,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${p.acceptance.toStringAsFixed(1)}% acceptance',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  isSaved ? Icons.star_rounded : Icons.star_border_rounded,
                  color: isSaved
                      ? theme.colorScheme.secondary
                      : colorScheme.onSurface.withOpacity(0.4),
                ),
                onPressed: () => setState(() => isSaved = !isSaved),
                tooltip: isSaved ? 'Unsave' : 'Save problem',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

