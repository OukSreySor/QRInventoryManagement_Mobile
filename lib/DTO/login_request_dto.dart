class LoginRequestDTO {
  final String email;
  final String password;

  LoginRequestDTO({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
