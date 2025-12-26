import 'package:devlearn/screens/widgets/filter_widget.dart';
import 'package:devlearn/screens/widgets/problem_item.dart';
import 'package:devlearn/screens/widgets/search_widget.dart';
import 'package:devlearn/data/models/problem_summary.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/problem_repository.dart';

class ProblemPage extends StatefulWidget {
  const ProblemPage({super.key});

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {

  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All";

  final List<String> filters = [
    "All", "Easy", "Medium", "Hard", "Solved", "Revision"
  ];

  final ScrollController _scrollController = ScrollController();

  final List<ProblemSummary> _problems = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;

  final _repo = ProblemRepository();

  @override
  void initState() {
    super.initState();
    _fetchProblems();
    _scrollController.addListener(_onScroll);
  }

   Future<void> _fetchProblems() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    final list = await _repo.getProblems(page: _page, limit: 20, difficulty: _selectedFilter == 'All' ? null : _selectedFilter);

    setState(() {
      _problems.addAll(list);
      _isLoading = false;
      _page++;
      if (list.length < 20) _hasMore = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _fetchProblems();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0F),
        elevation: 0,
        title: SearchWidget(
          controller: _searchController,
        ),
        actions: [
          IconButton(
            onPressed: () => _openFilter(context), 
            icon: const Icon(Icons.filter_list, color: Colors.grey,)
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _problems.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _problems.length) {
            return ProblemItem(problemSummary: _problems[index]);
          } else {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent : const Color(0xFF1C1C2E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  void _openFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FilterBottomSheet(),
    );
  }
}