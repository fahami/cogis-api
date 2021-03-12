import 'package:flutter/material.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';

class BroadcastBLE with ChangeNotifier {
  bool _isBroadcasting = false;
  bool get isBroadcasting => _isBroadcasting;
  set isBroadcasting(bool trigger) {
    BeaconBroadcast beaconBroadcast = BeaconBroadcast();
    if (trigger == true) {
      beaconBroadcast
          .setUUID('39ED98FF-2900-441A-802F-9C398FC199D2')
          .setMajorId(1)
          .setMinorId(100)
          .start();
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
