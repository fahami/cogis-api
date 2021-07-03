import 'dart:async';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathPro;
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'components/build_location_indicator.dart';
import 'components/build_menu.dart';
import 'components/build_quick_button.dart';
import 'model/scans.dart';
import 'provider/background_scan.dart';
import 'provider/upload_provider.dart';
import 'provider/broadcast_provider.dart';
import 'constants/color.dart';
import 'constants/text.dart';

class LandingScreen extends StatelessWidget {
  int alarmId = 1;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
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
                    BuildPanel()
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
      ),
    );
  }
}

class BuildPanel extends StatefulWidget {
  @override
  _BuildPanelState createState() => _BuildPanelState();
}

class _BuildPanelState extends State<BuildPanel> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.resumed) {
      print('Aplikasi kembali dibuka');
      BroadcastBLE().stateBroadcasting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      padding: EdgeInsets.fromLTRB(45, 0, 45, 0),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<BroadcastBLE>(
            create: (context) => BroadcastBLE(),
          ),
          ChangeNotifierProvider(
            create: (context) => BackgroundScan(),
          )
        ],
        child: Column(
          children: [
            Consumer<BackgroundScan>(
              builder: (context, backgroundScan, _) =>
                  Consumer<BroadcastBLE>(builder: (context, broadcastBLE, _) {
                broadcastBLE.stateBroadcasting();
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => uploadData(),
                          label: Text("Upload"),
                          icon: Icon(Icons.upload),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Hive.box('scansresult').clear(),
                          label: Text("Clear DB"),
                          icon: Icon(Icons.stop),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      value: broadcastBLE.isBroadcasting,
                      onChanged: (value) async {
                        broadcastBLE.isBroadcasting = value;
                        if (value) {
                          await AndroidAlarmManager.oneShot(
                              Duration(seconds: 1), 0, fireAlarm);
                        } else {
                          await AndroidAlarmManager.cancel(0);
                          BeaconBroadcast().stop();
                        }
                      },
                      subtitle: ValueListenableBuilder(
                        valueListenable: Hive.box('scansresult').listenable(),
                        builder: (context, value, child) {
                          return Text(
                              value.length.toString() + ' Data siap diunggah');
                        },
                      ),
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
                    menuMargin: EdgeInsets.only(right: 21 / 2, bottom: 21 / 2),
                    menuNavigate: '/stats'),
                BuildMenu(
                    menuImage: 'assets/icons/hospital.svg',
                    menuName: 'Rumah Sakit',
                    menuMargin: EdgeInsets.only(left: 21 / 2, bottom: 21 / 2),
                    menuNavigate: '/hospital'),
              ],
            ),
            Row(
              children: [
                BuildMenu(
                    menuImage: 'assets/icons/file_medical.svg',
                    menuName: 'Cek Medis',
                    menuMargin: EdgeInsets.only(right: 21 / 2, top: 21 / 2),
                    menuNavigate: '/medical'),
                BuildMenu(
                  menuImage: 'assets/icons/shield-check.svg',
                  menuName: 'Riwayat Kontak',
                  menuMargin: EdgeInsets.only(left: 21 / 2, top: 21 / 2),
                  menuNavigate: '/contact',
                ),
              ],
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
  Hive
    ..init(appDir.path)
    ..registerAdapter(ScansResultAdapter(), override: true);
  Hive.close();
  var hasilScan = await Hive.openBox<ScansResult>('scansresult');

  final master = prefs.getInt('userId').toString();
  BleManager bleManager = BleManager();
  final dateScan = DateTime.now();
  List temporaryList = [];
  try {
    bleManager.createClient();
    bleManager
        .startPeripheralScan(scanMode: ScanMode.lowLatency)
        .listen((scanResult) {
      List parsed = scanResult.advertisementData.manufacturerData;
      if (parsed.length == 26) {
        print(parsed);
        final parsedSlave = Uuid.unparse(parsed.sublist(10, 26));
        final slave = parsedSlave.substring(9, 12);
        temporaryList.add(ScansResult(
          master,
          slave,
          dateScan,
          scanResult.rssi,
        ));
        // print(slave);
      }
    });
    Future.delayed(Duration(seconds: 3)).then((value) {
      try {
        bleManager.stopPeripheralScan();
      } catch (e) {
        print(e);
      }
    }).then((value) {
      temporaryList.forEach((item) {
        print(item.slave);
        hasilScan.add(item);
      });
      // for (var item in temporaryList) {
      //   print(item);
      // }
      // for (var i = 0; i < temporaryList.length; i++) {
      //   if (temporaryList.any((e) => e.slave == temporaryList[i].slave)) {
      //     continue;
      //   }
      //   print(temporaryList[i]);
      //   hasilScan.add(temporaryList[i]);
      // }
    });
  } catch (e) {
    print(e);
  }
}
