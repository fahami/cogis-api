class LoggedUser {
  String name;
  int id;
  String token;

  LoggedUser({this.name, this.id, this.token});

  LoggedUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['token'] = this.token;
    return data;
  }
}
