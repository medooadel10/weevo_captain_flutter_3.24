import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dialogs/action_dialog.dart';
import '../Providers/forget_password_provider.dart';
import '../Widgets/connectivity_widget.dart';
import 'login.dart';

class ResetPassword extends StatelessWidget {
  static const String id = 'ResetPassword';

  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final forget = Provider.of<ForgetPasswordProvider>(context);
    final size = MediaQuery.of(context).size;
    return PopScope(
      onPopInvokedWithResult: (value, result) async {
        showDialog(
          context: context,
          builder: (context) => ActionDialog(
            content: 'هل تود الرجوع لصفحة الدخول',
            approveAction: 'نعم',
            cancelAction: 'لا',
            onApproveClick: () {
              forget.updateResetPasswordScreen(0);
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, Login.id);
            },
            onCancelClick: () {
              Navigator.pop(context);
            },
          ),
        );
      },
      canPop: false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ConnectivityWidget(
          callback: () {},
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ActionDialog(
                      content: 'هل تود الرجوع لصفحة الدخول',
                      approveAction: 'نعم',
                      cancelAction: 'لا',
                      onApproveClick: () {
                        forget.updateResetPasswordScreen(0);
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, Login.id);
                      },
                      onCancelClick: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/weevo_blue_logo.png',
                      fit: BoxFit.contain,
                      width: size.width * 0.7,
                    ),
                  ],
                ),
                Expanded(child: forget.resetPasswordWidget),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
