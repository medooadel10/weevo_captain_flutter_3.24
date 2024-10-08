import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Dialogs/action_dialog.dart';
import '../Utilits/colors.dart';
import '../Widgets/connectivity_widget.dart';
import '../Widgets/weevo_button.dart';
import 'home.dart';

class AfterRegistration extends StatefulWidget {
  static const String id = 'AFTER_REGISTRATION';

  const AfterRegistration({super.key});

  @override
  State<AfterRegistration> createState() => _AfterRegistrationState();
}

class _AfterRegistrationState extends State<AfterRegistration> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (value, result) async {
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
      },
      canPop: true,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ConnectivityWidget(
          callback: () {},
          child: Scaffold(
            backgroundColor: weevoPrimaryOrangeColorWithOpacity,
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
                        flex: 5,
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
                      WeevoButton(
                        isStable: true,
                        color: weevoPrimaryOrangeColor,
                        title: 'ابدا الاستخدام الان',
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, Home.id, (route) => false);
                        },
                      ),
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
