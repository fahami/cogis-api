import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:gis_apps/constants/color.dart';
import 'package:gis_apps/constants/text.dart';
import 'package:gis_apps/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'components/build_input_rounded.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool _checkedVal = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: aBackgroundColor,
      body: Column(children: [
        Expanded(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/register.png',
                      width: 340,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Daftarkan diri Anda',
                      style: aHeadingStyle,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Membangun negara Indonesia yang sehat',
                      style: aSubtitleStyle,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
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
                                    _checkedVal = value;
                                  }),
                              Text(
                                'Saya menyetujui syarat dan ketentuan yang ada',
                                style: aTermStyle,
                              )
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(
                            width: 200,
                            height: 50,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: aAccentColor),
                              onPressed: !_checkedVal
                                  ? null
                                  : () async {
                                      if (_checkedVal == true) {
                                        var req = await Provider.of<AuthSystem>(
                                                context,
                                                listen: false)
                                            .createUser(
                                                name: nameController.text,
                                                phone: phoneController.text,
                                                pwd: pwdController.text);
                                        req == null
                                            ? print('gagal daftar')
                                            : Get.toNamed('/home');
                                      }
                                    },
                              child: Text(
                                'Daftar',
                                style: aLightStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
