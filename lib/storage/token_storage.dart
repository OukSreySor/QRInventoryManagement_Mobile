import 'package:get_storage/get_storage.dart';

class TokenStorage {
  static final _box = GetStorage();
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  static Future<void> saveAccessToken(String accessToken) async {
    await _box.write(_accessTokenKey, accessToken);
  }

  static String? getAccessToken() {
    return _box.read(_accessTokenKey);
  }

  static Future<void> clearAccessToken() async {
    await _box.remove(_accessTokenKey);
  }

  static Future<void> saveRefreshToken(String refreshToken) async{
    await _box.write(_refreshTokenKey, refreshToken);
  }

  static String? getRefreshToken() {
    return _box.read(_refreshTokenKey);
  }

  static Future<void> clearRefreshToken() async {
    await _box.remove(_refreshTokenKey);
  }
}
