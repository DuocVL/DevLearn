import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiClient({required Dio dio, required FlutterSecureStorage secureStorage})
      : _dio = dio,
        _secureStorage = secureStorage {
    _dio.options.baseUrl = dotenv.env['BASE_URL'] ?? '';
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Lấy token từ bộ nhớ an toàn
          final token = await _secureStorage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options); // Tiếp tục yêu cầu
        },
        onError: (DioException e, handler) {
          // Xử lý các lỗi chung ở đây nếu cần
          return handler.next(e); // Chuyển tiếp lỗi
        },
      ),
    );
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) async {
    return _dio.post<T>(path, data: data);
  }

  // Thêm các phương thức khác (put, delete, v.v.) khi cần
}
