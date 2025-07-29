import '../models/user.dart';

class UserDTO {
  static User fromJson(Map<String, dynamic> json) {
    return User( 
      id: json['id'],
      username: json['username'],
      email: json['email'],
      passwordHash: json['passwordHash'] as String?,
      role: json['role'],
      refreshToken: json['refreshToken'] as String?,
      refreshTokenExpiryTime: json['refreshTokenExpiryTime'] != null
          ? DateTime.parse(json['refreshTokenExpiryTime'])
          : null,
      isDeleted: json['isDeleted'] ?? false
    );
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      'id': user.id,
      'username': user.username,
      'passwordHash': user.passwordHash,
      'role': user.role,
      'refreshToken': user.refreshToken,
      'refreshTokenExpiryTime': user.refreshTokenExpiryTime,
      'email': user.email,
      'isDeleted': user.isDeleted
    };
  }
}

