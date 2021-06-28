import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:path_provider/path_provider.dart' as pathPro;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart' as fBle;
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:gis_apps/model/scans.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'components/build_location_indicator.dart';
import 'components/build_menu.dart';
import 'components/build_quick_button.dart';
import 'provider/background_scan.dart';
import 'provider/broadcast_provider.dart';
import 'constants/color.dart';
import 'constants/text.dart';
import 'provider/upload_provider.dart';

class LandingScreen extends StatelessWidget {
  int alarmId = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: aBackgroundColor,
      appBar: AppBar(
        backgroundColor: aBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.info, color: aTextColor),
          onPressed: () {
            Get.offNamed('/hospital');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: aTextColor),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Hive.box('scansresult').clear();
              Get.offNamed('/login');
            },
          ),
        ],
        title: Center(child: GPSLocation()),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(45, 20, 45, 20),
                    child: FadeInUp(
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Flexible(
                                flex: 8,
                                child: Image.asset(
                                  'assets/images/landing.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              top: 143,
                              child: Text(
                                'Selamat datang!',
                                style: aHeadingStyle,
                              )),
                          Positioned(
                            top: 167,
                            child: Text('Tetap lindungi diri..',
                                style: aSubtitleStyle),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    padding: EdgeInsets.fromLTRB(45, 0, 45, 0),
                    child: MultiProvider(
                      providers: [
                        ChangeNotifierProvider<BroadcastBLE>(
                            create: (context) => BroadcastBLE()),
                        ChangeNotifierProvider<BackgroundScan>(
                            create: (context) => BackgroundScan()),
                      ],
                      child: Column(
                        children: [
                          Consumer<BackgroundScan>(
                            builder: (context, backgroundScan, _) =>
                                Consumer<BroadcastBLE>(
                                    builder: (context, broadcastBLE, _) {
                              broadcastBLE.stateBroadcasting();
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          uploadData();
                                        },
                                        label: Text("Upload"),
                                        icon: Icon(Icons.upload),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          fBle.BleManager().destroyClient();
                                        },
                                        label: Text("Stop BLE"),
                                        icon: Icon(Icons.stop),
                                      ),
                                    ],
                                  ),
                                  SwitchListTile(
                                    value: broadcastBLE.isBroadcasting,
                                    onChanged: (value) async {
                                      broadcastBLE.isBroadcasting = value;
                                      value
                                          ? await AndroidAlarmManager.oneShot(
                                              Duration(seconds: 2),
                                              0,
                                              fireAlarm)
                                          : await AndroidAlarmManager.cancel(0);
                                    },
                                    subtitle: Text('Lindungi diri'),
                                    title: Text("Aktifkan tracing"),
                                  ),
                                ],
                              );
                            }),
                          ),
                          Row(
                            children: [
                              BuildMenu(
                                  menuImage: 'assets/icons/chart-line.svg',
                                  menuName: 'Statistik',
                                  menuMargin: EdgeInsets.only(
                                      right: 21 / 2, bottom: 21 / 2),
                                  menuNavigate: '/stats'),
                              BuildMenu(
                                  menuImage: 'assets/icons/hospital.svg',
                                  menuName: 'Rumah Sakit',
                                  menuMargin: EdgeInsets.only(
                                      left: 21 / 2, bottom: 21 / 2),
                                  menuNavigate: '/hospital'),
                            ],
                          ),
                          Row(
                            children: [
                              BuildMenu(
                                  menuImage: 'assets/icons/file_medical.svg',
                                  menuName: 'Cek Medis',
                                  menuMargin: EdgeInsets.only(
                                      right: 21 / 2, top: 21 / 2),
                                  menuNavigate: '/medical'),
                              BuildMenu(
                                menuImage: 'assets/icons/shield-check.svg',
                                menuName: 'Riwayat Kontak',
                                menuMargin:
                                    EdgeInsets.only(left: 21 / 2, top: 21 / 2),
                                menuNavigate: '/contact',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: QuickButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void fireAlarm() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var appDir = await pathPro.getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  await Hive.openBox('scansresult');
  final hasilScan = Hive.box("scansresult");
  String uuidBroadcast = prefs.getString('uuid1');

  fBle.BleManager bleManager = fBle.BleManager();
  await bleManager.createClient();

  try {
    print("Fired at ${DateTime.now()}");
    bleManager
        .startPeripheralScan(
      scanMode: fBle.ScanMode.lowLatency,
    )
        .listen((scanResult) {
      List parsed = scanResult.advertisementData.manufacturerData;
      print('Data mentah: ' + parsed.toString());
      var parsedList =
          parsed.length == 29 ? parsed.toList().sublist(8) : parsed.toList();
      if (parsed.length == 26) {
        final parsedSlave = Uuid.unparse(parsed.sublist(10, 26));
        print(parsedSlave);
        hasilScan.add(ScansResult(
            uuidBroadcast, parsedSlave, DateTime.now(), scanResult.rssi));
      }
      // Future.delayed(Duration(seconds: 2))
      //     .then((value) => bleManager.stopPeripheralScan());
      bleManager.stopPeripheralScan();
    });
  } catch (e) {
    print(e);
  }
}
