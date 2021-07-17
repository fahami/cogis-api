import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  String name;
  @HiveField(1)
  String userId;
  @HiveField(2)
  String phone;
  User(this.name, this.userId, this.phone);
}
