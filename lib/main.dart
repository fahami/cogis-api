import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gis_apps/contact.dart';
import 'package:gis_apps/hospital.dart';
import 'package:gis_apps/landing.dart';
import 'package:gis_apps/login.dart';
import 'package:gis_apps/medical_report.dart';
import 'package:gis_apps/register.dart';
import 'package:gis_apps/statistics.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoGIS',
      home: LoginScreen(),
      unknownRoute: GetPage(name: '/notfound', page: () => LandingScreen()),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/hospital', page: () => Hospital()),
        GetPage(name: '/medical', page: () => MedicalReport()),
        GetPage(name: '/contact', page: () => ContactTrace()),
        GetPage(name: '/stats', page: () => Statistic()),
        GetPage(name: '/home', page: () => LandingScreen()),
      ],
    );
  }
}
