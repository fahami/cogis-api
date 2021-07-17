import 'package:cogis/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:cogis/model/hospitals.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'components/build_list_cta.dart';
import 'persistance/hospital_data.dart';

class Hospital extends StatefulWidget {
  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  @override
  void initState() {
    super.initState();
    insertHospital();
  }

  int hospitalCount = 25;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: aBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ElevatedButton(
              onPressed: () => Get.toNamed('/home'),
              child: Icon(Icons.arrow_back),
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(8),
                  primary: Colors.white,
                  onPrimary: Colors.black),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DAFTAR', style: TextStyle(color: Colors.black54)),
                Text(
                  'Rumah Sakit',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ],
        ),
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
                insertHospital();
                return Center(child: CircularProgressIndicator());
              }
              return Container(
                color: aBackgroundColor,
                child: ValueListenableBuilder(
                  valueListenable: hospitals.listenable(),
                  builder: (context, box, _) {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
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
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
