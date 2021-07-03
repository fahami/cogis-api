import 'package:bluetooth_enable/bluetooth_enable.dart';

askPermission() async {
  BluetoothEnable.enableBluetooth.then((value) {
    if (value == 'true') {
      print('Bluetooth telah dinyalakan');
      return true;
    } else if (value == "false") {
      print('Bluetooth mati');
      return false;
    }
  });
}
