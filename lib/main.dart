import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/models/user.dart';
import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:devlearn/features/home/home_screen.dart';
import 'package:devlearn/features/login/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// SỬA LỖI: Di chuyển khởi tạo vào trong main() sử dụng `late final`

// 1. Khai báo các dịch vụ nhưng chưa khởi tạo
late final Dio dio;
late final ApiClient apiClient;
late final AuthRepository authRepository;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final secureStorage = const FlutterSecureStorage();

// Hàm callback để xử lý lỗi xác thực (không đổi)
void _handleAuthenticationFailure() {
  navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 2. Tải các biến môi trường TRƯỚC TIÊN
  await dotenv.load(fileName: ".env");

  // 3. Lấy API_BASE_URL từ .env
  final apiBaseUrl = dotenv.env['API_BASE_URL'];
  if (apiBaseUrl == null || apiBaseUrl.isEmpty) {
    // Dừng ứng dụng nếu URL không được cấu hình để tránh lỗi
    throw Exception('API_BASE_URL is not set in .env file');
  }

  // 4. Bây giờ mới khởi tạo Dio với baseUrl chính xác
  dio = Dio(BaseOptions(baseUrl: apiBaseUrl));

  // 5. Khởi tạo các dịch vụ phụ thuộc
  apiClient = ApiClient(
    dio: dio,
    secureStorage: secureStorage,
    onAuthenticationFailure: _handleAuthenticationFailure,
  );

  authRepository = AuthRepository();

  // 6. Chạy ứng dụng
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
    // authRepository giờ đây đã được khởi tạo và sẵn sàng để sử dụng
    _userFuture = authRepository.checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
