import 'package:flutter/material.dart';
import 'package:cogis/constants/color.dart';
import 'package:cogis/constants/text.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 225,
      child: ElevatedButton.icon(
        icon: Icon(Icons.call, color: aLightColor),
        label: Text('Hubungi Call Center', style: aCTAStyle),
        onPressed: () => launch('tel:081212123119'),
        style: ElevatedButton.styleFrom(
          elevation: 5,
          primary: aAccentColor,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
