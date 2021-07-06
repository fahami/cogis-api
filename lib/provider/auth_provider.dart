import 'package:cogis/model/login_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var uuid;

class AuthSystem with ChangeNotifier {
  var currentUser;

  AuthSystem() {
    print("new Auth System");
  }
  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? null;
  }

  Future logout() {
    this.currentUser = null;
    notifyListeners();
    return Future.value(currentUser);
  }

  Future createUser({String name, String phone, String pwd}) async {
    final registerUrl = Uri.parse("https://api.karyasa.my.id/register");
    var req = await http
        .post(registerUrl, body: {"name": name, "phone": phone, "pwd": pwd});
    return req.statusCode;
  }

  Future loginUser({String phone, String password}) async {
    try {
      final loginUrl = Uri.parse("https://api.karyasa.my.id/login");
      var req =
          await http.post(loginUrl, body: {"phone": phone, "pwd": password});
      print(req.statusCode);
      if (req.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'token', 'Bearer ' + loginUserFromJson(req.body).apiToken);
        prefs.setInt('userId', loginUserFromJson(req.body).id);
        prefs.setString('name', loginUserFromJson(req.body).name);
        prefs.setInt('threshold', loginUserFromJson(req.body).rssi);
        prefs.setString('phone', phone);
        String part1 = phone.substring(0, 4);
        int userId = loginUserFromJson(req.body).id;
        prefs.setString(
            'uuid1', "00000000-0000-$part1-7263-${userId}000000000");
        uuid = "00000000-0000-$part1-7263-${userId}000000000";
        print(prefs.getString('uuid1'));
        print(prefs.getInt('threshold'));
      } else {
        return null;
      }
      notifyListeners();
      return req.body;
    } catch (e) {
      print('error didapat $e');
    }
  }
}
