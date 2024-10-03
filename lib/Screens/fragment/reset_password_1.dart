import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../Dialogs/action_dialog.dart';
import '../../Providers/forget_password_provider.dart';
import '../../Storage/shared_preference.dart';
import '../../Utilits/colors.dart';
import '../../Widgets/weevo_button.dart';
import '../../router/router.dart';

class ResetPassword1 extends StatefulWidget {
  const ResetPassword1({super.key});

  @override
  State<ResetPassword1> createState() => _ResetPassword1State();
}

class _ResetPassword1State extends State<ResetPassword1> {
  String? currentCode;

  @override
  Widget build(BuildContext context) {
    final forget = ForgetPasswordProvider.get(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  'من فضلك ادخل الكود المكون من 6 ارقام',
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      forget.phoneNumberController.text,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                PinFieldAutoFill(
                  controller: forget.pinController,
                  decoration: UnderlineDecoration(
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.black),
                    colorBuilder:
                        FixedColorBuilder(Colors.black.withOpacity(0.3)),
                  ),
                  currentCode: currentCode,
                  onCodeSubmitted: (code) {
                    log('code submitted -> $code');
                  },
                  onCodeChanged: (code) {
                    currentCode = code;
                    if (code?.length == 6) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "يمكنك أعادة الأرسال في غضون",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const TextSpan(
                    text: " ",
                  ),
                  TextSpan(
                    text: forget.format(Duration(seconds: forget.start)),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              )),
          forget.wait
              ? Container()
              : SizedBox(
                  height: 20.h,
                ),
          forget.wait
              ? Container()
              : WeevoButton(
                  isStable: true,
                  color: weevoPrimaryOrangeColor,
                  title: 'أعادة أرسال الكود',
                  onTap: () async {
                    forget.resendOtp();
                  },
                ),
          SizedBox(
            height: 20.h,
          ),
          WeevoButton(
            isStable: true,
            color: weevoPrimaryOrangeColor,
            title: 'استمرار',
            onTap: () async {
              if (forget.pinController.text.length == 6) {
                forget.checkOtp();
              } else {
                forget.pinController.clear();
                showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (_) => ActionDialog(
                          content: 'من فضلك أدخل الكود المكون من 6 أرقام',
                          approveAction: 'حسناً',
                          onApproveClick: () {
                            MagicRouter.pop();
                          },
                        ));
              }
            },
          ),
        ],
      ),
    );
  }
}
