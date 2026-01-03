import 'package:flutter/material.dart';
import '../../data/models/tutorial_summary.dart';
import '../widgets/tutorial_card.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final List<TutorialSummary> tutorials = [
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: tutorials.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => TutorialCard(tutorial: tutorials[index]),
      ),
    );
  }
}