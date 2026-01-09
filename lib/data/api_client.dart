import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'repositories/auth_repository.dart'; // Import để truy cập AuthRepository

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiClient({required Dio dio, required FlutterSecureStorage secureStorage}) 
      : _dio = dio,
        _secureStorage = secureStorage {
    _dio.options.baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onError: _onError,
    ));
  }

  // Thêm accessToken vào header
  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _secureStorage.read(key: AuthRepository.accessTokenKey);
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  // Xử lý lỗi và tự động làm mới token
  Future<void> _onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Nếu lỗi là 401, thử làm mới token
      final authRepository = AuthRepository(); // Tạo một instance cục bộ
      final bool didRefreshToken = await authRepository.refreshToken();

      if (didRefreshToken) {
        // Nếu làm mới thành công, thử lại yêu cầu ban đầu
        final newAccessToken = await _secureStorage.read(key: AuthRepository.accessTokenKey);
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        
        try {
          // Thử lại yêu cầu với token mới
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          // Nếu thử lại vẫn thất bại, trả về lỗi
          return handler.next(err);
        }
      } else {
        // Nếu không thể làm mới token, đăng xuất người dùng
        await authRepository.logout();
        // Có thể điều hướng người dùng về màn hình đăng nhập ở đây
      }
    }
    return handler.next(err);
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
