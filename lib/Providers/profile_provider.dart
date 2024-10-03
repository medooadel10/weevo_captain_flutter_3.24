import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../Dialogs/action_dialog.dart';
import '../Models/check_otp_model.dart';
import '../Storage/shared_preference.dart';
import '../Widgets/change_phone_number.dart';
import '../Widgets/loading_dialog.dart';
import '../Widgets/verify_new_number.dart';
import '../core/httpHelper/http_helper.dart';
import '../router/router.dart';

class ProfileProvider with ChangeNotifier {
  static ProfileProvider get(BuildContext context) =>
      Provider.of<ProfileProvider>(context);

  static ProfileProvider listenFalse(BuildContext context) =>
      Provider.of<ProfileProvider>(context, listen: false);
  int _currentIndex = 0;
  Widget _widget = const ChangePhoneNumber();
  int start = 120;
  bool wait = false;
  final Preferences preferences = Preferences.instance;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  Widget get widget => _widget;

  void setCurrentIndex(int i) {
    _currentIndex = i;
    getCurrentPage();
    notifyListeners();
  }

  int get currentIndex => _currentIndex;

  void getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        _widget = const ChangePhoneNumber();
        break;
      case 1:
        _widget = const VerifyNewNumber();
        break;
    }
  }

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

  Future<void> resendOtp() async {
    try {
      showDialog(
          context: navigator.currentContext!,
          builder: (_) => const LoadingDialog());
      Response r =
          await HttpHelper.instance.httpPost('sendPhoneOtp', true, body: {
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

  Future<void> changePhoneNumber() async {
    try {
      Response r =
          await HttpHelper.instance.httpPost('changePhone', true, body: {
        "user_id": checkOtpModel?.userId,
        "phone": phoneNumberController.text,
        "otp": otp,
      });
      if (r.statusCode >= 200 && r.statusCode < 300) {
        preferences.setPhoneNumber(phoneNumberController.text);
        phoneNumberController.clear();
        MagicRouter.pop();
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: 'تم تغيير رقم الهاتف بنجاح',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    MagicRouter.pop();
                    setCurrentIndex(0);
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
      Response r =
          await HttpHelper.instance.httpPost('checkPhoneOtp', true, body: {
        "otp": otp,
      });
      if (r.statusCode >= 200 && r.statusCode < 300) {
        checkOtpModel = CheckOtpModel.fromJson(json.decode(r.body));
        changePhoneNumber();
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
      Response r =
          await HttpHelper.instance.httpPost('sendPhoneOtp', true, body: {
        "phone": phoneNumberController.text,
      });
      if (r.statusCode >= 200 && r.statusCode < 300) {
        MagicRouter.pop();
        resendReset();
        startTimer();
        setCurrentIndex(1);
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
