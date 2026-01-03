import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {

  final TextEditingController controller;
  final void Function(String)? onSearchChanged;


  const SearchWidget({
    super.key,
    required this.controller,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: controller,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: "Tìm kiếm vấn đề ...",
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

