import 'package:devlearn/screens/widgets/bottom_nav_items.dart';
import 'package:devlearn/screens/home/home_page.dart';
import 'package:devlearn/screens/home/post_page.dart';
import 'package:devlearn/screens/home/problem_page.dart';
import 'package:devlearn/screens/home/profile_page.dart';
import 'package:devlearn/screens/home/tutorial_page.dart';
import 'package:flutter/material.dart';

// Home screen wrapper with adaptive AppBar and FAB suitable for a learning app

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
    final titles = ['Home', 'Tutorials', 'Problems', 'Posts', 'Profile'];
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex], style: const TextStyle(fontWeight: FontWeight.w600)),
        elevation: 1,
        actions: [
          if (_selectedIndex == 0 || _selectedIndex == 2)
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {
                // optional: open search UI
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open search')));
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(radius: 16, backgroundColor: Theme.of(context).colorScheme.primary, child: const Icon(Icons.person, size: 18, color: Colors.white)),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: AppBottomNavItems.items,
      ),
    );
  }
}