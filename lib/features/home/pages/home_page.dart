import 'package:devlearn/data/models/tutorial.dart';
import 'package:devlearn/data/services/tutorial_service.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tutorialService = TutorialService();
  late Future<List<TutorialSummary>> _tutorialsFuture;

  @override
  void initState() {
    super.initState();
    _tutorialsFuture = _tutorialService.getAllTutorials();
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
              final tutorial = tutorials[index];
              return ListTile(
                title: Text(tutorial.title),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.tutorialDetail, arguments: tutorial);
                },
              );
            },
          );
        },
      );
  }
}
