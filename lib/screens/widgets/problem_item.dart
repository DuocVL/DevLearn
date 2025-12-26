import 'package:flutter/material.dart';
import '../../data/models/problem_summary.dart';
import 'package:devlearn/screens/problem/problem_screen.dart';

class ProblemItem extends StatefulWidget {
  final ProblemSummary problemSummary;
  const ProblemItem({super.key, required this.problemSummary});

  @override
  State<ProblemItem> createState() => _ProblemItemState();
}

class _ProblemItemState extends State<ProblemItem> {
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    isSaved = widget.problemSummary.saved;
  }

  Color getDifficultyColor(String diff) {
    switch (diff) {
      case 'Easy':
        return Colors.greenAccent;
      case 'Medium':
        return Colors.amberAccent;
      case 'Hard':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.problemSummary;

    return InkWell(
      onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProblemScreen(idProblem: p.id),
          )
        );

      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.15)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Cột trái: tiêu đề + độ khó + tỉ lệ
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                              getDifficultyColor(p.difficulty).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          p.difficulty,
                          style: TextStyle(
                            fontSize: 12,
                            color: getDifficultyColor(p.difficulty),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.assessment_outlined,
                          color: Colors.grey.shade500, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${p.acceptance.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      
            // 🔹 Cột phải: nút sao + solved icon
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.star : Icons.star_border,
                    color: isSaved ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => setState(() => isSaved = !isSaved),
                  tooltip: isSaved ? 'Đã lưu' : 'Lưu bài',
                ),
                const SizedBox(height: 4),
                if (p.solved)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.lightGreenAccent,
                    size: 20,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
