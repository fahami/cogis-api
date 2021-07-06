import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cogis/constants/color.dart';
import 'package:cogis/constants/text.dart';
import 'package:get/get.dart';

class BuildMenu extends StatelessWidget {
  final String menuName;
  final String menuImage;
  final EdgeInsets menuMargin;
  final String menuNavigate;
  const BuildMenu({
    Key key,
    this.menuName,
    this.menuImage,
    this.menuMargin,
    this.menuNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: menuMargin,
        height: 200,
        decoration: BoxDecoration(
            color: aLightColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: aDisabledColor)),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.toNamed(menuNavigate);
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    menuImage,
                    width: 81,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    menuName,
                    style: aMenuStyle,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
