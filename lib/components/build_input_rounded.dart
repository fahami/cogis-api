import 'package:flutter/material.dart';
import 'package:gis_apps/components/build_input_field.dart';

class InputRoundedField extends StatelessWidget {
  final TextInputType inputType;
  final String hintText;
  final bool obsecure;
  const InputRoundedField({
    Key key,
    this.inputType,
    this.hintText,
    this.obsecure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BuildInputField(
      child: TextField(
        decoration:
            InputDecoration(hintText: hintText, border: InputBorder.none),
        keyboardType: inputType,
        obscureText: obsecure ?? false,
      ),
    );
  }
}
