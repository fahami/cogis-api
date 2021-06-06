import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gis_apps/contact.dart';
import 'package:gis_apps/hospital.dart';
import 'package:gis_apps/landing.dart';
import 'package:gis_apps/login.dart';
import 'package:gis_apps/medical_report.dart';
import 'package:gis_apps/model/hospitals.dart';
import 'package:gis_apps/model/scans.dart';
import 'package:gis_apps/model/user.dart';
import 'package:gis_apps/provider/auth_provider.dart';
import 'package:gis_apps/register.dart';
import 'package:gis_apps/statistics.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathPro;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDir = await pathPro.getApplicationDocumentsDirectory();
  Hive
    ..init(appDir.path)
    ..registerAdapter(HospitalsAdapter())
    ..registerAdapter(ScansResultAdapter())
    ..registerAdapter(UserAdapter());
  await AndroidAlarmManager.initialize();
  runApp(ChangeNotifierProvider(
    create: (_) => AuthSystem(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoGIS',
      home: FutureBuilder(
        future: Hive.openBox('scansresult'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return LoginScreen();
            }
          } else {
            return Scaffold();
          }
        },
      ),
      unknownRoute: GetPage(name: '/notfound', page: () => LandingScreen()),
      initialRoute: '/',
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
