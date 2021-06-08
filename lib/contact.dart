import 'package:flutter/material.dart';
import 'package:gis_apps/components/build_list_cta.dart';
import 'package:gis_apps/components/build_location_indicator.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:gis_apps/model/scans.dart';
import 'package:gis_apps/provider/broadcast_provider.dart';
import 'package:gis_apps/provider/upload_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:map/map.dart';
import 'constants/text.dart';
import 'provider/scan_provider.dart';
import 'package:latlng/latlng.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ContactTrace extends StatefulWidget {
  @override
  _ContactTraceState createState() => _ContactTraceState();
}

class _ContactTraceState extends State<ContactTrace> {
  MapController controller =
      MapController(location: LatLng(-7.2966855, 112.7509655));
  Offset _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.amber,
              child: GestureDetector(
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                child: Map(
                  controller: controller,
                  builder: (context, x, y, z) {
                    final mapBoxURL =
                        "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/$z/$x/$y?access_token=pk.eyJ1IjoiYmxhY2tzb3VsIiwiYSI6ImNqbHd4NGVxMTA0Z3ozcG10dmFkdWI5MTkifQ.nC02ckrcy3bHMiSrQRvSog";
                    return CachedNetworkImage(
                      imageUrl: mapBoxURL,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 0.5,
              builder: (c, s) {
                return Material(
                  elevation: 10,
                  color: aLightColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                          Text('Daftar riwayat kontak', style: aHeadingStyle),
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
                                      subtitleCTA: itemScan.slave,
                                    );
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
