class User {
  String id;
  String username;
  String email;
  String? passwordHash;
  String role;
  String? refreshToken;
  DateTime? refreshTokenExpiryTime;
  bool isDeleted;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.passwordHash,
    required this.role,
    this.refreshToken,
    this.refreshTokenExpiryTime,
    required this.isDeleted
  });
}
