import 'package:flutter/material.dart';

class BackgroundScan with ChangeNotifier {
  bool _isBroadcastBackground = false;
  bool get isBroadcastBackground => _isBroadcastBackground;
  String _uuidBroadcast;

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
