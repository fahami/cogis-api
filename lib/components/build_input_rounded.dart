import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cogis/components/build_input_field.dart';

class InputRoundedField extends StatelessWidget {
  final TextInputType inputType;
  final String hintText;
  final bool obsecure;
  final TextEditingController controller;
  final Iterable<String> fillHints;
  final String validationError;
  const InputRoundedField({
    Key key,
    this.inputType,
    this.hintText,
    this.obsecure,
    this.controller,
    this.fillHints,
    this.validationError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BuildInputField(
      child: TextFormField(
        textInputAction: TextInputAction.next,
        autofillHints: fillHints,
        controller: controller,
        decoration:
            InputDecoration(hintText: hintText, border: InputBorder.none),
        keyboardType: inputType,
        obscureText: obsecure ?? false,
        validator: (value) {
          return value.isEmpty ? validationError : null;
        },
      ),
    );
  }
}
