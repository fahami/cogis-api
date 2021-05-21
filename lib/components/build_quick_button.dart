import 'package:flutter/material.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:gis_apps/constants/text.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickButton extends StatelessWidget {
  const QuickButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 225,
      child: ElevatedButton(
        onPressed: () {
          launch('tel:081212123119');
        },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          primary: aAccentColor,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    );
  }
}
