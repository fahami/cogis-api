import 'package:flutter/material.dart';

class Statistic extends StatefulWidget {
  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          child: Text("Stats"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
