import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weevo_captain_app/Screens/onboarding.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';
import 'package:weevo_captain_app/core/router/router.dart';

import '../Dialogs/action_dialog.dart';
import '../Providers/auth_provider.dart';
import '../Utilits/constants.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  static const String id = 'Splash';

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late AuthProvider _authProvider;
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));
    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    initMain();
    // testMethod();
  }

  @override
  void dispose() {
    if (!_authProvider.isValid) {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.white));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            'assets/images/weevo_splash_screen_icon.gif',
            width: size.width,
            height: size.height,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  packageInfo != null
                      ? 'رقم الأصدار ${packageInfo?.version}'
                      : '',
                  style: TextStyle(fontSize: 14.0.sp, color: Colors.black),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void initMain() async {
    if (await _authProvider.checkConnection()) {
      await _authProvider.getCurrentUserdata(false);

      packageInfo = await PackageInfo.fromPlatform();
      setState(() {});
      await _authProvider.courierUpdate(packageInfo?.version);

      if (_authProvider.courierCriticalUpdateState == NetworkState.success) {
        if (_authProvider.courierCriticalUpdate?.shouldUpdate ?? false) {
          showDialog(
            context: navigator.currentContext!,
            barrierDismissible: false,
            builder: (ctx) => ActionDialog(
              content: 'عليك تحديث الاصدار الحالي',
              cancelAction: 'الخروج',
              approveAction: 'تحديث',
              onApproveClick: () async {
                Navigator.pop(context);
                try {
                  launchUrlString(
                      "https://play.google.com/store/apps/details?id=${packageInfo?.packageName}");
                } on PlatformException {
                  launchUrlString(
                      "https://play.google.com/store/apps/details?id=${packageInfo?.packageName}");
                } finally {
                  launchUrlString(
                      "https://play.google.com/store/apps/details?id=${packageInfo?.packageName}");
                }
              },
              onCancelClick: () {
                log('cancel click');
                MagicRouter.pop();
              },
            ),
          );
        } else {
          await _authProvider.getInitMessage();
          if (Preferences.instance.getAccessToken.isEmpty) {
            MagicRouter.navigateAndPopAll(const OnBoarding());
          } else {
            MagicRouter.navigateAndPopAll(const Home());
          }
        }
      } else if (_authProvider.courierCriticalUpdateState ==
          NetworkState.error) {
        showDialog(
          context: navigator.currentContext!,
          barrierDismissible: false,
          builder: (ctx) => ActionDialog(
            content: 'تأكد من الاتصال بشبكة الانترنت',
            cancelAction: 'حسناً',
            approveAction: 'حاول مرة اخري',
            onApproveClick: () async {
              Navigator.pop(context);
            },
            onCancelClick: () {
              Navigator.pop(context);
            },
          ),
        );
      }
    } else {
      showDialog(
        context: navigator.currentContext!,
        barrierDismissible: false,
        builder: (ctx) => ActionDialog(
          content: 'تأكد من الاتصال بشبكة الانترنت',
          cancelAction: 'حسناً',
          approveAction: 'حاول مرة اخري',
          onApproveClick: () async {
            Navigator.pop(context);
          },
          onCancelClick: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  // void testMethod() async {
  //   if (await _authProvider.checkConnection()) {
  //     await _authProvider.getCurrentUserdata(false);

  //     packageInfo = await PackageInfo.fromPlatform();
  //     setState(() {});
  //     await _authProvider.courierUpdate(packageInfo?.version);

  //     if (_authProvider.courierCriticalUpdateState == NetworkState.success) {
  //       if (_authProvider.courierCriticalUpdate?.shouldUpdate ?? false) {
  //         showDialog(
  //           context: navigator.currentContext!,
  //           barrierDismissible: false,
  //           builder: (ctx) => ActionDialog(
  //             content: 'عليك تحديث الاصدار الحالي',
  //             cancelAction: 'الخروج',
  //             approveAction: 'تحديث',
  //             onApproveClick: () async {
  //               Navigator.pop(context);
  //               try {
  //                 launchUrlString(
  //                     "https://play.google.com/store/apps/details?id=${packageInfo?.packageName}");
  //               } on PlatformException {
  //                 launchUrlString(
  //                     "https://play.google.com/store/apps/details?id=${packageInfo?.packageName}");
  //               } finally {
  //                 launchUrlString(
  //                     "https://play.google.com/store/apps/details?id=${packageInfo?.packageName}");
  //               }
  //             },
  //             onCancelClick: () {
  //               SystemNavigator.pop();
  //             },
  //           ),
  //         );
  //       } else {
  //         await _authProvider.getInitMessage();
  //         _authProvider.setAppVersion(appVersion: packageInfo?.version);
  //       }
  //     } else if (_authProvider.courierCriticalUpdateState ==
  //         NetworkState.error) {
  //       showDialog(
  //         context: navigator.currentContext!,
  //         barrierDismissible: false,
  //         builder: (ctx) => ActionDialog(
  //           content: 'تأكد من الاتصال بشبكة الانترنت',
  //           cancelAction: 'حسناً',
  //           approveAction: 'حاول مرة اخري',
  //           onApproveClick: () async {
  //             Navigator.pop(context);
  //           },
  //           onCancelClick: () {
  //             Navigator.pop(context);
  //           },
  //         ),
  //       );
  //     }
  //   } else {
  //     showDialog(
  //       context: navigator.currentContext!,
  //       barrierDismissible: false,
  //       builder: (ctx) => ActionDialog(
  //         content: 'تأكد من الاتصال بشبكة الانترنت',
  //         cancelAction: 'حسناً',
  //         approveAction: 'حاول مرة اخري',
  //         onApproveClick: () async {
  //           Navigator.pop(context);
  //         },
  //         onCancelClick: () {
  //           Navigator.pop(context);
  //         },
  //       ),
  //     );
  //   }
  // }
}
