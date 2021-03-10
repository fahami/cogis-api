import 'package:flutter/material.dart';
import 'package:gis_apps/constants/color.dart';

class BuildInputField extends StatelessWidget {
  final Widget child;
  const BuildInputField({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: aDisabledColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
