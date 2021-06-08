import 'dart:convert';

import 'package:gis_apps/model/scans.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future uploadData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt('userId');
  final uploadUrl = Uri.parse("https://api.karyasa.my.id/scan/$id");
  var boxes = Hive.box('scansresult');
  print(boxes.length);
  for (var i = 0; i < boxes.length; i++) {
    final datum = boxes.getAt(i) as ScansResult;
    var bodyReq = jsonEncode({
      "lat": "-7.276060",
      "lng": "112.793076",
      "rssi": datum.rssi,
      "id_user": id,
      "id_slave": int.parse(datum.slave.substring(9, 12)),
      "scan_date": datum.scanDate.toString()
    });
    final uploadReq = await http.post(uploadUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
          'Content-Type': 'application/json'
        },
        body: bodyReq);
    print(uploadReq.statusCode);
    print(bodyReq);
    print(uploadReq.body);

    uploadReq.statusCode == 200
        ? print('berhasil upload data ${datum.slave} di ${DateTime.now()}')
        : print('Unggah data ${datum.slave} gagal di ${DateTime.now()}');
  }
}
