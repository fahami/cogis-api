import 'package:flutter/material.dart';

class BackgroundScan with ChangeNotifier {
  bool _isScanning = false;
  bool get isScanning => _isScanning;

  set isScanning(bool trigger) {
    if (trigger) {
      _isScanning = true;
    } else {
      _isScanning = false;
    }
    notifyListeners();
  }
}
