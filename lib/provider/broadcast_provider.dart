import 'package:flutter/material.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BroadcastBLE with ChangeNotifier {
  bool _isBroadcasting = false;
  bool get isBroadcasting => _isBroadcasting;
  String _uuidBroadcast;
  String get uuidBroadcast => _uuidBroadcast;

  void setupUuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid =
        prefs.getString('uuid1') ?? '2db88e72-b779-11eb-8529-0242ac130003';
    _uuidBroadcast = uuid;
    notifyListeners();
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
          .setExtraData([00112]).start();
    } else {
      beaconBroadcast.stop();
    }
    _isBroadcasting = trigger;
    notifyListeners();
  }

  String get statusBroadcasting => (_isBroadcasting)
      ? 'Kamu terlindungi'
      : 'Waspada Covid-19 di sekitar anda';
}
