import 'package:flutter/material.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalCTA extends StatelessWidget {
  final String url;
  final IconData icon;
  const HospitalCTA({
    Key key,
    this.url,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final urlCall = url;
        if (await canLaunch(urlCall)) {
          await launch(urlCall);
        } else
          throw 'Could not launch call';
      },
      child: Container(
        decoration: BoxDecoration(
          color: aToscaColor,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.all(6),
        width: 36,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
