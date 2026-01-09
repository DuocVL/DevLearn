import 'package:devlearn/data/models/tutorial.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/services/tutorial_service.dart';
import 'package:devlearn/features/lesson_detail/lesson_detail_screen.dart';
import 'package:flutter/material.dart';

class TutorialDetailScreen extends StatefulWidget {
  final TutorialSummary tutorialSummary;
  const TutorialDetailScreen({super.key, required this.tutorialSummary});

  @override
  State<TutorialDetailScreen> createState() => _TutorialDetailScreenState();
}

class _TutorialDetailScreenState extends State<TutorialDetailScreen> {
  late Future<Tutorial> _tutorialFuture;
  final _tutorialService = TutorialService();

  @override
  void initState() {
    super.initState();
    _tutorialFuture = _tutorialService.getTutorialById(widget.tutorialSummary.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tutorialSummary.title)),
      body: FutureBuilder<Tutorial>(
        future: _tutorialFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Tutorial not found.'));
          }

          final tutorial = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tutorial.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Text('Lessons', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                ...tutorial.lessons.map((lesson) {
                  return ListTile(
                    title: Text(lesson.title),
                    leading: const Icon(Icons.play_circle_outline),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => LessonDetailScreen(lessonSummary: lesson),
                      ));
                    },
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
