import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Dialogs/action_dialog.dart';
import '../Utilits/colors.dart';
import '../Widgets/connectivity_widget.dart';
import '../Widgets/weevo_button.dart';
import 'login.dart';
import 'sign_up.dart';

class BeforeRegistration extends StatefulWidget {
  static const String id = 'BEFORE_REGISTRATION';

  const BeforeRegistration({super.key});

  @override
  State<BeforeRegistration> createState() => _BeforeRegistrationState();
}

class _BeforeRegistrationState extends State<BeforeRegistration> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => ActionDialog(
            title: 'الخروج من التطبيق',
            content: 'هل تود الخروج من التطبيق',
            approveAction: 'نعم',
            cancelAction: 'لا',
            onApproveClick: () {
              Navigator.pop(context);
              SystemNavigator.pop();
            },
            onCancelClick: () {
              Navigator.pop(context);
            },
          ),
        );
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ConnectivityWidget(
          callback: () {},
          child: Scaffold(
            backgroundColor: weevoPrimaryOrangeColorWithOpacity,
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/intro_background.jpg'),
                    fit: BoxFit.fill),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/res_and_log_icon.png',
                                  height: 50.h,
                                ),
                                SizedBox(
                                  width: 20.0.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'أهلاً بيك في ويفو',
                                      style: TextStyle(
                                          fontSize: 30.0.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'يمكنك الاستخدام الان',
                                      style: TextStyle(
                                          fontSize: 16.0.sp,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: WeevoButton(
                              isStable: true,
                              color: weevoPrimaryOrangeColor,
                              title: 'تسجيل الدخول',
                              onTap: () {
                                Navigator.pushNamed(context, Login.id);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: WeevoButton(
                              isStable: false,
                              color: Colors.white,
                              title: 'انشاء حساب',
                              onTap: () {
                                Navigator.pushNamed(context, SignUp.id);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      TextButton(
                        onPressed: () async {
                          await launchUrlString(
                              'https://play.google.com/store/apps/details?id=org.emarketingo.weevo');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لو انت تاجر حمل',
                              style: TextStyle(
                                  fontSize: 16.0.sp, color: Colors.white),
                            ),
                            Text(
                              ' تطبيق التاجر',
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  color: weevoPrimaryOrangeColor),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
