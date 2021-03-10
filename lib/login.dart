import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:gis_apps/constants/text.dart';
import 'package:gis_apps/landing.dart';
import 'package:gis_apps/register.dart';
import 'components/build_input_rounded.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: aBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    children: [
                      FadeInUp(
                        child: Image.asset(
                          'assets/images/login.png',
                          width: 350,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ElasticIn(
                        child: Text(
                          'Silahkan masuk',
                          style: aHeadingStyle,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      ElasticIn(
                        delay: Duration(seconds: 1),
                        child: Text(
                          'Bantu sesama dengan kontribusi bersama',
                          style: aSubtitleStyle,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FadeIn(
                        child: Column(
                          children: [
                            InputRoundedField(
                              hintText: 'Nomor telepon',
                              inputType: TextInputType.phone,
                            ),
                            InputRoundedField(
                              hintText: 'Kata sandi',
                              inputType: TextInputType.text,
                              obsecure: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: SizedBox(
                                width: 200,
                                height: 50,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: aAccentColor),
                                  onPressed: () {
                                    Get.to(() => LandingScreen());
                                  },
                                  child: Text(
                                    'Masuk',
                                    style: aLightStyle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 60,
              child: Row(
                children: [
                  Text('Belum mempunyai akun?'),
                  ButtonTheme(
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => RegisterScreen());
                      },
                      child: Text(
                        'Daftar akun.',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
