import 'package:devlearn/data/models/tutorial_summary.dart';
import 'package:devlearn/data/repositories/tutorial_repository.dart';
import 'package:devlearn/features/tutorials/widgets/tutorial_card.dart';
import 'package:flutter/material.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  final _repository = TutorialRepository();
  final _scrollController = ScrollController();

  final List<TutorialSummary> _tutorials = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchTutorials();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchTutorials({bool isRefresh = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      if (isRefresh) {
        _currentPage = 1;
        _tutorials.clear();
        _hasMore = true;
      }

      final response = await _repository.getTutorials(page: _currentPage);
      final List<TutorialSummary> fetchedTutorials = response['tutorials'];
      final pagination = response['pagination'];

      setState(() {
        _tutorials.addAll(fetchedTutorials);
        _currentPage++;
        _totalPages = pagination['totalPages'] ?? _currentPage;
        _hasMore = _currentPage <= _totalPages;
      });
    } catch (e) {
      // TODO: Xử lý lỗi tốt hơn
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9 && _hasMore && !_isLoading) {
      _fetchTutorials();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Học tập'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchTutorials(isRefresh: true),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _tutorials.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _tutorials.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return TutorialCard(tutorial: _tutorials[index]);
          },
        ),
      ),
    );
  }
}
