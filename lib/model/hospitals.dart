import 'package:hive/hive.dart';
part 'hospitals.g.dart';

@HiveType(typeId: 0)
class Hospitals {
  @HiveField(0)
  String name;
  @HiveField(1)
  String address;
  @HiveField(2)
  String phone;
  Hospitals(this.name, this.address, this.phone);
}
