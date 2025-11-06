import 'package:flutter/material.dart';
import '../../data/models/tutorial_summary.dart';

class TutorialCard extends StatelessWidget {
  final TutorialSummary tutorial;
  const TutorialCard({super.key, required this.tutorial});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
      Colors.pink.shade100,
    ];
    final color = colors[tutorial.title.hashCode % colors.length];

    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          tutorial.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
