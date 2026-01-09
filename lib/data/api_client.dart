import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'repositories/auth_repository.dart'; // Chỉ cần cho các hằng số keys

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final Function onAuthenticationFailure; // SỬA LỖI: Sử dụng callback thay vì navigatorKey

  ApiClient({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
    required this.onAuthenticationFailure, // SỬA LỖI: Thêm callback vào constructor
  })  : _dio = dio,
        _secureStorage = secureStorage {
    _dio.options.baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onError: _onError,
    ));
  }

  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _secureStorage.read(key: AuthRepository.accessTokenKey);
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  Future<void> _onError(DioError err, ErrorInterceptorHandler handler) async {
    // SỬA LỖI: Điều kiện để tránh vòng lặp vô hạn khi refresh token thất bại
    if (err.response?.statusCode == 401 && err.requestOptions.path != '/refresh') {
      final refreshToken = await _secureStorage.read(key: AuthRepository.refreshTokenKey);

      if (refreshToken == null) {
        await _clearTokensAndNotify();
        return handler.next(err);
      }

      try {
        // Sử dụng một Dio instance riêng để tránh interceptor lặp lại
        final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));
        final response = await refreshDio.post(
          '/refresh',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 && response.data['accessToken'] != null) {
          // Lưu token mới
          await _secureStorage.write(key: AuthRepository.accessTokenKey, value: response.data['accessToken']);
          if (response.data['refreshToken'] != null) {
             await _secureStorage.write(key: AuthRepository.refreshTokenKey, value: response.data['refreshToken']);
          }

          // Thử lại yêu cầu ban đầu với token mới
          err.requestOptions.headers['Authorization'] = 'Bearer ${response.data['accessToken']}';
          final retryResponse = await _dio.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        // Bất kỳ lỗi nào trong quá trình refresh đều dẫn đến đăng xuất
      }

      // Nếu refresh thất bại, xóa token và gọi callback
      await _clearTokensAndNotify();
      return handler.next(err);
    }

    return handler.next(err);
  }

  // Hàm trợ giúp để xóa token và gọi callback
  Future<void> _clearTokensAndNotify() async {
    await _secureStorage.delete(key: AuthRepository.accessTokenKey);
    await _secureStorage.delete(key: AuthRepository.refreshTokenKey);
    onAuthenticationFailure();
  }

  // Các phương thức tiện ích (GET, POST, v.v.)
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}
