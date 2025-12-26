import 'package:devlearn/screens/widgets/problem_bottom_actions.dart';
import 'package:flutter/material.dart';
import 'package:devlearn/data/models/problem.dart';
import 'package:devlearn/data/models/example.dart';
import '../widgets/SectionTitle.dart';

class ProblemScreen extends StatefulWidget {
  final String idProblem; // ID truyền từ danh sách
  const ProblemScreen({super.key, required this.idProblem});

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  Problem? problem; // Dữ liệu sau khi fetch
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProblemData();
  }

  Future<void> _fetchProblemData() async {
    await Future.delayed(const Duration(seconds: 1)); // giả lập API delay

    setState(() {
      problem = Problem(
        id: widget.idProblem,
        title: "Two Sum",
        description:
            "Cho một mảng các số nguyên nums và một số nguyên target, trả về chỉ số của hai số sao cho tổng của chúng bằngtarget .Bạn có thể cho rằng mỗi đầu vào sẽ có đúng một giải pháp và bạn không được sử dụng cùng một phần tử hai lần.Bạn có thể trả lời theo bất kỳ thứ tự nào.",
        difficulty: "Easy",
        tags: ["Array", "HashMap"],
        examples: [
          Example(
            input: "nums = [2,7,11,15], target = 9",
            output: "[0,1]",
            order: "1",
          ),
        ],
        constraints: ["2 <= nums.length <= 10^4", "-10^9 <= nums[i] <= 10^9"],
        hints: ["Dùng HashMap để lưu và tra nhanh phần bù của target."],
        likeCount: 1243,
        commentCount: 56,
        totalSubmissions: 5000,
        acceptedSubmissions: 2450,
      );
      isLoading = false;
    });
  }

  Color _getDifficultyColor(String diff, BuildContext context) {
    switch (diff.toLowerCase()) {
      case "easy":
        return Colors.green;
      case "medium":
        return Colors.orange;
      case "hard":
        return Colors.redAccent;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (problem == null) {
      return const Scaffold(
        body: Center(child: Text("Không tìm thấy bài toán.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(problem!.title), elevation: 0.5),
      bottomNavigationBar: ProblemBottomActions(isDisliked: false, likes:  60, comments: 40, isLiked: true, isSaved: true,onComment: () {}, onLike: () {}, onDislike: () {}, onSave: () {},),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧠 Difficulty + Tags
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(
                      problem!.difficulty,
                      context,
                    ).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    problem!.difficulty,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _getDifficultyColor(problem!.difficulty, context),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: -8,
                    children: problem!.tags!.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Divider(height: 30),
            SectionTitle("Description"),

            const SizedBox(height: 8),
            Text(
              problem!.description,
              style: theme.textTheme.bodyMedium!.copyWith(height: 1.4),
            ),

            const SizedBox(height: 22),
            if (problem!.examples!.isNotEmpty) ...[
              const Divider(height: 30),
              SectionTitle("Example"),
              const SizedBox(height: 12),
              _buildExampleCard(problem!.examples!.first, theme),
            ],

            if (problem!.constraints!.isNotEmpty) ...[
              const Divider(height: 30),
              SectionTitle("Constraints"),
              const SizedBox(height: 12),
              _buildListSection(problem!.constraints!, theme),
            ],

            if (problem!.hints!.isNotEmpty) ...[
              const Divider(height: 30),
              SectionTitle("Hints"),
              const SizedBox(height: 12),
              _buildListSection(problem!.hints!, theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(Example example, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        color: theme.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                "Example ${example.order}",
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _codeLine("Input", example.input),
          const SizedBox(height: 6),
          _codeLine("Output", example.output),
        ],
      ),
    );
  }

  Widget _codeLine(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildListSection(List<String> items, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("•  ", style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        item,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
