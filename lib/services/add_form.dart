import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/add_form.dart';  // imports AddFormModel

class AddFormService {
  static const String baseUrl = 'http://localhost:5022/api/UserForm';

  // -----------------------------
  // CREATE FORM
  // -----------------------------
  static Future<Map<String, dynamic>> createAddForm(AddFormModel form) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create/user_form'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(form.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {"success": true, "data": data};
    } else {
      return {
        "success": false,
        "error": jsonDecode(response.body)["message"] ?? "Unknown error"
      };
    }
  }

  // -----------------------------
  // UPDATE FORM
  // -----------------------------
  static Future<Map<String, dynamic>> updateAddForm(AddFormModel form) async {
    if (form.formId == null) {
      return {"success": false, "error": "Form ID is required for update"};
    }

    final response = await http.put(
      Uri.parse('$baseUrl/update/user_form'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(form.toJson(forUpdate: true)),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {"success": true, "data": data};
    } else {
      return {
        "success": false,
        "error": jsonDecode(response.body)["message"] ?? "Unknown error"
      };
    }
  }

  // -----------------------------
  // DELETE FORM
  // -----------------------------
  static Future<bool> deleteAddForm(int formId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/delete/user_form/$formId'));

    return response.statusCode == 200;
  }
}
