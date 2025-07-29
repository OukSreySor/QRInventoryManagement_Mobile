import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class DioClient {
  static final Dio _dio = Dio(BaseOptions(
    //baseUrl: 'http://localhost:5134/api',
    //baseUrl: 'http://10.0.2.2:5000/api',
    baseUrl: 'http://192.168.110.149:5000/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  static Dio get dio {
    _dio.interceptors.clear(); // clear old ones to avoid duplication

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final box = GetStorage();
          final token = box.read('access_token');
          print('Token: $token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options); // proceed with request
        },
        onError: (DioException error, handler) {
          // Optional: handle token expiration, redirect to login, etc.
          return handler.next(error);
        },
      ),
    );

    return _dio;
  }
}
