import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:qr_inventory_management/DTO/login_request_dto.dart';
import 'package:qr_inventory_management/DTO/register_request_dto.dart';
import '../services/auth_service.dart';
import '../dto/user_dto.dart';
import '../models/user.dart';
import '../storage/token_storage.dart';
import '../storage/user_storage.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var user = Rxn<User>();   // State
  var isLoggedIn = false.obs;  // Login status

  @override
  void onInit() {
    super.onInit();

    final savedToken = TokenStorage.getToken();
    final savedUserJson = UserStorage.getUser();

    if (savedToken != null && savedUserJson != null) {
      user.value = UserDTO.fromJson(savedUserJson);
      isLoggedIn.value = true;
    }
  }

  // Return true if successful, throw on error
  Future<bool> register(RegisterRequestDTO request) async {
    try {
      await _authService.register(request);
      return true;
    } catch (e) {
      print('Register error: $e');
      rethrow; 
    }
  }

  // Return true if login successful, false if credentials wrong, throw for other errors
  Future<bool> login(LoginRequestDTO request) async {
    try {
      final response = await _authService.login(request);

      final accessToken = response['data']?['accessToken'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Invalid access token');
      }

      await TokenStorage.saveToken(accessToken);
      
      final profileResponse = await _authService.getProfile();
      final userData = profileResponse['data'] as Map<String, dynamic>?;

      if (userData == null) {
        throw Exception('Failed to get user profile');
      }

      await UserStorage.saveUser(userData);

      user.value = UserDTO.fromJson(userData);
      isLoggedIn.value = true;
      return true;

    } on DioException catch (dioError) {
      if (dioError.response?.statusCode == 401) {
        // Unauthorized credentials, return false so UI can show error message
        return false;
      }
      rethrow;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await TokenStorage.clearToken();
    await UserStorage.clearUser();
    user.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed('/auth');
  }
}
