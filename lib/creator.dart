import 'package:flutter/material.dart';

class CreatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.3,
                  backgroundImage: AssetImage('assets/images/fahmi.jpeg'),
                ),
                Row(
                  children: [Text("Nama:")]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
