// import 'package:get/get.dart';
// import 'package:qr_inventory_management/DTO/login_request_dto.dart';
// import 'package:qr_inventory_management/DTO/register_request_dto.dart';
// import '../services/auth_service.dart';
// import '../dto/user_dto.dart';
// import '../models/user.dart';
// import '../storage/token_storage.dart';

// class AuthController extends GetxController {
//   final AuthService _authService = AuthService();
//   var user = Rxn<User>();   // State
//   var isLoggedIn = false.obs;  // Loggin status

//   Future<void> register(RegisterRequestDTO request) async {
//     try {
//       await _authService.register(request);
      
//     } catch (e) {
//       Get.snackbar('Register Failed', e.toString());
//       print('Register error: $e'); 
//     }

//   }

//   Future<void> login(LoginRequestDTO request) async {
//     try {
//       final response = await _authService.login(request);
//       final data = response['data'] as Map<String, dynamic>;
//       final accessToken = data['accessToken'];

//       await TokenStorage.saveToken(accessToken);

//       // Fetch user profile after login
//       final profileResponse = await _authService.getProfile();
//       print('Profile response: $profileResponse');
//       final userData = profileResponse['data'] as Map<String, dynamic>;
//       user.value = UserDTO.fromJson(userData);

//       isLoggedIn.value = true;
//       Get.offAllNamed('/dashboard');
//     } catch (e) {
//       Get.snackbar('Login Failed', e.toString());
//       print('Login error: $e'); 
//   }
//   }

//   void logout() async {
//     print('Logout tapped');
//     await TokenStorage.clearToken();
//     user.value = null;
//     isLoggedIn.value = false;
//     Get.offAllNamed('/auth');
//   }
// }

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:qr_inventory_management/DTO/login_request_dto.dart';
import 'package:qr_inventory_management/DTO/register_request_dto.dart';
import '../services/auth_service.dart';
import '../dto/user_dto.dart';
import '../models/user.dart';
import '../storage/token_storage.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var user = Rxn<User>();   // State
  var isLoggedIn = false.obs;  // Login status

  // Return true if successful, throw on error
  Future<bool> register(RegisterRequestDTO request) async {
    try {
      await _authService.register(request);
      return true;
    } catch (e) {
      print('Register error: $e');
      rethrow; // Throw so UI can handle it
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
    print('Logout tapped');
    await TokenStorage.clearToken();
    user.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed('/auth');
  }
}
