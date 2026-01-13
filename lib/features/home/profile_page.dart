import 'package:devlearn/data/models/user.dart';
import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/main.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.onLogout});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = authRepository.getProfile();
  }

  Future<void> _logout() async {
    await authRepository.logout();
    widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Could not load profile.'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userFuture = authRepository.getProfile();
                    });
                  },
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

        final user = snapshot.data!;

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                color: Theme.of(context).colorScheme.primary,
                width: double.infinity,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                      child: user.avatarUrl == null ? const Icon(Icons.person, size: 36) : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SỬA: Thay `user.name` bằng `user.username`
                          Text(user.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 6),
                          Text(user.email, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    ElevatedButton(onPressed: () {}, child: const Text('Edit'))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(label: 'Solved', value: user.solvedCount.toString()),
                            _StatItem(label: 'Posts', value: user.postCount.toString()),
                            _StatItem(label: 'Followers', value: user.followerCount.toString()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(onPressed: _logout, icon: const Icon(Icons.logout), label: const Text('Logout')),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
