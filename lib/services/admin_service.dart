import '../DTO/user_dto.dart';
import '../models/invite_code.dart';
import '../models/user.dart';
import 'dio_client.dart';

class AdminService {
  Future<List<User>> getAllUsers() async {
    final res = await DioClient.dio.get('/Admin/users');
    return (res.data['data'] as List)
        .map((json) => UserDTO.fromJson(json))
        .toList();
  }

  Future<List<InviteCode>> getAllInviteCodes() async {
    final res = await DioClient.dio.get('/Admin/invite-codes');
    return (res.data['data'] as List)
        .map((json) => InviteCode.fromJson(json))
        .toList();
  }

  Future<String> generateInviteCode() async {
    final res = await DioClient.dio.post('/Admin/generate-invite-code');
    return res.data['data'];
  }

  Future<Map<String, int>> getUserStats() async {
    final res = await DioClient.dio.get('/Admin/user-stats');
    return Map<String, int>.from(res.data['data']);
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    try {
      final response = await DioClient.dio.put(
        '/Admin/users/$userId',
        data: {
          'userId': userId,
          'NewRole': newRole
          },
      );
      print(response.data);
    } catch (e) {
      print('Error updating role: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response = await DioClient.dio.delete('/Admin/users/$userId');
      print(response.data);
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  }


