import 'package:devlearn/data/models/problem.dart';
import 'package:devlearn/data/repositories/problem_repository.dart';
import 'package:devlearn/features/problems/widgets/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// SỬA LẠI: Đổi tên idProblem -> problemId để thống nhất
class ProblemScreen extends StatefulWidget {
  final String problemId;
  const ProblemScreen({super.key, required this.problemId});

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> with TickerProviderStateMixin {
  final ProblemRepository _repo = ProblemRepository();
  late Future<Problem> _problemFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // SỬA: Tải dữ liệu thật từ server bằng ID
    _problemFuture = _repo.getProblemById(widget.problemId);
    _tabController = TabController(length: 3, vsync: this);
  }

  void _handleSubmit(String language, String code) {
    // TODO: Tích hợp API chấm điểm
    print('Submitting code for $language:');
    print(code);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng nộp bài đang được phát triển!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // SỬA: Tiêu đề động sau khi dữ liệu được tải
        title: FutureBuilder<Problem>(
          future: _problemFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.title);
            }
            return const Text('Đang tải...');
          },
        ),
        elevation: 0.5,
      ),
      // SỬA: Thay thế hoàn toàn body bằng FutureBuilder để xử lý trạng thái tải dữ liệu
      body: FutureBuilder<Problem>(
        future: _problemFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi tải bài tập: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy bài tập.'));
          }

          final problem = snapshot.data!;

          // SỬA: Tái cấu trúc với TabView và thiết kế mới
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Đề bài'),
                  Tab(text: 'Lập trình'),
                  Tab(text: 'Lịch sử nộp'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(), // Tắt cuộn ngang
                  children: [
                    _buildDescriptionTab(problem),
                    problem.starterCode.isNotEmpty
                        ? CodeEditor(starterCode: problem.starterCode, onSubmit: _handleSubmit)
                        : const Center(child: Text('Phần code cho bài tập này chưa có sẵn.')),
                    const Center(child: Text('Lịch sử các lần nộp bài sẽ được hiển thị ở đây.')),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDescriptionTab(Problem problem) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               _buildDifficultyChip(problem.difficulty, theme),
               Text('${problem.likeCount} likes', style: theme.textTheme.bodyMedium)
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: problem.tags.map((tag) => _buildTagChip(tag, theme)).toList(),
          ),
          const Divider(height: 40),
          MarkdownBody(
            data: problem.description,
            styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
              p: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          ..._buildExamples(problem.examples, theme),
          if (problem.constraints.isNotEmpty) ...[
            Text('Ràng buộc:', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            MarkdownBody(data: problem.constraints.map((c) => '• `$c`').join('\n')),
          ],
        ],
      ),
    );
  }
  
  Widget _buildDifficultyChip(String difficulty, ThemeData theme) {
    Color color;
    switch (difficulty.toLowerCase()) {
      case 'easy': color = Colors.green; break;
      case 'medium': color = Colors.orange; break;
      case 'hard': color = Colors.red; break;
      default: color = Colors.grey;
    }
    return Chip(
      label: Text(difficulty, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  Widget _buildTagChip(String tag, ThemeData theme) {
    return Chip(
      label: Text(tag),
      backgroundColor: theme.colorScheme.surfaceVariant,
      side: BorderSide.none,
    );
  }

  List<Widget> _buildExamples(List<Example> examples, ThemeData theme) {
    if (examples.isEmpty) return [];
    return [
      Text('Ví dụ:', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ...examples.asMap().entries.map((entry) {
        int idx = entry.key;
        Example ex = entry.value;
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ví dụ ${idx + 1}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _codeBlock('Input', ex.input, theme),
              const SizedBox(height: 8),
              _codeBlock('Output', ex.output, theme),
              if (ex.explanation != null && ex.explanation!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Giải thích: ${ex.explanation}'),
                ),
            ],
          ),
        );
      })
    ];
  }

  Widget _codeBlock(String label, String code, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(4)
          ),
          child: Text(code, style: const TextStyle(fontFamily: 'monospace')),
        ),
      ],
    );
  }
}
