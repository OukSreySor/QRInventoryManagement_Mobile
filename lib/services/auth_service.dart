import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_inventory_management/DTO/login_request_dto.dart';
import 'package:qr_inventory_management/DTO/register_request_dto.dart';
import 'package:qr_inventory_management/services/dio_client.dart';

import '../storage/token_storage.dart';

class AuthService {
  final Dio dio = DioClient.dio;

  Future<Map<String, dynamic>> register(RegisterRequestDTO request) async {
    final response = await dio.post('/Auth/register', data: request.toJson());

    return response.data;
  }

  Future<Map<String, dynamic>> login(LoginRequestDTO request) async {
    final response = await dio.post('/Auth/login', data: request.toJson());
    final data = response.data['data'];

    final box = GetStorage();
    box.write('access_token', data['accessToken']);
    box.write('refresh_token', data['refreshToken']);

    return data;
  }
  Future<Map<String, dynamic>> getProfile() async {
    final response = await DioClient.dio.get('/Auth/profile');
    
    return response.data;
  }

  Future<Map<String, dynamic>> refreshToken() async {
    final storedRefreshToken = TokenStorage.getRefreshToken();
    if (storedRefreshToken == null) throw Exception("No refresh token available");

    final response = await dio.post('/auth/refresh-token', data: {
      "refreshToken": storedRefreshToken,
    });

    final data = response.data['data'];
    await TokenStorage.saveAccessToken(data['accessToken']);
    await TokenStorage.saveRefreshToken(data['refreshToken']);

    return data;
  }

}
