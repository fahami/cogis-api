import 'package:flutter/material.dart';

class MedicalReport extends StatefulWidget {
  @override
  _MedicalReportState createState() => _MedicalReportState();
}

class _MedicalReportState extends State<MedicalReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
          child: Text("Medical Report"),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}
