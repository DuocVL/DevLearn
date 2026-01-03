import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final List<String> filters = ["Dễ", "Trung bình", "Khó", "Đã làm", "Chưa làm"];
  final Set<String> selected = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Bộ lọc",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          
          ElevatedButton(
            onPressed: () => Navigator.pop(context, selected.toList()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text("Áp dụng"),
          ),
        ],
      ),
    );
  }

}
