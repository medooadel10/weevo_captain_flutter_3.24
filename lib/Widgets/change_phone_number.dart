import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Providers/profile_provider.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import 'edit_text.dart';
import 'weevo_button.dart';

class ChangePhoneNumber extends StatefulWidget {
  const ChangePhoneNumber({super.key});

  @override
  State<ChangePhoneNumber> createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isError = false;
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    final profile = ProfileProvider.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: formState,
              child: Column(
                children: [
                  EditText(
                    readOnly: false,
                    controller: profile.phoneNumberController,
                    upperTitle: true,
                    onChange: (String? value) {
                      isButtonPressed = false;
                      if (isError) {
                        formState.currentState!.validate();
                      }
                    },
                    action: TextInputAction.done,
                    onFieldSubmit: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    type: TextInputType.phone,
                    isPhoneNumber: true,
                    isPassword: false,
                    validator: (String? output) {
                      if (!isButtonPressed) {
                        return null;
                      }
                      isError = true;
                      if (output!.length < 11) {
                        return phoneValidatorMessage;
                      }
                      isError = false;
                      return null;
                    },
                    labelText: 'رقم الهاتف الجديد',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            WeevoButton(
              isStable: true,
              color: weevoPrimaryOrangeColor,
              onTap: () async {
                isButtonPressed = true;
                if (formState.currentState!.validate()) {
                  profile.sendOtp();
                }
              },
              title: 'تغيير',
            ),
          ],
        ),
      ),
    );
  }
}
