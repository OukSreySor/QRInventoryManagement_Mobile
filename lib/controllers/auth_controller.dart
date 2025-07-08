import 'package:get/get.dart';
import 'package:qr_inventory_management/DTO/login_request_dto.dart';
import 'package:qr_inventory_management/DTO/register_request_dto.dart';
import '../services/auth_service.dart';
import '../dto/user_dto.dart';
import '../models/user.dart';
import '../storage/token_storage.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var user = Rxn<User>();   // State
  var isLoggedIn = false.obs;  // Loggin status

  Future<void> register(RegisterRequestDTO request) async {
    try {
      final response = await _authService.register(request);
      user.value = UserDTO.fromJson(response['user']);  // Update user state from API
      await TokenStorage.saveToken(response['accessToken']);
      isLoggedIn.value = true;
      Get.offAllNamed('/dashboard');
    } catch (e) {
      Get.snackbar('Register Failed', e.toString());
      print('Register error: $e'); 
    }
  }

  Future<void> login(LoginRequestDTO request) async {
    try {
      final response = await _authService.login(request);
      final data = response['data'] as Map<String, dynamic>;
      final accessToken = data['accessToken'];

      await TokenStorage.saveToken(accessToken);

      // Fetch user profile after login
      final profileResponse = await _authService.getProfile();
      print('Profile response: $profileResponse');
      final userData = profileResponse['data'] as Map<String, dynamic>;
      user.value = UserDTO.fromJson(userData);

      isLoggedIn.value = true;
      Get.offAllNamed('/dashboard');
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
      print('Login error: $e'); 
  }
  }

  void logout() async {
    await TokenStorage.clearToken();
    user.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed('/auth');
  }
}
