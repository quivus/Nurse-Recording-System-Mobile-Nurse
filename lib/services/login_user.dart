import 'dart:convert';
import 'package:flutter_temp/models/login.dart';
import 'package:http/http.dart' as http;

Future<http.Response> loginNurse(Login nurse) async {
  var url = Uri.parse('http://localhost:5022/api/Auth/login');

  try {
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(nurse.toJson()),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    return response; // Return response to caller for UI handling
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to login: $e');
  }
}
