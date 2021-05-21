import 'package:flutter/material.dart';
import 'package:gis_apps/model/hospitals.dart';
import 'package:animate_do/animate_do.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'components/build_list_cta.dart';
import 'persistance/hospital_data.dart';

class Hospital extends StatefulWidget {
  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  int hospitalCount = 25;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Rumah Sakit'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: Hive.openBox('hospitals'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error),
                );
              }
              final hospitals = Hive.box('hospitals');
              if (hospitals.length == 0) {
                Center(child: CircularProgressIndicator());
                return insertHospital();
              }
              return Container(
                child: ValueListenableBuilder(
                  valueListenable: hospitals.listenable(),
                  builder: (context, box, _) {
                    return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final itemHospital = box.getAt(index) as Hospitals;
                        return ZoomIn(
                          child: ListCTA(
                            titleCTA: itemHospital.name,
                            subtitleCTA: itemHospital.address,
                            iconCTA1: Icons.navigation,
                            iconCTA2: Icons.call,
                            urlCTA1:
                                "https://www.google.com/maps/dir/?api=1&destination=${itemHospital.name} ${itemHospital.address}",
                            urlCTA2: "tel:${itemHospital.phone}",
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
