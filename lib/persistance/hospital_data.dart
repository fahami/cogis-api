import 'package:gis_apps/model/hospitals.dart';
import 'package:hive/hive.dart';

const hospital_list = [
  {
    "name": "RSUD Blambangan",
    "telp": "0333421118",
    "address":
        "Jl. Letkol. Istiqlah No. 49, Singonegaran, Kec. Banyuwangi, Kab. Banyuwangi, Jawa Timur 68415"
  },
  {
    "name": "RSUD dr. Iskak Tulungagung",
    "telp": "0355322609",
    "address":
        "Jl. Dr. Wahidin Sudiro Husodo, Kedung Taman, Kedungwaru, Kec. Kedungwaru, Kab. Tulungagung, Jawa Timur 66223"
  },
  {
    "name": "RSUD dr. R. Koesma Tuban",
    "telp": "0356321010",
    "address":
        "Jl. Dr. Wahidin Sudirohusodo No. 800, Sidorejo, Kec. Tuban, Kab. Tuban, Jawa Timur 62315"
  },
  {
    "name": "RSUD Dr. R. Sosodoro Djatikoesoemo",
    "telp": "08113224972",
    "address":
        "Jl. Veteran No. 36, Kec. Bojonegoro, Kab. Bojonegoro, Jawa Timur 62111"
  },
  {
    "name": "RSUD dr. Saiful Anwar",
    "telp": "082139672121",
    "address":
        "Jl. Jaksa Agung Suprapto No. 2, Klojen, Kec. Klojen, Kota Malang, Jawa Timur 65111"
  },
  {
    "name": "RSUD dr. Soebandi Jember",
    "telp": "082301598557",
    "address":
        "Jl. Dr. Soebandi No. 124, Cangkring, Patrang, Kec. Patrang, Kab. Jember, Jawa Timur 68111"
  },
  {
    "name": "RSUD dr. Soedono Madiun",
    "telp": "0351454657",
    "address":
        "Jl. Dr. Soetomo No.59, Kartoharjo, Kec. Kartoharjo, Kota Madiun, Jawa Timur 63117"
  },
  {
    "name": "RSUD Dr. Soetomo",
    "telp": "081357171962",
    "address":
        "Jl. Mayjen. Prof. Dr. Moestop No. 6-8, Airlangga, Kec. Gubeng, Kota Surabaya, Jawa Timur 60286"
  },
  {
    "name": "RSUD Pare Kediri",
    "telp": "0354391718",
    "address":
        "Jl. Pahlawan Kusuma Bangsa No. 1, Cangkring, Pelem, Pare, Kediri, Jawa Timur 64213"
  }
];
insertHospital() {
  var _hospitals = Hive.box('hospitals');
  if (_hospitals.length == 0) {
    _hospitals.add(Hospitals(
        "RSUD Blambangan",
        "Jl. Letkol. Istiqlah No. 49, Singonegaran, Kec. Banyuwangi, Kab. Banyuwangi, Jawa Timur 68415",
        "0333421118"));
    _hospitals.add(Hospitals(
        "RSUD dr. Iskak Tulungagung",
        "Jl. Dr. Wahidin Sudiro Husodo, Kedung Taman, Kedungwaru, Kec. Kedungwaru, Kab. Tulungagung, Jawa Timur 66223",
        "0355322609"));
    _hospitals.add(Hospitals(
        "RSUD dr. R. Koesma Tuban",
        "Jl. Dr. Wahidin Sudirohusodo No. 800, Sidorejo, Kec. Tuban, Kab. Tuban, Jawa Timur 62315",
        "0356321010"));
    _hospitals.add(Hospitals(
        "RSUD Dr. R. Sosodoro Djatikoesoemo",
        "Jl. Veteran No. 36, Kec. Bojonegoro, Kab. Bojonegoro, Jawa Timur 62111",
        "08113224972"));
    _hospitals.add(Hospitals(
        "RSUD dr. Saiful Anwar",
        "Jl. Jaksa Agung Suprapto No. 2, Klojen, Kec. Klojen, Kota Malang, Jawa Timur 65111",
        "082139672121"));
    _hospitals.add(Hospitals(
        "RSUD dr. Soebandi Jember",
        "Jl. Dr. Soebandi No. 124, Cangkring, Patrang, Kec. Patrang, Kab. Jember, Jawa Timur 68111",
        "082301598557"));
    _hospitals.add(Hospitals(
        "RSUD dr. Soedono Madiun",
        "Jl. Dr. Soetomo No.59, Kartoharjo, Kec. Kartoharjo, Kota Madiun, Jawa Timur 63117",
        "0351454657"));
    _hospitals.add(Hospitals(
        "RSUD Dr. Soetomo",
        "Jl. Mayjen. Prof. Dr. Moestop No. 6-8, Airlangga, Kec. Gubeng, Kota Surabaya, Jawa Timur 60286",
        "081357171962"));
    _hospitals.add(Hospitals(
        "RSUD Pare Kediri",
        "Jl. Pahlawan Kusuma Bangsa No. 1, Cangkring, Pelem, Pare, Kediri, Jawa Timur 64213",
        "0354391718"));
  } else
    return print("nothing");
}
