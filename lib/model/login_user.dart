// To parse this JSON data, do
//
//     final loginUser = loginUserFromJson(jsonString);

import 'dart:convert';

LoginUser loginUserFromJson(String str) => LoginUser.fromJson(json.decode(str));

String loginUserToJson(LoginUser data) => json.encode(data.toJson());

class LoginUser {
  LoginUser(
      {this.id,
      this.name,
      this.apiToken,
      this.rssi,
      this.uploadInterval,
      this.scanInterval});

  int id;
  String name;
  String apiToken;
  int rssi;
  int uploadInterval;
  int scanInterval;

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
      id: json["id"],
      name: json["name"],
      apiToken: json["api_token"],
      rssi: json["rssi"],
      uploadInterval: json["uploadInterval"],
      scanInterval: json["scanInterval"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "api_token": apiToken,
        "rssi": rssi,
        "uploadInterval": uploadInterval,
        "scanInterval": scanInterval
      };
}
