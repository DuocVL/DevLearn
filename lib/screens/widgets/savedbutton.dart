import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SavedButton extends StatefulWidget {

  final bool isSaved;
  const SavedButton({ super.key, required this.isSaved });

  @override
  State<SavedButton> createState() => _SavedButtonState();
}

class _SavedButtonState extends State<SavedButton> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    isSaved = widget.isSaved;
    return IconButton(
      onPressed: () => setState(() => isSaved = !isSaved),
      icon: SvgPicture.asset(
        'assets/icons/saved.svg',
        width: 28,
        colorFilter: ColorFilter.mode(
            isSaved ? Colors.amber : Colors.grey,
            BlendMode.srcIn,
        ),
      ),
    );
  }
}
