import 'package:dio/dio.dart';
import 'package:qr_inventory_management/DTO/login_request_dto.dart';
import 'package:qr_inventory_management/DTO/register_request_dto.dart';
import 'package:qr_inventory_management/services/dio_client.dart';

class AuthService {
  final Dio dio = DioClient.dio;

  Future<Map<String, dynamic>> register(RegisterRequestDTO request) async {
    final response = await dio.post('/Auth/register', data: request.toJson());

    return response.data;
  }

  Future<Map<String, dynamic>> login(LoginRequestDTO request) async {
    final response = await dio.post('/Auth/login', data: request.toJson());

    return response.data;
  }
  Future<Map<String, dynamic>> getProfile() async {
    final response = await DioClient.dio.get('/Auth/profile');
    
    return response.data;
  }
}
