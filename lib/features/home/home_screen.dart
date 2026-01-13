import 'package:devlearn/widgets/bottom_nav_items.dart';
import 'package:devlearn/features/home/home_page.dart';
import 'package:devlearn/features/home/post_page.dart';
import 'package:devlearn/features/home/problem_page.dart';
import 'package:devlearn/features/home/profile_page.dart';
import 'package:devlearn/features/home/tutorial_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  // SỬA: Thêm callback để xử lý đăng xuất
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // SỬA: _pages không thể là const nữa vì ProfilePage cần tham số
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Khởi tạo danh sách các trang ở đây
    _pages = [
      const HomePage(),
      const TutorialPage(),
      const ProblemPage(),
      const PostPage(),
      // Truyền callback onLogout vào ProfilePage
      ProfilePage(onLogout: widget.onLogout), 
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
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
      floatingActionButton: _selectedIndex == 3
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_post');
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: AppBottomNavItems.items,
      ),
    );
  }
}
