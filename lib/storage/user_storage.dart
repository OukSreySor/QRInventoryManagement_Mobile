import 'package:get_storage/get_storage.dart';

class UserStorage {
  static final _box = GetStorage();
  static const _userKey = 'user';

  static Future<void> saveUser(Map<String, dynamic> userJson) async {
    await _box.write(_userKey, userJson);
  }

  static Map<String, dynamic>? getUser() {
    return _box.read(_userKey);
  }

  static Future<void> clearUser() async {
    await _box.remove(_userKey);
  }
}
