class Login {
  final String password;
  final String email;

  Login({
    required this.password,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'email': email
    };
  }
}
