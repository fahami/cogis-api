import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../model/scans.dart';

class ScanBLE with ChangeNotifier {
  bool _isScanning = false;
  bool get isScanning => _isScanning;
  var hasilScan = Hive.box("scansresult");
  String _uuidBroadcast;
  String get uuidBroadcast => _uuidBroadcast;

  void setupUuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid =
        prefs.getString('uuid1') ?? '2db88e72-b779-11eb-8529-0242ac130003';
    _uuidBroadcast = uuid;
    notifyListeners();
  }

  set isScanning(bool trigger) {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    if (trigger == true) {
      flutterBlue.startScan(
        scanMode: ScanMode.balanced,
        allowDuplicates: false,
      );
      flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          List<int> parsed = r.advertisementData.manufacturerData.values
              .toList()[0]
              .sublist(8);
          if (r.rssi < -20 && parsed.length == 16) {
            String parsedSlave = Uuid.unparse(r
                .advertisementData.manufacturerData.values
                .toList()[0]
                .sublist(8));
            print(parsedSlave);
            hasilScan.add(ScansResult(
                uuidBroadcast, parsedSlave, DateTime.now(), r.rssi));
          }
        }
      });
      flutterBlue.stopScan();
    } else {
      flutterBlue.stopScan();
    }
    _isScanning = trigger;
    notifyListeners();
  }

  String get statusScanning =>
      (_isScanning) ? 'Sedang Scan' : 'Scan tidak berjalan';
}