import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Providers/forget_password_provider.dart';
import '../../Utilits/colors.dart';
import '../../Utilits/constants.dart';
import '../../Widgets/edit_text.dart';
import '../../Widgets/weevo_button.dart';

class ResetPassword2 extends StatefulWidget {
  const ResetPassword2({super.key});

  @override
  State<ResetPassword2> createState() => _ResetPassword2State();
}

class _ResetPassword2State extends State<ResetPassword2> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isError = false;
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    final forget = ForgetPasswordProvider.get(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'تغيير كلمة السر',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Form(
                key: formState,
                child: Column(
                  children: [
                    EditText(
                      readOnly: false,
                      controller: forget.passwordController,
                      upperTitle: true,
                      action: TextInputAction.next,
                      onChange: (String? value) {
                        isButtonPressed = false;
                        if (isError) {
                          formState.currentState!.validate();
                        }
                      },
                      isPhoneNumber: false,
                      type: TextInputType.visiblePassword,
                      isPassword: true,
                      validator: (String? output) {
                        if (!isButtonPressed) {
                          return null;
                        }
                        isError = true;
                        if (output!.length < 6) {
                          return passwordValidatorMessage;
                        }
                        isError = false;
                        return null;
                      },
                      labelText: 'كلمة السر',
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    EditText(
                      readOnly: false,
                      controller: forget.confirmPasswordController,
                      upperTitle: true,
                      action: TextInputAction.done,
                      onChange: (String? value) {
                        isButtonPressed = false;
                        if (isError) {
                          formState.currentState!.validate();
                        }
                      },
                      isPhoneNumber: false,
                      type: TextInputType.visiblePassword,
                      isPassword: true,
                      validator: (String? output) {
                        if (!isButtonPressed) {
                          return null;
                        }
                        isError = true;
                        if (output!.length < 6 ||
                            output != forget.passwordController.text) {
                          return passwordValidatorMessage;
                        }
                        isError = false;
                        return null;
                      },
                      labelText: 'تأكيد كلمة السر',
                    ),
                  ],
                ),
              ),
            ],
          ),
          WeevoButton(
            isStable: true,
            color: weevoPrimaryOrangeColor,
            onTap: () async {
              isButtonPressed = true;
              if (formState.currentState!.validate()) {
                forget.changePassword();
              }
            },
            title: 'تغيير كلمة السر',
          ),
        ],
      ),
    );
  }
}
