import 'package:devlearn/features/home/widgets/welcome_card.dart';
import 'package:flutter/material.dart';
import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/repositories/tutorial_repository.dart';
import 'package:devlearn/features/tutorials/tutorials_screen.dart';
import 'package:devlearn/features/tutorials/widgets/tutorial_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<TutorialSummary>> _tutorialsFuture;
  final _tutorialRepository = TutorialRepository();

  @override
  void initState() {
    super.initState();
    _tutorialsFuture = _fetchHomepageTutorials();
  }

  Future<List<TutorialSummary>> _fetchHomepageTutorials() async {
    try {
      final response = await _tutorialRepository.getTutorials(limit: 4);
      return response['tutorials'] as List<TutorialSummary>;
    } catch (e) {
      print('Error fetching homepage tutorials: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _tutorialsFuture = _fetchHomepageTutorials();
        });
      },
      child: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        children: [
          const WelcomeCard(),
          const SizedBox(height: 16),
          _buildNewTutorialsSection(context),
        ],
      ),
    );
  }

  Widget _buildNewTutorialsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bài hướng dẫn mới',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const TutorialsScreen()),
                  );
                },
                child: const Text('Xem tất cả'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<TutorialSummary>>(
          future: _tutorialsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingPlaceholder(context);
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox(
                height: 100,
                child: Center(
                  child: Text('Không tải được bài hướng dẫn mới.'),
                ),
              );
            }

            final tutorials = snapshot.data!;
            return SizedBox(
              height: 310,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tutorials.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    // SỬA: Bỏ const vì giá trị right phụ thuộc vào biến index
                    margin: EdgeInsets.only(left: 16, right: index == tutorials.length - 1 ? 16 : 0),
                    child: TutorialCard(tutorial: tutorials[index]),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 310,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
             width: screenWidth * 0.8,
             margin: const EdgeInsets.only(left: 16), 
             child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}
