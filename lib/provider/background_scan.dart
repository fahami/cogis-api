import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:gis_apps/model/scans.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as pathPro;
import 'package:flutter_ble_lib/flutter_ble_lib.dart' as fBle;
import 'package:uuid/uuid.dart';

class BackgroundScan with ChangeNotifier {
  bool _isScanning = false;
  bool get isScanning => _isScanning;
  String _uuidBroadcast;

  set isScanning(bool trigger) {
    if (trigger) {
      try {
        _isScanning = true;
      } catch (e) {
        _isScanning = false;
      }
    } else {
      print('tertrigger cancel');
      _isScanning = false;
    }
    notifyListeners();
  }
}
