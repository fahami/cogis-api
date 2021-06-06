import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  var textStyle = GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500);
  void _setOnTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: aLightColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 12,
            offset: Offset(0, 5),
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? new SvgPicture.asset('assets/icons/home_color.svg')
                : new SvgPicture.asset('assets/icons/home.svg'),
            // ignore: deprecated_member_use
            title: Text(
              'Beranda',
              style: textStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? new SvgPicture.asset('assets/icons/chart_color.svg')
                : new SvgPicture.asset('assets/icons/chart.svg'),
            // ignore: deprecated_member_use
            title: Text(
              'Statistik',
              style: textStyle,
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: aAccentColor,
        unselectedItemColor: Colors.grey,
        onTap: _setOnTap,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        showUnselectedLabels: true,
        elevation: 0,
      ),
    );
  }
}
