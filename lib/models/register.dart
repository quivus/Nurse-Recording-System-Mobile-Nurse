class Register {
  final String userName;
  final String password;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String contactNumber;

  Register({
    required this.userName,
    required this.password,
    required this.email,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.contactNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
      'email': email,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'contactNumber': contactNumber,
    };
  }
}
