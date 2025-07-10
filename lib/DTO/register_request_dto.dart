class RegisterRequestDTO {
  final String username;
  final String email;
  final String password;
  final String inviteCode;

  RegisterRequestDTO({
    required this.username,
    required this.email,
    required this.password,
    required this.inviteCode
  });

  Map<String, dynamic> toJson() {
    return {
      'userDto': {
        'username': username,
        'email': email,
        'password': password,
      },
      'inviteCode': inviteCode
    };
  }
}
