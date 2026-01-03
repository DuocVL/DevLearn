import 'package:devlearn/data/models/user.dart';
import 'package:devlearn/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authRepo = AuthRepository();
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _authRepo.getProfile();
  }

  Future<void> _logout() async {
    final ok = await _authRepo.logout();
    if (ok) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(RouteName.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logout failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: FutureBuilder<User?>(
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
                        _userFuture = _authRepo.getProfile();
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
                            Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 6),
                            Text(user.email, style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                      ElevatedButton(onPressed: () {}, child: Text(l10n.edit))
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
                              _StatItem(label: l10n.solved, value: user.solvedCount.toString()),
                              _StatItem(label: l10n.posts, value: user.postCount.toString()),
                              _StatItem(label: l10n.followers, value: user.followerCount.toString()),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(onPressed: _logout, icon: const Icon(Icons.logout), label: Text(l10n.logout)),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
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