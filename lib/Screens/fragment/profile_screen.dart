import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Utilits/colors.dart';
import 'change_your_email.dart';
import 'change_your_password.dart';
import 'change_your_phone_number.dart';
import 'profile_information.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'Profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isOn = false;
  final List<String> _items = ['العربية', 'الانجليزية'];
  String? _value;
  final _listOfOptions = <String>[
    'معلومات الحساب',
    'تغيير البريد الالكتروني',
    'تغيير رقم الهاتف',
    'تغيير كلمة السر',
  ];

  @override
  void initState() {
    super.initState();
    _value = _items[0];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: weevoLightSilver,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 45.0,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 43.0,
                      backgroundImage: AssetImage(
                        'assets/images/profile.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  Column(
                    children: [
                      Text(
                        'محمد سيد',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24.0.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              color: weevoLightYellow,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          Text(
                            '4.5',
                            style: TextStyle(
                              color: weevoLightYellow,
                              fontSize: 17.0.sp,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            SizedBox(
              height: size.height * 0.12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      color: weevoDarkGreyColor,
                      borderRadius: BorderRadius.circular(
                        15.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '3250',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0.sp,
                          ),
                        ),
                        Text(
                          'عدد الشحنات',
                          style:
                              TextStyle(fontSize: 18.0.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Container(
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      color: weevoDarkGreyColor,
                      borderRadius: BorderRadius.circular(
                        15.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '2.5',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0.sp,
                          ),
                        ),
                        Text(
                          'سنوات',
                          style:
                              TextStyle(fontSize: 18.0.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _listOfOptions
                            .map(
                              (e) => ListTile(
                                onTap: () {
                                  switch (_listOfOptions.indexOf(e)) {
                                    case 0:
                                      Navigator.pushNamed(
                                          context, ProfileInformation.id);
                                      break;
                                    case 1:
                                      Navigator.pushNamed(
                                          context, ChangeYourEmail.id);
                                      break;
                                    case 2:
                                      Navigator.pushNamed(
                                          context, ChangeYourPhone.id);
                                      break;
                                    case 3:
                                      Navigator.pushNamed(
                                          context, ChangeYourPassword.id);
                                      break;
                                  }
                                },
                                title: Text(
                                  e,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 18.0.sp,
                                  ),
                                ),
                                leading: const Icon(
                                  Icons.arrow_back_ios_outlined,
                                  size: 20.0,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0,
                    ),
                    child: ListTile(
                      leading: Switch(
                        activeColor: weevoPrimaryOrangeColor,
                        value: _isOn,
                        onChanged: (bool value) {
                          setState(() {
                            _isOn = value;
                          });
                        },
                      ),
                      title: Text(
                        'الاشعارات',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 18.0.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0,
                    ),
                    child: ListTile(
                      leading: DropdownButton<String>(
                        underline: Container(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: weevoPrimaryOrangeColor,
                          size: 26.0,
                        ),
                        style: const TextStyle(
                          color: weevoPrimaryOrangeColor,
                          fontSize: 16.0,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _value = value;
                          });
                        },
                        items: _items
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        value: _value,
                      ),
                      title: const Text(
                        'اللغة',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
