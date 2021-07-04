import 'package:flutter/material.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BroadcastBLE with ChangeNotifier {
  bool _isBroadcasting = false;
  bool _isUploading = false;
  bool get isUploading => _isUploading;
  bool get isBroadcasting => _isBroadcasting;
  String _uuidBroadcast;
  String get uuidBroadcast => _uuidBroadcast;

  Future<String> setupUuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _uuid = prefs.getString('uuid1');
    _uuidBroadcast = _uuid;
    print('uuid sekarang: $_uuidBroadcast');
    return _uuidBroadcast;
  }

  Future<bool> stateBroadcasting() async {
    BeaconBroadcast beaconBroadcast = BeaconBroadcast();
    bool isAdvertising = await beaconBroadcast.isAdvertising();
    _isBroadcasting = isAdvertising;
    notifyListeners();
    return _isBroadcasting;
  }

  set isUploading(bool trigger) {
    _isUploading = trigger ? true : false;
    notifyListeners();
  }

  set isBroadcasting(bool trigger) {
    BeaconBroadcast beaconBroadcast = BeaconBroadcast();
    try {
      if (trigger == true) {
        setupUuid();
        Future.delayed(Duration(seconds: 2)).then((_) {
          print("UUID Dieksekusi: $_uuidBroadcast");
          beaconBroadcast
              .setUUID(_uuidBroadcast)
              .setMajorId(1)
              .setMinorId(100)
              .setManufacturerId(0x0118)
              .setAdvertiseMode(AdvertiseMode.lowPower)
              .start();
        });
      } else {
        beaconBroadcast.stop();
      }
    } catch (e) {
      print(e);
    }
    stateBroadcasting();
    notifyListeners();
  }

  Future<BeaconStatus> get supportBroadcasting async {
    BeaconBroadcast beaconBroadcast = BeaconBroadcast();
    BeaconStatus _isTransmissionSupported;
    beaconBroadcast
        .checkTransmissionSupported()
        .then((isTransmissionSupported) {
      return _isTransmissionSupported = isTransmissionSupported;
    });
    notifyListeners();
    return _isTransmissionSupported;
  }

  String get statusBroadcasting => (_isBroadcasting)
      ? 'Kamu terlindungi'
      : 'Waspada Covid-19 di sekitar anda';
}
