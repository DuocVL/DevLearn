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
  // Repository để lấy dữ liệu
  final TutorialRepository _repository = TutorialRepository();
  // Scroll controller để phát hiện cuộn xuống cuối
  final ScrollController _scrollController = ScrollController();

  // Danh sách chứa các tutorial
  final List<TutorialSummary> _tutorials = [];
  // Trang hiện tại để phân trang
  int _currentPage = 1;
  // Cờ báo hiệu có còn dữ liệu để tải thêm không
  bool _hasMore = true;
  // Cờ báo hiệu đang tải dữ liệu
  bool _isLoading = false;
  // Cờ báo hiệu có lỗi xảy ra không
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Tải dữ liệu lần đầu tiên
    _fetchTutorials();
    // Thêm listener cho scroll controller
    _scrollController.addListener(_onScroll);
  }

  // Hàm được gọi khi người dùng cuộn
  void _onScroll() {
    // Nếu không còn dữ liệu, hoặc đang tải, thì không làm gì cả
    if (!_hasMore || _isLoading) return;

    // Khi người dùng cuộn gần đến cuối danh sách
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      // Tải thêm dữ liệu
      _fetchTutorials();
    }
  }

  // Hàm tải dữ liệu từ repository
  Future<void> _fetchTutorials({bool isRefresh = false}) async {
    // Nếu đang tải thì không gọi lại
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (isRefresh) {
        _hasError = false;
      }
    });

    try {
      // Nếu là refresh thì reset lại danh sách và trang hiện tại
      if (isRefresh) {
        _currentPage = 1;
        _tutorials.clear();
        _hasMore = true;
      }

      // FIX: Correctly handle the Map returned from the repository
      // 1. Fetch the data which is a Map
      final response = await _repository.getTutorials(page: _currentPage);

      // 2. Extract the list of JSON objects from the 'data' key
      final tutorialsJson = response['data'] as List<dynamic>? ?? [];

      // 3. Convert the JSON list to a List<TutorialSummary>
      final List<TutorialSummary> newTutorials = tutorialsJson
          .map((json) => TutorialSummary.fromJson(json as Map<String, dynamic>))
          .toList();

      setState(() {
        // If the new list is empty, it means we've reached the end
        if (newTutorials.isEmpty) {
          _hasMore = false;
        } else {
          // 4. Add the new list of tutorials to our main list
          _tutorials.addAll(newTutorials);
          _currentPage++;
        }
      });
    } catch (e) {
      // Handle error
      setState(() {
        _hasError = true;
      });
      print('Error fetching tutorials: $e');
    } finally {
      // Mark as not loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchTutorials(isRefresh: true),
        child: _buildTutorialsList(),
      ),
    );
  }

  Widget _buildTutorialsList() {
    if (_isLoading && _tutorials.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError && _tutorials.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Không thể tải được dữ liệu.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _fetchTutorials(isRefresh: true),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }
    if (_tutorials.isEmpty) {
      return const Center(child: Text('Không có bài hướng dẫn nào.'));
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
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
    );
  }
}