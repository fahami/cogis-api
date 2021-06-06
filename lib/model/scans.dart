import 'package:hive/hive.dart';
part 'scans.g.dart';

@HiveType(typeId: 2)
class ScansResult {
  @HiveField(0)
  String master;
  @HiveField(1)
  String slave;
  @HiveField(2)
  DateTime scanDate;
  @HiveField(3)
  int rssi;

  ScansResult(this.master, this.slave, this.scanDate, this.rssi);
}
