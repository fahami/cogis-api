import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gis_apps/provider/broadcast_provider.dart';
import 'package:gis_apps/provider/scan_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/build_menu.dart';
import 'constants/color.dart';
import 'constants/text.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: aBackgroundColor,
      appBar: AppBar(
        backgroundColor: aBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.more_vert,
                color: aTextColor,
              ),
              onPressed: () {})
        ],
        title: Center(
          child: SizedBox(
            width: 212,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: aLightColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.location_on, color: aAccentColor),
                  Text(
                    "Surabaya, Jawa Timur",
                    style: aLocationStyle,
                  ),
                  Icon(Icons.expand_more, color: aTextColor),
                ],
              ),
            ),
          ),
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
                            child: Text(
                              'Bagaimana kabarmu?',
                              style: aHeadingStyle,
                            ),
                          ),
                          Positioned(
                            top: 167,
                            child: Text(
                              'Semoga sehat ya..',
                              style: aSubtitleStyle,
                            ),
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
                          create: (context) => BroadcastBLE(),
                        ),
                        ChangeNotifierProvider<ScanBLE>(
                          create: (context) => ScanBLE(),
                        ),
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
                                subtitle: Text(broadcastBLE.statusBroadcasting),
                                title: Text("Aktifkan tracing"),
                              ),
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
                child: Container(
                  width: 225,
                  child: ElevatedButton(
                    onPressed: () {
                      launch('tel:081212123119');
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      primary: aAccentColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.call,
                          color: aLightColor,
                        ),
                        Text(
                          'Hubungi Call Center',
                          style: aCTAStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
