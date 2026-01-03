import 'package:flutter/material.dart';

class AppBottomNavItems {
  static const List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Trang chủ',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school_outlined),
      activeIcon: Icon(Icons.school),
      label: 'Học tập',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.code_outlined),
      activeIcon: Icon(Icons.code),
      label: 'Vấn đề',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.article_outlined),
      activeIcon: Icon(Icons.article),
      label: 'Bài viết',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Cá nhân',
    ),
  ];
}
