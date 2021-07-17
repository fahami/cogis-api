import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:android_power_manager/android_power_manager.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as pathPro;
import 'package:cogis/provider/auth_provider.dart';
import 'package:cogis/medical_report.dart';
import 'package:cogis/model/hospitals.dart';
import 'package:cogis/model/scans.dart';
import 'package:cogis/model/user.dart';
import 'package:cogis/register.dart';
import 'package:cogis/statistics.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cogis/contact.dart';
import 'package:cogis/creator.dart';
import 'package:cogis/hospital.dart';
import 'package:cogis/landing.dart';
import 'package:cogis/login.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  final appDir = await pathPro.getApplicationDocumentsDirectory();
  Hive
    ..init(appDir.path)
    ..registerAdapter(HospitalsAdapter())
    ..registerAdapter(ScansResultAdapter())
    ..registerAdapter(UserAdapter());
  await Hive.openBox('hospitals');
  await Hive.openBox('scansresult');
  await AndroidAlarmManager.initialize();
  runApp(ChangeNotifierProvider(
    create: (_) => AuthSystem(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

void init() async {
  var status = await Permission.ignoreBatteryOptimizations.status;
  print("status batt optim: $status");
  if (status.isGranted) {
    print(
        "ignoring: ${(await AndroidPowerManager.isIgnoringBatteryOptimizations)}");
    if (!(await AndroidPowerManager.isIgnoringBatteryOptimizations)) {
      AndroidPowerManager.requestIgnoreBatteryOptimizations();
    }
  } else {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.ignoreBatteryOptimizations,
    ].request();
    print(
        "permission value: ${statuses[Permission.ignoreBatteryOptimizations]}");
    if (statuses[Permission.ignoreBatteryOptimizations].isGranted) {
      AndroidPowerManager.requestIgnoreBatteryOptimizations();
    } else {
      SystemNavigator.pop();
    }
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    init();
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
      getPages: [
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/hospital', page: () => Hospital()),
        GetPage(name: '/medical', page: () => MedicalReport()),
        GetPage(name: '/contact', page: () => ContactTrace()),
        GetPage(name: '/stats', page: () => Statistic()),
        GetPage(name: '/home', page: () => LandingScreen()),
        GetPage(name: '/creator', page: () => CreatorPage()),
      ],
    );
  }
}
