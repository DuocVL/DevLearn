import 'package:devlearn/app.dart'; // SỬA: Import DevLearnApp
import 'package:devlearn/data/api_client.dart';
import 'package:devlearn/data/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Khai báo các dịch vụ
late final Dio dio;
late final ApiClient apiClient;
late final AuthRepository authRepository;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final secureStorage = const FlutterSecureStorage();

// Callback để xử lý lỗi xác thực và logout
void _handleAuthenticationFailure() {
  // Xóa token cũ
  authRepository.logout();
  // Điều hướng về màn hình login
  navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final apiBaseUrl = dotenv.env['API_BASE_URL'];
  if (apiBaseUrl == null || apiBaseUrl.isEmpty) {
    throw Exception('API_BASE_URL is not set in .env file');
  }

  dio = Dio(BaseOptions(baseUrl: apiBaseUrl));
  apiClient = ApiClient(
    dio: dio,
    secureStorage: secureStorage,
    onAuthenticationFailure: _handleAuthenticationFailure,
  );
  authRepository = AuthRepository();

  // SỬA: Chạy DevLearnApp thay vì MyApp
  runApp(const DevLearnApp());
}

// XÓA: Lớp MyApp không còn cần thiết nữa
