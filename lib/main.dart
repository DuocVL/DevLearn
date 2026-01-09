import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/features/home/home_screen.dart';
import 'package:devlearn/features/login/login_screen.dart';
import 'package:devlearn/data/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// SỬA LỖI: Định nghĩa GlobalKey để truy cập Navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Khởi tạo các dịch vụ cốt lõi
final secureStorage = const FlutterSecureStorage();
final dio = Dio();

// SỬA LỖI: Hàm callback để xử lý lỗi xác thực
void _handleAuthenticationFailure() {
  // Xóa tất cả các màn hình và đẩy màn hình đăng nhập
  navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
}

// SỬA LỖI: Cập nhật khởi tạo ApiClient để truyền hàm callback
final apiClient = ApiClient(
  dio: dio,
  secureStorage: secureStorage,
  onAuthenticationFailure: _handleAuthenticationFailure, // Truyền hàm vào đây
);

final authRepository = AuthRepository();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = authRepository.checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // SỬA LỖI: Gán navigatorKey cho MaterialApp
      navigatorKey: navigatorKey,
      title: 'DevLearn',
      theme: ThemeData.dark(),
      home: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
