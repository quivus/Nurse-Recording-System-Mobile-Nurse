import 'package:flutter/material.dart';
import 'package:flutter_temp/screens/patients_record.dart';
import 'package:flutter_temp/screens/user_info.dart';
import '../screens/home.dart';
import '../landing/signin.dart';
import '../landing/welcome.dart';
import '../screens/appointments.dart';
import '../screens/add_form.dart';
import '../screens/medicalinventory.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String appointments = '/appointments';
  static const String patientRecords = '/patientsrecords';
  static const String medicalInventory = '/medicalinventory';
  static const String addForm = '/addform';
  static const String signIn = '/signin';
  static const String userInfo = '/userinfo';

  static Map<String, WidgetBuilder> getRoutes({required int nurseId}) {
  return {
'/signin': (context) => const SignIn(),
      '/home': (context) => Home(nurseId: nurseId),
          welcome: (context) => const Welcome(),
    appointments: (context) => const Appointments(),
    patientRecords: (context) => PatientsRecord(nurseId: nurseId),
    medicalInventory: (context) => const MedicalInventory(),
    userInfo: (context) => const UserInfo(),
    addForm: (context) => const AddFormScreen(),
  };
  }
}
