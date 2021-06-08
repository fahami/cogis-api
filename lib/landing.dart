import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:gis_apps/model/scans.dart';
import 'package:gis_apps/provider/background_scan.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'components/build_location_indicator.dart';
import 'components/build_quick_button.dart';
import 'components/build_menu.dart';
import 'provider/broadcast_provider.dart';
import 'provider/scan_provider.dart';
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
        actions: [
          IconButton(
              icon: Icon(Icons.logout, color: aTextColor),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Hive.box('scansresult').clear();
                Get.offNamed('/login');
              })
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
                          Positioned(top: 143, child: HaloHero()),
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
                        ChangeNotifierProvider<ScanBLE>(
                            create: (context) => ScanBLE()),
                        ChangeNotifierProvider<BackgroundScan>(
                            create: (context) => BackgroundScan()),
                      ],
                      child: Column(
                        children: [
                          Consumer<BackgroundScan>(
                            builder: (context, backgroundScan, _) =>
                                Consumer<ScanBLE>(
                              builder: (context, scanBLE, _) =>
                                  Consumer<BroadcastBLE>(
                                      builder: (context, broadcastBLE, _) {
                                scanBLE.setupUuid();
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
                                        Switch(
                                          value: backgroundScan
                                              .isBroadcastBackground,
                                          onChanged: (value) async {
                                            backgroundScan
                                                .isBroadcastBackground = value;
                                            print(
                                                "aktifkan background pada ${DateTime.now()}");
                                            value
                                                ? await AndroidAlarmManager
                                                    .oneShot(
                                                        Duration(seconds: 3),
                                                        0,
                                                        fireAlarm)
                                                : await AndroidAlarmManager
                                                    .cancel(0);
                                          },
                                        ),
                                      ],
                                    ),
                                    FutureBuilder(
                                      future: broadcastBLE.setupUuid(),
                                      builder: (context, snapshot) {
                                        return SwitchListTile(
                                          value: broadcastBLE.isBroadcasting,
                                          onChanged: (value) {
                                            broadcastBLE.isBroadcasting = value;
                                            scanBLE.isScanning = value;
                                          },
                                          subtitle: Text(snapshot.data),
                                          title: Text("Aktifkan tracing"),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }),
                            ),
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

class HaloHero extends StatefulWidget {
  @override
  _HaloHeroState createState() => _HaloHeroState();
}

class _HaloHeroState extends State<HaloHero> {
  Future<String> initializePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializePref(),
      builder: (context, snapshot) {
        return Text(
          'Halo ${snapshot.data ?? "User"}!',
          style: aHeadingStyle,
        );
      },
    );
  }
}

void fireAlarm() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  FlutterBlue flutterBlue = FlutterBlue.instance;
  flutterBlue.startScan(
    scanMode: ScanMode.balanced,
    allowDuplicates: false,
  );
  try {
    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        // prefs.setString('scan1', r.advertisementData.manufacturerData.toString());
        print(r);
      }
    });
  } catch (e) {
    print(e);
  }

  print("Fired at ${DateTime.now()}");
  print(prefs.getString('scan1'));
}

class BuildResultScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      stream: FlutterBlue.instance.scanResults,
      initialData: [],
      builder: (c, scanResult) {
        return Column(
          children: scanResult.data.map((s) {
            List<int> parsed =
                s.advertisementData.manufacturerData.values.toList()[0];
            print(parsed.length);
            return ListTile(
              title: Text(s.device.id.toString()),
              subtitle:
                  Text(s.advertisementData.manufacturerData.values.toString()),
              leading: Text(s.rssi.toString()),
            );
          }).toList(),
        );
      },
    );
  }
}

class WatchBoxHive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
      box: Hive.box('scansresult'),
      builder: (context, box) {
        return box.isEmpty
            ? LinearProgressIndicator()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final scanDatum = box.getAt(index) as ScansResult;
                  return ListTile(
                    title: Text(scanDatum.master),
                    subtitle: Column(
                      children: [
                        Text(scanDatum.slave),
                        Text(scanDatum.scanDate.toString())
                      ],
                    ),
                    leading: Text("${scanDatum.rssi}"),
                  );
                },
              );
      },
    );
  }
}

class BuildHiveScans extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('scansresult').listenable(),
      builder: (context, box, _) {
        return box.isEmpty
            ? LinearProgressIndicator()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final scanDatum = box.getAt(index) as ScansResult;
                  return ListTile(
                    title: Text(scanDatum.master),
                    subtitle: Column(
                      children: [
                        Text(scanDatum.slave),
                        Text(scanDatum.scanDate.toString())
                      ],
                    ),
                    leading: Text("${scanDatum.rssi}"),
                  );
                },
              );
      },
    );
  }
}
