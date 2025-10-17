import 'package:devlearn/core/widgets/savedbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/problem_summary.dart';

class ProblemItem extends StatefulWidget {

  final ProblemSummary problemSummary;

  const ProblemItem({super.key, required this.problemSummary});

  @override
  State<ProblemItem> createState() => _ProblemItemState();
}

class _ProblemItemState extends State<ProblemItem> {

  Color getDifficultyColor(String diff){
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
    return Container(
      margin: const EdgeInsets.symmetric( vertical: 6, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Tiêu đề
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.problemSummary.title,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              if(widget.problemSummary.solved)
                SvgPicture.asset(
                  'assets/icons/solved.svg',
                  width: 24,
                  height: 24,
                  theme: SvgTheme(currentColor: Colors.lightGreen),
                ),
            ],
          ),
          const SizedBox(height: 6,),

          //Độ khó tỉ lệ , saved
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: getDifficultyColor(widget.problemSummary.difficulty).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.problemSummary.difficulty,
                      style: TextStyle(
                        fontSize: 12,
                        color: getDifficultyColor(widget.problemSummary.difficulty),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Text(
                    widget.problemSummary.acceptance.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SavedButton(isSaved: widget.problemSummary.saved),
            ],
          )
        ],
      ),
    );
  }
}