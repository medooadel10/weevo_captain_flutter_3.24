import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../Dialogs/action_dialog.dart';
import '../Models/check_otp_model.dart';
import '../Screens/fragment/reset_password_0.dart';
import '../Screens/fragment/reset_password_1.dart';
import '../Screens/fragment/reset_password_2.dart';
import '../Storage/shared_preference.dart';
import '../Widgets/loading_dialog.dart';
import '../core/httpHelper/http_helper.dart';
import '../router/router.dart';

class ForgetPasswordProvider with ChangeNotifier {
  static ForgetPasswordProvider get(BuildContext context) =>
      Provider.of<ForgetPasswordProvider>(context);

  static ForgetPasswordProvider listenFalse(BuildContext context) =>
      Provider.of<ForgetPasswordProvider>(context, listen: false);

  int resetPasswordIndex = 0;
  Widget resetPasswordWidget = const ResetPassword0();
  int start = 120;
  bool wait = false;
  final Preferences preferences = Preferences.instance;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  void startTimer() {
    const onsec = Duration(seconds: 1);
    wait = true;
    Timer.periodic(onsec, (timer) {
      if (start == 0) {
        timer.cancel();
        wait = false;
      } else {
        start--;
      }
      notifyListeners();
    });
  }

  String? otp;
  CheckOtpModel? checkOtpModel;

  void updateResetPasswordScreen(int i) {
    resetPasswordIndex = i;
    getCurrentResetPasswordWidget(i);
    notifyListeners();
  }

  void getCurrentResetPasswordWidget(int i) {
    switch (i) {
      case 0:
        resetPasswordWidget = const ResetPassword0();
        break;
      case 1:
        resetPasswordWidget = const ResetPassword1();
        break;
      case 2:
        resetPasswordWidget = const ResetPassword2();
        break;
    }
  }

  Future<void> resendOtp() async {
    try {
      showDialog(
          context: navigator.currentContext!,
          builder: (_) => const LoadingDialog());
      Response r = await HttpHelper.instance.httpPost('sendOtp', false, body: {
        "phone": phoneNumberController.text,
      });
      if (r.statusCode >= 200 && r.statusCode < 300) {
        MagicRouter.pop();
        resendReset();
        startTimer();
      } else {
        MagicRouter.pop();
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: '${json.decode(r.body)['message']}',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    MagicRouter.pop();
                  },
                ));
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
  }

  Future<void> changePassword() async {
    try {
      showDialog(
          context: navigator.currentContext!,
          builder: (_) => const LoadingDialog());
      Response r =
          await HttpHelper.instance.httpPost('resetPassword', false, body: {
        "user_id": checkOtpModel?.userId,
        "password": confirmPasswordController.text,
        "otp": otp,
      });
      if (r.statusCode >= 200 && r.statusCode < 300) {
        phoneNumberController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        MagicRouter.pop();
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: 'تم تغيير كلمة المرور بنجاح',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    MagicRouter.pop();
                    updateResetPasswordScreen(0);
                    MagicRouter.pop();
                  },
                ));
      } else {
        MagicRouter.pop();
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: '${json.decode(r.body)['message']}',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    MagicRouter.pop();
                  },
                ));
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
  }

  Future<void> checkOtp() async {
    try {
      showDialog(
          context: navigator.currentContext!,
          builder: (_) => const LoadingDialog());
      otp = pinController.text;
      pinController.clear();
      Response r = await HttpHelper.instance.httpPost('checkOtp', false, body: {
        "otp": otp,
      });
      if (r.statusCode >= 200 && r.statusCode < 300) {
        checkOtpModel = CheckOtpModel.fromJson(json.decode(r.body));
        MagicRouter.pop();
        updateResetPasswordScreen(2);
      } else {
        MagicRouter.pop();
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: '${json.decode(r.body)['message']}',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    Navigator.pop(navigator.currentContext!);
                  },
                ));
      }
    } catch (e) {
      log('error from create user -> ${e.toString()}');
    }
  }

  Future<void> sendOtp() async {
    try {
      showDialog(
          context: navigator.currentContext!,
          builder: (_) => const LoadingDialog());
      Response r = await HttpHelper.instance.httpPost('sendOtp', false, body: {
        "phone": phoneNumberController.text,
      });
      if (r.statusCode >= 200 && r.statusCode < 300) {
        MagicRouter.pop();
        resendReset();
        startTimer();
        updateResetPasswordScreen(1);
      } else {
        MagicRouter.pop();
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: '${json.decode(r.body)['message']}',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    Navigator.pop(navigator.currentContext!);
                  },
                ));
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
  }

  void resendReset() {
    start = 120;
    wait = true;
    notifyListeners();
  }

  format(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0").substring(3, 8);
}
