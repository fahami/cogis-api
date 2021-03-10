import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

import 'constants/text.dart';

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
              minChildSize: 0.2,
              maxChildSize: 0.5,
              builder: (c, s) {
                return Material(
                  color: aLightColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(32, 9, 32, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            controller: s,
                            itemCount: 25,
                            itemBuilder: (context, idx) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                    color: aAccentColor,
                                    borderRadius: BorderRadius.circular(14)),
                                child: ListTile(
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                      color: aToscaColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    padding: EdgeInsets.all(6),
                                    width: 36,
                                    child: Icon(
                                      Icons.map,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Rabu $idx, Mei 2020',
                                    style: aDescriptionStyle,
                                  ),
                                  title: Text('+6289539765726$idx',
                                      style: aCTAStyle),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 212,
                padding: EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: aLightColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.location_on, color: aAccentColor),
                    Text(
                      'Surabaya, Jawa Timur',
                      style: aLocationStyle,
                    ),
                    Icon(Icons.expand_more, color: aTextColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
