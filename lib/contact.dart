import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:gis_apps/components/build_list_cta.dart';
import 'package:gis_apps/components/build_location_indicator.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:gis_apps/model/scans.dart';
import 'package:gis_apps/provider/broadcast_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/text.dart';
import 'provider/scan_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';

class ContactTrace extends StatefulWidget {
  @override
  _ContactTraceState createState() => _ContactTraceState();
}

LatLng coordinate = LatLng(-7.291152, 112.684962);

class _ContactTraceState extends State<ContactTrace> {
  final MapController mapController = MapController();
  Future<LatLng> getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lat = double.parse(prefs.getString('latitude'));
    final lng = double.parse(prefs.getString('longitude'));
    coordinate = LatLng(lat, lng);
    return coordinate;
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.amber,
              child: FutureBuilder(
                  future: getLocation(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text("Sedang error");
                      } else {
                        return FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                              center: snapshot.data,
                              zoom: 13,
                              plugins: [LocationPlugin()]),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYmxhY2tzb3VsIiwiYSI6ImNqbHd4NGVxMTA0Z3ozcG10dmFkdWI5MTkifQ.nC02ckrcy3bHMiSrQRvSog",
                            ),
                          ],
                          nonRotatedLayers: <LayerOptions>[
                            // USAGE NOTE 3: Add the options for the plugin
                            LocationOptions(
                              locationButton(),
                              updateInterval: Duration(seconds: 5),
                              onLocationUpdate: (LatLngData ld) {
                                print(
                                    'Location updated: ${ld?.location} (accuracy: ${ld?.accuracy})');
                              },
                              onLocationRequested: (LatLngData ld) {
                                if (ld == null) {
                                  return;
                                }
                                mapController.move(ld.location, 16.0);
                              },
                            ),
                          ],
                        );
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
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

  LocationButtonBuilder locationButton() {
    return (BuildContext context, ValueNotifier<LocationServiceStatus> status,
        Function onPressed) {
      return Container(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
            child: FloatingActionButton(
                child: ValueListenableBuilder<LocationServiceStatus>(
                    valueListenable: status,
                    builder: (BuildContext context, LocationServiceStatus value,
                        Widget child) {
                      switch (value) {
                        case LocationServiceStatus.disabled:
                        case LocationServiceStatus.permissionDenied:
                        case LocationServiceStatus.unsubscribed:
                          return const Icon(
                            Icons.location_disabled,
                            color: Colors.white,
                          );
                        default:
                          return const Icon(
                            Icons.location_searching,
                            color: Colors.white,
                          );
                      }
                    }),
                onPressed: () => onPressed()),
          ),
        ),
      );
    };
  }
}
