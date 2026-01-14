import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Hàm callback khi xác thực thất bại
typedef OnAuthenticationFailure = void Function();

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final OnAuthenticationFailure _onAuthenticationFailure;

  // DANH SÁCH CÁC ĐƯỜNG DẪN CÔNG KHAI
  static const _publicPaths = [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
    '/auth/forgot-password',
    '/auth/reset-password'
  ];

  ApiClient({
    required Dio dio,
    required FlutterSecureStorage secureStorage,
    required OnAuthenticationFailure onAuthenticationFailure,
  })  : _dio = dio,
        _secureStorage = secureStorage,
        _onAuthenticationFailure = onAuthenticationFailure {
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // CHỈ THÊM TOKEN CHO CÁC ĐƯỜNG DẪN ĐƯỢC BẢO VỆ
        if (!_publicPaths.contains(options.path)) {
          final accessToken = await _secureStorage.read(key: 'access_token');
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // CHỈ LÀM MỚI TOKEN KHI LỖI 401 TRÊN ĐƯỜNG DẪN ĐƯỢC BẢO VỆ
        if (e.response?.statusCode == 401 && !_publicPaths.contains(e.requestOptions.path)) {
          // Thử làm mới token
          if (await _refreshToken()) {
            // Nếu thành công, thử lại yêu cầu ban đầu
            return handler.resolve(await _retry(e.requestOptions));
          } else {
            // Nếu làm mới thất bại, mới thực hiện logout
            _onAuthenticationFailure();
          }
        }
        // Đối với tất cả các lỗi khác, chỉ cần chuyển tiếp lỗi
        // để khối try/catch trong Repository có thể xử lý.
        return handler.next(e);
      },
    ));
  }

  // Hàm làm mới token (không thay đổi)
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      final dio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));
      final response = await dio.post(
        '/auth/refresh',
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

  // Hàm thử lại yêu cầu (không thay đổi)
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final newAccessToken = await _secureStorage.read(key: 'access_token');
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newAccessToken', // Sử dụng token mới
      },
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  // Các phương thức GET, POST, PUT, DELETE (không thay đổi)
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
