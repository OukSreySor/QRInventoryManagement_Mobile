import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_inventory_management/controllers/auth_controller.dart';

class DioClient {
  static final Dio _dio = Dio(BaseOptions(
    //baseUrl: 'http://localhost:5134/api',
    //baseUrl: 'http://10.0.2.2:5000/api',
    baseUrl: 'http://192.168.18.10:5000/api',
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
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options); // proceed with request
        },
        onError: (DioException error, handler) async {
          // Handle token expiration
          if (error.response?.statusCode == 401) {
            try {
              final authController = Get.find<AuthController>();

              // Attempt to refresh token
              final newTokens = await authController.refreshToken();

              // Retry original request with new access token
              final retryOptions = Options(
                method: error.requestOptions.method,
                headers: {
                  ...error.requestOptions.headers,
                  'Authorization': 'Bearer ${newTokens['accessToken']}',
                },
              );

              final cloneReq = await _dio.request(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: retryOptions,
              );

              return handler.resolve(cloneReq);
            } catch (_) {
              // Refresh failed -> logout
              await Get.find<AuthController>().logout();
            }
          } 
          return handler.next(error);
        },
      ),
    );

    return _dio;
  }
}
