import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../Utilits/colors.dart';
import '../Dialogs/action_dialog.dart';
import '../Providers/profile_provider.dart';
import '../Utilits/constants.dart';
import 'weevo_button.dart';

class VerifyNewNumber extends StatefulWidget {
  const VerifyNewNumber({super.key});

  @override
  State<VerifyNewNumber> createState() => _VerifyNewNumberState();
}

class _VerifyNewNumberState extends State<VerifyNewNumber> {
  String? currentCode;

  @override
  Widget build(BuildContext context) {
    final profile = ProfileProvider.get(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'من فضلك ادخل الكود المكون من 6 ارقام',
            style: TextStyle(color: Colors.grey, fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          hSpace(20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile.phoneNumberController.text,
                style: const TextStyle(color: Colors.grey, fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          hSpace(20.h),
          PinFieldAutoFill(
            controller: profile.pinController,
            decoration: UnderlineDecoration(
              textStyle: const TextStyle(fontSize: 20, color: Colors.black),
              colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
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
                    text: profile.format(Duration(seconds: profile.start)),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              )),
          profile.wait
              ? Container()
              : SizedBox(
                  height: 20.h,
                ),
          profile.wait
              ? Container()
              : WeevoButton(
                  isStable: true,
                  color: weevoPrimaryOrangeColor,
                  title: 'أعادة أرسال الكود',
                  onTap: () async {
                    await profile.resendOtp();
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
              if (profile.pinController.text.length == 6) {
                profile.checkOtp();
              } else {
                profile.pinController.clear();
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ActionDialog(
                          content: 'من فضلك أدخل الكود المكون من 6 أرقام',
                          approveAction: 'حسناً',
                          onApproveClick: () {
                            Navigator.pop(context);
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
