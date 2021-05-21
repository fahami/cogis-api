import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:gis_apps/model/scans.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'components/build_location_indicator.dart';
import 'components/build_quick_button.dart';
import 'components/build_menu.dart';
import 'provider/broadcast_provider.dart';
import 'provider/scan_provider.dart';
import 'constants/color.dart';
import 'constants/text.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              backgroundColor: aAccentColor,
              onPressed: () => FlutterBlue.instance.stopScan(),
            );
          } else {
            return FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () => FlutterBlue.instance
                  .startScan(timeout: Duration(seconds: 10)),
            );
          }
        },
      ),
      backgroundColor: aBackgroundColor,
      appBar: AppBar(
        backgroundColor: aBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: aTextColor,
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Get.toNamed('/login');
              })
        ],
        title: Center(
          child: GPSLocation(),
        ),
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
                          FadeInLeft(
                            child: Row(
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
                          ),
                          Positioned(
                            top: 143,
                            child: HaloHero(),
                          ),
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
                      ],
                      child: Column(
                        children: [
                          Consumer<ScanBLE>(
                            builder: (context, scanBLE, _) =>
                                Consumer<BroadcastBLE>(
                              builder: (context, broadcastBLE, _) =>
                                  SwitchListTile(
                                value: broadcastBLE.isBroadcasting,
                                onChanged: (value) {
                                  broadcastBLE.isBroadcasting = value;
                                  scanBLE.isScanning = value;
                                },
                                subtitle: Text("Kosong"),
                                title: Text("Aktifkan tracing"),
                              ),
                            ),
                          ),
                          Container(child: buildResultScan()),
                          Container(child: buildHiveScans()),
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

  Widget buildHiveScans() {
    // Hive.box('scansresult').clear();
    return ValueListenableBuilder(
      valueListenable: Hive.box('scansresult').listenable(),
      builder: (context, box, _) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: box.length,
          itemBuilder: (context, index) {
            final scanDatum = box.getAt(index) as ScansResult;
            print(scanDatum);
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

  Widget buildResultScan() {
    return StreamBuilder<List<ScanResult>>(
      stream: FlutterBlue.instance.scanResults,
      initialData: [],
      builder: (c, scanResult) {
        return Column(
          children: scanResult.data.map((s) {
            return ListTile(
              title: Text(s.device.id.toString()),
              subtitle: Text(
                Uuid.unparse(s.advertisementData.manufacturerData.values
                    .toList()[0]
                    .sublist(8)),
              ),
              leading: Text(s.rssi.toString()),
            );
          }).toList(),
        );
      },
    );
  }
}

class HaloHero extends StatefulWidget {
  const HaloHero({
    Key key,
  }) : super(key: key);

  @override
  _HaloHeroState createState() => _HaloHeroState();
}

class _HaloHeroState extends State<HaloHero> {
  SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    initializePref().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> initializePref() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return Text(
          'Halo ${this.preferences.getString('name')}!',
          style: aHeadingStyle,
        );
      },
    );
  }
}
