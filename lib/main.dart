import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const ClinicApp(),
    ),
  );
}

class ClinicApp extends StatelessWidget {
  const ClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      initialRoute: AppRoutes.welcome,
      routes: AppRoutes.getRoutes(nurseId: 0), // default until login
    );
  }
}
