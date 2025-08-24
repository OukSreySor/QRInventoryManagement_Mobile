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
  var user = Rxn<User>();      // Current user state
  var isLoggedIn = false.obs;  // Login status
  var isLoading = false.obs;   // Login indicatior

  @override
  void onInit() {
    super.onInit();

    final savedAccessToken = TokenStorage.getAccessToken();
    final savedRefreshToken = TokenStorage.getRefreshToken();
    final savedUserJson = UserStorage.getUser();

    if (savedAccessToken != null && 
        savedAccessToken.isNotEmpty &&
        savedRefreshToken != null &&
        savedUserJson != null) {
      user.value = UserDTO.fromJson(savedUserJson);
      isLoggedIn.value = true;
    }
  }

  // Register a new user
  Future<bool> register(RegisterRequestDTO request) async {
    try {
      isLoading.value = true;
      await _authService.register(request);
      return true;
    } catch (e) {
      print('Register error: $e');
      rethrow; 
    } finally {
      isLoading.value = false; 
    }
  }

  // Return true if login successful, false if credentials wrong, throw for other errors
  // Future<bool> login(LoginRequestDTO request) async {
  //   try {
  //     isLoading.value = true;
  //     final response = await _authService.login(request);

  //     final accessToken = response['data']?['accessToken'] as String?;
  //     final refreshToken = response['data']?['refreshToken'] as String?;
    
  //     if (accessToken == null || refreshToken == null) {
  //       throw Exception('Invalid token received');
  //     }

  //     await TokenStorage.saveAccessToken(accessToken);
  //     await TokenStorage.saveRefreshToken(refreshToken);
      
  //     final profileResponse = await _authService.getProfile();
  //     final userData = profileResponse['data'] as Map<String, dynamic>?;

  //     if (userData == null) {
  //       throw Exception('Failed to get user profile');
  //     }

  //     await UserStorage.saveUser(userData);

  //     user.value = UserDTO.fromJson(userData);
  //     isLoggedIn.value = true;
  //     return true;

  //   } on DioException catch (dioError) {
  //     if (dioError.response?.statusCode == 401) {
  //       // Unauthorized credentials, return false so UI can show error message
  //       return false;
  //     }
  //     rethrow;
  //   } finally {
  //     isLoading.value = false; 
  //   }
  // }

  Future<bool> login(LoginRequestDTO request) async {
  try {
    isLoading.value = true;
    
    // Call login service
    final response = await _authService.login(request); 
    print('Login response: $response'); // DEBUG

    // Extract tokens
    final accessToken = response['accessToken'] as String?;
    final refreshToken = response['refreshToken'] as String?;

    print('AccessToken: $accessToken');
    print('RefreshToken: $refreshToken');

    if (accessToken == null || refreshToken == null) {
      throw Exception('Invalid token received');
    }

    // Save tokens BEFORE fetching profile
    await TokenStorage.saveAccessToken(accessToken);
    await TokenStorage.saveRefreshToken(refreshToken);

    // Fetch profile
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
    if (dioError.response?.statusCode == 401) return false;
    rethrow;
  } finally {
    isLoading.value = false;
  }
}


  Future<Map<String, dynamic>> refreshToken() async {
    final data = await _authService.refreshToken();
    return data;
  }

  Future<void> logout() async {
    await TokenStorage.clearAccessToken();
    await TokenStorage.clearRefreshToken();
    await UserStorage.clearUser();

    user.value = null;
    isLoggedIn.value = false;
    
    Get.offAllNamed('/auth');
  }
}
