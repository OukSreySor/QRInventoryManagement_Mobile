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
    required this.passwordHash,
    required this.role,
    this.refreshToken,
    this.refreshTokenExpiryTime,
    required this.isDeleted
  });

  // factory User.fromJson(Map<String, dynamic> json) => User(
  //       id: json['id'],
  //       username: json['username'],
  //       passwordHash: json['passwordHash'],
  //       role: json['role'],
  //       refreshToken: json['refreshToken'],
  //       refreshTokenExpiryTime: json['refreshTokenExpiryTime'] != null
  //           ? DateTime.parse(json['refreshTokenExpiryTime'])
  //           : null,
  //     );

  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'username': username,
  //       'passwordHash': passwordHash,
  //       'role': role,
  //       'refreshToken': refreshToken,
  //       'refreshTokenExpiryTime': refreshTokenExpiryTime?.toIso8601String(),
  //     };
}
