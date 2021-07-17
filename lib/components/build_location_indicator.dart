import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cogis/constants/color.dart';
import 'package:cogis/constants/text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GPSLocation extends StatefulWidget {
  @override
  _GPSLocationState createState() => _GPSLocationState();
}

class _GPSLocationState extends State<GPSLocation> {
  Position _currentPosition;
  String _currentAddress;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 212,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: aLightColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.location_on, color: aAccentColor),
            _currentAddress == null
                ? SizedBox(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                    height: 10.0,
                    width: 10.0,
                  )
                : Text(
                    _currentAddress ?? "Lokasi Anda",
                    style: aLocationStyle,
                  ),
            IconButton(
                onPressed: () => _getCurrentLocation(),
                icon: Icon(Icons.gps_fixed, color: aDarkColor)),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Geolocator.getCurrentPosition(
              timeLimit: Duration(seconds: 5),
              desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        setState(() {
          print("Mendapatkan lokasi di $position");
          _currentPosition = position;
          prefs
            ..setString('latitude', _currentPosition.latitude.toString())
            ..setString('longitude', _currentPosition.longitude.toString());
          _getAddressFromLatLng(position.latitude, position.longitude);
        });
      }).catchError((e) {
        print(e);
        final lat = double.parse(prefs.getString('latitude') ?? "-7.2758471");
        final lng = double.parse(prefs.getString('longitude') ?? "112.791567");
        _getAddressFromLatLng(lat, lng);
      });
    } catch (e) {
      print("Gagal mendapatkan lokasi pengguna");
    }
  }

  _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude,
          localeIdentifier: "id_ID");
      Placemark place = placemarks[0];
      print("Didapatkan lokasi geocoding $place");
      setState(() {
        _currentAddress = "${place.subLocality}, ${place.isoCountryCode}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
