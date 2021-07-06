import 'package:flutter/material.dart';
import 'package:cogis/constants/color.dart';

class BuildInputField extends StatelessWidget {
  final Widget child;
  const BuildInputField({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: aDisabledColor),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
