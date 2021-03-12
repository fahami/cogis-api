import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ScanBLE with ChangeNotifier {
  bool _isScanning = false;
  bool get isScanning => _isScanning;
  set isScanning(bool trigger) {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    if (trigger == true) {
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      // Listen to scan results
      List<dynamic> scanResult = [];
      var subscription = flutterBlue.scanResults.listen((results) {
        ScanResult r;
        for (var i = 0; i < results.length; i++) {
          scanResult.insert(i, r.device.name);
        }
      });
      print(scanResult);
    } else {
      flutterBlue.stopScan();
    }
    _isScanning = trigger;
    notifyListeners();
  }

  String get statusScanning =>
      (_isScanning) ? 'Sedang Scan' : 'Scan tidak berjalan';
}
