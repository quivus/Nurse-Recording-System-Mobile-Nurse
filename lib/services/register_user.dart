import 'dart:convert';
import 'package:flutter_temp/models/register.dart';
import 'package:http/http.dart' as http;

Future<void> registerNurse(register nurse) async {
  // Use 10.0.2.2 for Android emulator; replace with your PC IP for real device
  var url = Uri.parse('http://localhost:5022/api/admin/nurse/register');

  try {
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nurse.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Registration successful!');
      print(response.body);
    } else {
      print('Failed to register. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


//  var newNurse = Nurse(
//     userName: 'ayumi',
//     password: '12345678',
//     email: 'user@example.com',
//     firstName: 'string',
//     middleName: 'strin',
//     lastName: 'password12345',
//     contactNumber: '09233445873',
//   );

//   registerNurse(newNurse);