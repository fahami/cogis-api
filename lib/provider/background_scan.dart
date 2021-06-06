import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundScan with ChangeNotifier {
  bool _isBroadcastBackground = false;
  bool get isBroadcastBackground => _isBroadcastBackground;
  String _uuidBroadcast;

  void setupUuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid =
        prefs.getString('uuid1') ?? '2db88e72-b779-11eb-8529-0242ac130003';
    _uuidBroadcast = uuid;
    notifyListeners();
  }

  set isBroadcastBackground(bool trigger) {
    if (trigger) {
      try {
        _isBroadcastBackground = true;
      } catch (e) {
        _isBroadcastBackground = false;
      }
    } else {
      print('tertrigger cancel');
      _isBroadcastBackground = false;
    }
    notifyListeners();
  }
}
