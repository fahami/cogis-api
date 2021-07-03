import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:gis_apps/constants/text.dart';
import 'package:gis_apps/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'components/build_input_rounded.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool _checkedVal = false;
  final _formRegister = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: aBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/register.png', width: 340),
                SizedBox(height: 8),
                Text('Daftarkan diri Anda', style: aHeadingStyle),
                SizedBox(height: 4),
                Text('Saling bantu jaga sesama', style: aSubtitleStyle),
                SizedBox(height: 8),
                Form(
                  key: _formRegister,
                  child: Column(
                    children: [
                      InputRoundedField(
                        controller: nameController,
                        hintText: 'Nama lengkap',
                        inputType: TextInputType.name,
                      ),
                      InputRoundedField(
                        controller: phoneController,
                        hintText: 'Nomor telepon',
                        inputType: TextInputType.phone,
                      ),
                      InputRoundedField(
                        controller: pwdController,
                        hintText: 'Kata sandi',
                        inputType: TextInputType.text,
                        obsecure: true,
                      ),
                      SizedBox(
                        width: 340,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                                activeColor: aAccentColor,
                                value: _checkedVal,
                                onChanged: (value) {
                                  setState(() {
                                    _checkedVal = value;
                                    print(_checkedVal);
                                  });
                                }),
                            Text(
                                'Saya menyetujui syarat dan ketentuan yang ada',
                                style: aTermStyle)
                          ],
                        ),
                      ),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                          child: Text('Masuk', style: aLightStyle),
                          onPressed: _checkedVal == false
                              ? null
                              : () async {
                                  final form = _formRegister.currentState;
                                  form.save();
                                  if (form.validate()) {
                                    buildLoginLoader(context);
                                  } else {}
                                  var req = await Provider.of<AuthSystem>(
                                    context,
                                    listen: false,
                                  ).createUser(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    pwd: pwdController.text,
                                  );
                                  req != 200
                                      ? registerDialog(context)
                                      : Get.offNamed('/home');
                                },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: aAccentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
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

  Future<dynamic> registerDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pendaftaran Gagal dilakukan."),
          content: Text(
              "Pastikan Anda tidak menggunakan nomor telepon yang sama dengan sebelumnya"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tutup"),
            )
          ],
        );
      },
    );
  }

  Future buildLoginLoader(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
