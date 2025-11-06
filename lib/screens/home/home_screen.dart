import 'package:devlearn/screens/widgets/bottom_nav_items.dart';
import 'package:devlearn/screens/home/home_page.dart';
import 'package:devlearn/screens/home/post_page.dart';
import 'package:devlearn/screens/home/problem_page.dart';
import 'package:devlearn/screens/home/profile_page.dart';
import 'package:devlearn/screens/home/tutorial_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    TutorialPage(),
    ProblemPage(),
    PostPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index){
    setState( () => _selectedIndex = index );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: AppBottomNavItems.items,
      ),
    );
  }
}