import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Hàm callback khi xác thực thất bại
typedef OnAuthenticationFailure = void Function();

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final OnAuthenticationFailure _onAuthenticationFailure;

  ApiClient({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
    required OnAuthenticationFailure onAuthenticationFailure,
  })  : _dio = dio,
        _secureStorage = secureStorage,
        _onAuthenticationFailure = onAuthenticationFailure {
    
    // SỬA LỖI: Thêm Interceptor để tự động đính kèm token vào header
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Đọc token từ storage
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken != null) {
          // Đính kèm token vào header Authorization
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        // Cho phép request được tiếp tục
        return handler.next(options); 
      },
      onError: (DioException e, handler) async {
        // SỬA LỖI: Xử lý khi token hết hạn (lỗi 401)
        if (e.response?.statusCode == 401) {
          // Thử làm mới token
          if (await _refreshToken()) {
            // Nếu làm mới thành công, thử lại yêu cầu ban đầu
            return handler.resolve(await _retry(e.requestOptions));
          }
        }
        // Nếu lỗi không phải 401 hoặc làm mới thất bại, gọi callback để logout
        _onAuthenticationFailure();
        return handler.next(e);
      },
    ));
  }

  // Hàm làm mới token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      // Tạo một Dio instance mới để tránh vòng lặp interceptor vô tận
      final dio = Dio();
      final response = await dio.post(
        '${_dio.options.baseUrl}/auth/refresh', 
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        await _secureStorage.write(key: 'access_token', value: response.data['accessToken']);
        await _secureStorage.write(key: 'refresh_token', value: response.data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Hàm thử lại yêu cầu đã thất bại với token mới
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  // Các phương thức GET, POST, PUT, DELETE
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
