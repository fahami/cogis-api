import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:gis_apps/components/build_list_cta.dart';
import 'package:gis_apps/components/build_location_indicator.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:gis_apps/model/scans.dart';
import 'package:gis_apps/provider/broadcast_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'constants/text.dart';
import 'provider/scan_provider.dart';

class ContactTrace extends StatefulWidget {
  @override
  _ContactTraceState createState() => _ContactTraceState();
}

class _ContactTraceState extends State<ContactTrace> {
  var location = Location();
  Map<String, double> userLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.amber,
              child: FlutterMap(
                options: MapOptions(center: LatLng(51.5, -0.09), zoom: 12),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          'https://api.tiles.mapbox.com/styles/v1/blacksoul/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                      additionalOptions: {
                        'accessToken':
                            'pk.eyJ1IjoiYmxhY2tzb3VsIiwiYSI6ImNqbHd4NGVxMTA0Z3ozcG10dmFkdWI5MTkifQ.nC02ckrcy3bHMiSrQRvSog',
                        'id': 'ckjoue1fp36wp19oaog2egeqd',
                      })
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 0.5,
              builder: (c, s) {
                return Material(
                  color: aLightColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  elevation: 10,
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider<BroadcastBLE>(
                        create: (context) => BroadcastBLE(),
                      ),
                      ChangeNotifierProvider<ScanBLE>(
                        create: (context) => ScanBLE(),
                      ),
                    ],
                    child: Container(
                      padding: EdgeInsets.only(top: 9),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              height: 4,
                              width: 60,
                              margin: EdgeInsets.only(bottom: 17),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          Text(
                            'Daftar riwayat kontak',
                            style: aHeadingStyle,
                          ),
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
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable:
                                  Hive.box('scansresult').listenable(),
                              builder: (context, box, child) {
                                return ListView.builder(
                                  controller: s,
                                  itemCount: box.length,
                                  itemBuilder: (context, index) {
                                    final itemScan =
                                        box.getAt(index) as ScansResult;
                                    return ListCTA(
                                        titleCTA: itemScan.master,
                                        subtitleCTA: itemScan.slave);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Align(alignment: Alignment.topCenter, child: GPSLocation()),
          ],
        ),
      ),
    );
  }
}
