import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/build_input_rounded.dart';
import 'package:get/get.dart';

import 'constants/color.dart';
import 'constants/text.dart';
import 'provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formLogin = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiToken = prefs.getString('token');
    return apiToken == null ? Get.offNamed('/login') : Get.offNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FadeInUp(
                  child: Image.asset('assets/images/login.png', width: 340),
                ),
                SizedBox(height: 8),
                FadeIn(child: Text('Silahkan masuk', style: aHeadingStyle)),
                SizedBox(height: 4),
                FadeIn(
                  delay: Duration(seconds: 1),
                  child: Text('Bantu sesama dengan kontribusi bersama',
                      style: aSubtitleStyle),
                ),
                SizedBox(height: 8),
                FadeIn(
                  child: Form(
                    key: _formLogin,
                    child: Column(
                      children: [
                        InputRoundedField(
                          fillHints: [AutofillHints.telephoneNumber],
                          controller: phoneController,
                          hintText: 'Nomor telepon',
                          inputType: TextInputType.phone,
                          validationError: 'Masukkan nomor telepon',
                        ),
                        InputRoundedField(
                          controller: passController,
                          hintText: 'Kata sandi',
                          inputType: TextInputType.text,
                          obsecure: true,
                          validationError: 'Masukkan kata sandi',
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 200,
                          child: ElevatedButton(
                            child: Text('Masuk', style: aLightStyle),
                            onPressed: () async {
                              final form = _formLogin.currentState;
                              form.save();
                              if (form.validate()) {
                                buildLoginLoader(context);
                                print(phoneController.text +
                                    " " +
                                    passController.text);
                                final result = await Provider.of<AuthSystem>(
                                        context,
                                        listen: false)
                                    .loginUser(
                                  phone: phoneController.text,
                                  password: passController.text,
                                );
                                if (result != null) {
                                  Navigator.of(context).pop();
                                  Get.offNamed('/home');
                                } else {
                                  Navigator.of(context).pop();
                                  return _buildShowErrorDialog(context,
                                      "Nomor telepon atau kata sandi salah, silakan isi dengan data yang sesuai.");
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: aAccentColor,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FadeInUp(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Belum mempunyai akun?'),
                      ButtonTheme(
                        child: TextButton(
                          onPressed: () => Get.toNamed('/register'),
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
        ),
      ),
    );
  }

  Future buildLoginLoader(BuildContext ctx) {
    return showDialog(
      context: ctx,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );
  }

  Future _buildShowErrorDialog(BuildContext ctx, _message) {
    return showDialog(
      context: ctx,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Peringatan!'),
          content: Text(_message),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(), child: Text('Cancel'))
          ],
        );
      },
    );
  }
}
