import 'package:flutter/material.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:gis_apps/constants/text.dart';
import 'package:gis_apps/components/build_hospital_cta.dart';
import 'package:gis_apps/persistance/hospital_data.dart';
import 'package:animate_do/animate_do.dart';

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
        child: Container(
          child: ListView.builder(
            itemCount: hospital_list.length,
            itemBuilder: (context, idx) {
              return ZoomIn(
                delay: Duration(milliseconds: idx * 80),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                  decoration: BoxDecoration(
                      color: aAccentColor,
                      borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    trailing: Container(
                      width: 80,
                      child: Row(
                        children: [
                          HospitalCTA(
                            url: "tel:" + hospital_list[idx]['telp'],
                            icon: Icons.phone,
                          ),
                          SizedBox(width: 8),
                          HospitalCTA(
                            url:
                                "https://www.google.com/maps/dir/?api=1&destination=" +
                                    hospital_list[idx]['name'] +
                                    " " +
                                    hospital_list[idx]['address'],
                            icon: Icons.navigation,
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      hospital_list[idx]['address'],
                      style: aDescriptionStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    title: Text(
                      hospital_list[idx]['name'],
                      style: aHospitalStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
