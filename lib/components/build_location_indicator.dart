import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:gis_apps/constants/text.dart';
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
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        print("dapat lokasi di position $position");
        _currentPosition = position;
        prefs
          ..setString('latitude', _currentPosition.latitude.toString())
          ..setString('longitude', _currentPosition.longitude.toString());
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude,
          localeIdentifier: "id_ID");

      Placemark place = placemarks[0];
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
