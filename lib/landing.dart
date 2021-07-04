import 'dart:async';
import 'dart:convert';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart' as pathPro;
import 'package:http/http.dart' as http;
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
import 'provider/upload_provider.dart';
import 'provider/broadcast_provider.dart';
import 'constants/color.dart';
import 'constants/text.dart';

class LandingScreen extends StatelessWidget {
  final alarmId = 1;
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
            onPressed: () => Get.offNamed('/creator'),
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
        ],
        child: Column(
          children: [
            Consumer<BroadcastBLE>(builder: (context, broadcastBLE, _) {
              broadcastBLE.stateBroadcasting();
              return Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Hive.box('scansresult').clear(),
                    label: Text("Clear DB"),
                    icon: Icon(Icons.stop),
                  ),
                  SwitchListTile(
                    title: Text('Unggah data otomatis'),
                    value: broadcastBLE.isUploading,
                    onChanged: (value) async {
                      broadcastBLE.isUploading = value;
                      value
                          ? await AndroidAlarmManager.periodic(
                              Duration(minutes: 1), 1, fireUpload)
                          : await AndroidAlarmManager.cancel(1);
                    },
                  ),
                  SwitchListTile(
                    value: broadcastBLE.isBroadcasting,
                    onChanged: (value) async {
                      broadcastBLE.isBroadcasting = value;
                      if (value) {
                        await AndroidAlarmManager.periodic(
                            Duration(seconds: 2), 0, fireAlarm);
                      } else {
                        await AndroidAlarmManager.cancel(0);
                        BeaconBroadcast().stop();
                      }
                    },
                    title: Text("Aktifkan tracing"),
                  ),
                ],
              );
            }),
            Row(
              children: [
                BuildMenu(
                    menuImage: 'assets/icons/hospital.svg',
                    menuName: 'Rumah Sakit',
                    menuMargin: EdgeInsets.only(left: 21 / 2, top: 21 / 2),
                    menuNavigate: '/hospital'),
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

  var hasilScan = await Hive.openBox<ScansResult>('scansresult');

  final master = prefs.getInt('userId').toString();
  final threshold = prefs.getInt('threshold');
  BleManager bleManager = BleManager();
  final dateScan = DateTime.now();
  List temporaryList = [];
  try {
    bleManager.createClient();
    bleManager
        .startPeripheralScan(scanMode: ScanMode.lowLatency)
        .listen((scanResult) {
      List parsed = scanResult.advertisementData.manufacturerData;
      int rssi = scanResult.rssi;
      if (parsed.length == 26 && rssi > threshold) {
        final parsedSlave = Uuid.unparse(parsed.sublist(10, 26));
        final slave = parsedSlave.substring(9, 12);
        temporaryList.add(ScansResult(
          master,
          slave,
          dateScan,
          scanResult.rssi,
        ));
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
    });
  } catch (e) {
    print(e);
  }
}

void fireUpload() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt('userId');
  String latitude = prefs.getString('latitude') ?? null;
  String longitude = prefs.getString('longitude') ?? null;
  var appDir = await pathPro.getApplicationDocumentsDirectory();
  Hive
    ..init(appDir.path)
    ..registerAdapter(ScansResultAdapter(), override: true);
  final boxes = await Hive.openBox<ScansResult>('scansresult');
  final uploadUrl = Uri.parse("https://api.karyasa.my.id/scan/$id");

  for (var i = 0; i < boxes.length; i++) {
    final datum = boxes.getAt(i) as ScansResult;
    final bodyReq = jsonEncode({
      "lat": latitude,
      "lng": longitude,
      "rssi": datum.rssi,
      "id_user": id,
      "id_slave": int.parse(datum.slave),
      "scan_date": datum.scanDate.toString()
    });
    final uploadReq = await http.post(
      uploadUrl,
      headers: {
        'Accept': 'application/json',
        'Authorization': prefs.getString('token'),
        'Content-Type': 'application/json'
      },
      body: bodyReq,
    );
    if (uploadReq.statusCode == 200) {
      print('berhasil upload data ${datum.slave} di ${DateTime.now()}');
      boxes.deleteAt(i);
    } else {
      print('Unggah data ${datum.slave} gagal di ${DateTime.now()}');
    }
  }
}
