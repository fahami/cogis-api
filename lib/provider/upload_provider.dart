import 'package:flutter/material.dart';
import 'package:gis_apps/model/scans.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UploadSystem with ChangeNotifier {
  Future uploadData({ScansResult scansResult}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('userId');
      final uploadUrl = Uri.parse("https://api.karyasa.my.id/scan/$id");
      var datum = Hive.box('scansresult').values.forEach((data) {
        print(data);
      });

      final uploadReq = await http.post(uploadUrl, body: scansResult);
      if (uploadReq == true) {
        print("upload berhasil");
      } else {
        print("upload gagal");
      }
    } catch (e) {
      print("gagal");
    }
  }
}
