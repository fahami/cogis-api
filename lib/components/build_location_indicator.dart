import 'package:flutter/material.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:gis_apps/constants/text.dart';

class GPSLocation extends StatelessWidget {
  const GPSLocation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
