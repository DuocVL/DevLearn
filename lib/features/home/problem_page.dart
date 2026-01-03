import 'package:devlearn/data/models/problem_summary.dart';
import 'package:devlearn/data/repositories/problem_repository.dart';
import 'package:devlearn/widgets/problem_item.dart';
import 'package:flutter/material.dart';

class ProblemPage extends StatefulWidget {
  const ProblemPage({super.key});

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  final _repo = ProblemRepository();
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  final List<ProblemSummary> _problems = [];
  final List<String> _filters = ["All", "Easy", "Medium", "Hard"];
  
  String _selectedFilter = "All";
  bool _isInitialLoading = true;
  bool _isMoreLoading = false;
  bool _hasMore = true;
  int _page = 1;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProblems();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProblems({bool isRefreshing = false}) async {
    if (_isMoreLoading) return;
    
    setState(() {
      _isMoreLoading = true;
      if (isRefreshing) {
        _isInitialLoading = true;
      }
    });

    try {
      final list = await _repo.getProblems(
        page: _page,
        limit: 20,
        difficulty: _selectedFilter,
      );

      if (mounted) {
        setState(() {
          if (list.length < 20) {
            _hasMore = false;
          }
          _problems.addAll(list);
          _page++;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
          _isMoreLoading = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && _hasMore) {
      _fetchProblems();
    }
  }

  Future<void> _onFilterChanged(String newFilter) async {
    setState(() {
      _selectedFilter = newFilter;
      _problems.clear();
      _page = 1;
      _hasMore = true;
      _error = null;
      _isInitialLoading = true;
    });
    await _fetchProblems(isRefreshing: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildBody()),
        ],
      );
  }

  Widget _buildBody() {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _problems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Không thể tải dữ liệu', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => _onFilterChanged(_selectedFilter), child: const Text('Thử lại')),
            ],
          ),
        ),
      );
    }
    
    if (_problems.isEmpty) {
       return const Center(child: Text('Không tìm thấy bài tập nào.'));
    }

    return RefreshIndicator(
      onRefresh: () => _onFilterChanged(_selectedFilter),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _problems.length + (_isMoreLoading ? 1 : 0),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          if (index == _problems.length) {
            return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()));
          }
          return ProblemItem(problemSummary: _problems[index]);
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor))
      ),
      child: SizedBox(
        height: 32,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter;
            return ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) => _onFilterChanged(filter),
              selectedColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              ),
              backgroundColor: theme.colorScheme.surface,
              side: isSelected ? BorderSide.none : BorderSide(color: theme.dividerColor),
            );
          },
        ),
      ),
    );
  }
}