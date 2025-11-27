import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/appointment.dart';

class AppointmentService {
  static const String baseUrl = 'http://localhost:5022/api/NurseAppointmentSchedule';

  // Get all appointments
  static Future<List<Appointment>> getAppointments() async {
    final response = await http.get(Uri.parse('$baseUrl/view_appointment_list'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Appointment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  // Get single appointment by ID
  static Future<Appointment> getAppointmentById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/view_appointment/$id'));
    if (response.statusCode == 200) {
      return Appointment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load appointment');
    }
  }

  // Create appointment
  static Future<Map<String, dynamic>> createAppointment(Appointment appointment) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_appointment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(appointment.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {"success": true, "data": data};
    } else {
      final errorData = jsonDecode(response.body);
      return {"success": false, "error": errorData["message"] ?? "Unknown error"};
    }
  }

  // Update appointment
  static Future<Map<String, dynamic>> updateAppointment(int id, Appointment appointment) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update_appointment/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(appointment.toJson(forUpdate: true)),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {"success": true, "data": data};
    } else {
      final errorData = jsonDecode(response.body);
      return {"success": false, "error": errorData["message"] ?? "Unknown error"};
    }
  }

  // Delete appointment
  static Future<bool> deleteAppointment(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete_appointment/$id'));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
