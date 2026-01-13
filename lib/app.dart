import 'package:devlearn/data/models/user.dart';
import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/features/home/home_screen.dart';
import 'package:devlearn/features/login/login_screen.dart';
import 'package:devlearn/main.dart';
import 'package:devlearn/theme/app_theme.dart';
import 'package:devlearn/routes/app_route.dart';
import 'package:flutter/material.dart';

// SỬA LỖI: Hợp nhất logic quản lý trạng thái từ MyApp vào DevLearnApp
class DevLearnApp extends StatefulWidget {
  const DevLearnApp({super.key});

  @override
  State<DevLearnApp> createState() => _DevLearnAppState();
}

class _DevLearnAppState extends State<DevLearnApp> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = authRepository.checkAuth();
  }

  // Hàm callback để cập nhật trạng thái xác thực và xây dựng lại UI
  void _updateAuthenticationState() {
    setState(() {
      _userFuture = authRepository.checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Sử dụng GlobalKey để điều hướng từ bất cứ đâu
      debugShowCheckedModeBanner: true,
      title: 'DevLearn',
      // Giữ lại cài đặt theme của bạn
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // SỬA LỖI: Sử dụng FutureBuilder để quản lý màn hình ban đầu
      home: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return HomeScreen(onLogout: _updateAuthenticationState);
          } else {
            return LoginScreen(onLoginSuccess: _updateAuthenticationState);
          }
        },
      ),
      // SỬA LỖI: Thay thế `routes` và `initialRoute` bằng `onGenerateRoute`
      onGenerateRoute: (settings) => AppRoute.onGenerateRoute(
        settings,
        onLoginSuccess: _updateAuthenticationState,
        onLogout: _updateAuthenticationState,
      ),
    );
  }
}
