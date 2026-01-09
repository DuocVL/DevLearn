import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/services/tutorial_service.dart';
import 'package:devlearn/widgets/tutorial_card.dart';
import 'package:flutter/material.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  late final TutorialService _tutorialService;
  late Future<List<TutorialSummary>> _tutorialsFuture;

  @override
  void initState() {
    super.initState();
    _tutorialService = TutorialService();
    _tutorialsFuture = _tutorialService.getTutorials();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TutorialSummary>>(
        future: _tutorialsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tutorials found.'));
          }

          final tutorials = snapshot.data!;
          return ListView.builder(
            itemCount: tutorials.length,
            itemBuilder: (context, index) {
              return TutorialCard(tutorial: tutorials[index]);
            },
          );
        },
      );
  }
}
