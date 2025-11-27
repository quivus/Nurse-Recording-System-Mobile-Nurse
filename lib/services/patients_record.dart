import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patients_record.dart';

class PatientRecordService {
  static const String baseUrl = 'http://localhost:5022/api/NursePatientRecord';

  // CREATE
  static Future<Map<String, dynamic>> createPatientRecord(PatientRecord record) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create/patient_record'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(record.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {"success": true, "data": PatientRecord.fromJson(data)};
      } else {
        final errorData = jsonDecode(response.body);
        return {"success": false, "error": errorData["message"] ?? "Unknown error"};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  // GET BY ID
  static Future<Map<String, dynamic>> getPatientRecord(int patientRecordId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/view/patient_record/$patientRecordId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {"success": true, "data": PatientRecord.fromJson(data)};
      } else {
        return {"success": false, "error": "Record not found"};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  // GET LIST BY NURSE ID
  static Future<Map<String, dynamic>> getPatientRecordList(int nurseId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/view/patient_record_list?nurseId=$nurseId'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final records = data.map((e) => PatientRecord.fromJson(e)).toList();
        return {"success": true, "data": records};
      } else {
        return {"success": false, "error": "Failed to fetch list"};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }

  // UPDATE
  static Future<Map<String, dynamic>> updatePatientRecord(PatientRecord record) async {
    if (record.patientRecordId == null) {
      return {"success": false, "error": "PatientRecordId is required"};
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/patient_record/${record.patientRecordId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(record.toJson(includeId: true)),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {"success": true, "data": PatientRecord.fromJson(data)};
      } else {
        final errorData = jsonDecode(response.body);
        return {"success": false, "error": errorData["message"] ?? "Unknown error"};
      }
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }
}
