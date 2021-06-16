import 'package:flutter/material.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BroadcastBLE with ChangeNotifier {
  bool _isBroadcasting = false;
  bool get isBroadcasting => _isBroadcasting;
  String _uuidBroadcast;
  String get uuidBroadcast => _uuidBroadcast;

  Future<String> setupUuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid =
        prefs.getString('uuid1') ?? '2db88e72-b779-11eb-8529-0242ac130003';
    _uuidBroadcast = uuid;
    notifyListeners();
    return uuid;
  }

  void stateBroadcasting() async {
    BeaconBroadcast beaconBroadcast = BeaconBroadcast();
    bool isAdvertising = await beaconBroadcast.isAdvertising();
    _isBroadcasting = isAdvertising;
    print("broadcasting status is: $isAdvertising");
  }

  set isBroadcasting(bool trigger) {
    setupUuid();
    BeaconBroadcast beaconBroadcast = BeaconBroadcast();
    if (trigger == true) {
      beaconBroadcast
          .setUUID(_uuidBroadcast)
          .setMajorId(1)
          .setMinorId(100)
          .setManufacturerId(0x0118)
          .setAdvertiseMode(AdvertiseMode.lowPower)
          .start();
    } else {
      beaconBroadcast.stop();
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
