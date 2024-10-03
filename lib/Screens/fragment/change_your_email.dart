import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Dialogs/action_dialog.dart';
import '../../Providers/auth_provider.dart';
import '../../Storage/shared_preference.dart';
import '../../Utilits/colors.dart';
import '../../Utilits/constants.dart';
import '../../Widgets/connectivity_widget.dart';
import '../../Widgets/edit_text.dart';
import '../../Widgets/loading_widget.dart';
import '../../Widgets/weevo_button.dart';

class ChangeYourEmail extends StatefulWidget {
  static const String id = 'Change Your Email';

  const ChangeYourEmail({super.key});

  @override
  State<ChangeYourEmail> createState() => _ChangeYourEmailState();
}

class _ChangeYourEmailState extends State<ChangeYourEmail> {
  late FocusNode _yourNewEmailNode, _retypeYourEmailNode, _yourOldEmailNode;
  late TextEditingController _yourNewEmailController,
      _retypeYourEmailController,
      _yourOldEmailController;
  bool _yourNewEmailFocused = false;
  bool _retypeYourEmailFocused = false;
  bool _yourOldEmailFocused = false;
  bool _yourNewEmailEmpty = true;
  bool _retypeYourEmailEmpty = true;
  bool _yourOldEmailEmpty = true;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String? newEmail, retypeNewEmail;
  bool isError = false;
  bool isButtonPressed = false;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _yourNewEmailNode = FocusNode();
    _retypeYourEmailNode = FocusNode();
    _yourOldEmailNode = FocusNode();
    _yourNewEmailController = TextEditingController();
    _retypeYourEmailController = TextEditingController();
    _yourOldEmailController = TextEditingController();
    _yourNewEmailNode.addListener(() {
      setState(() {
        _yourNewEmailFocused = _yourNewEmailNode.hasFocus;
      });
    });
    _retypeYourEmailNode.addListener(() {
      setState(() {
        _retypeYourEmailFocused = _retypeYourEmailNode.hasFocus;
      });
    });
    _yourOldEmailNode.addListener(() {
      setState(() {
        _yourOldEmailFocused = _yourOldEmailNode.hasFocus;
      });
    });
    _yourOldEmailController.text = _authProvider.email ?? '';
    _yourNewEmailEmpty = _yourNewEmailController.text.isEmpty;
    _retypeYourEmailEmpty = _retypeYourEmailController.text.isEmpty;
    _yourOldEmailEmpty = _yourOldEmailController.text.isEmpty;
  }

  @override
  void dispose() {
    _yourOldEmailNode.dispose();
    _yourNewEmailNode.dispose();
    _retypeYourEmailNode.dispose();
    _retypeYourEmailController.dispose();
    _yourNewEmailController.dispose();
    _yourOldEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ConnectivityWidget(
        callback: () {},
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
              ),
            ),
            title: const Text(
              'تغيير البريد الالكتروني',
            ),
          ),
          body: LoadingWidget(
            isLoading: authProvider.updateEmailState == NetworkState.waiting,
            child: Directionality(
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
                      child: AutofillGroup(
                        child: Column(
                          children: [
                            EditText(
                              readOnly: true,
                              controller: _yourOldEmailController,
                              upperTitle: true,
                              shouldDisappear:
                                  !_yourOldEmailEmpty && !_yourOldEmailFocused,
                              action: TextInputAction.done,
                              type: TextInputType.visiblePassword,
                              isPhoneNumber: false,
                              isPassword: false,
                              isFocus: _yourOldEmailFocused,
                              focusNode: _yourOldEmailNode,
                              labelText: 'البريد الالكتروني الحالي',
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            EditText(
                              autofillHints: const [AutofillHints.email],
                              readOnly: false,
                              controller: _yourNewEmailController,
                              upperTitle: true,
                              onChange: (String? value) {
                                isButtonPressed = false;
                                if (isError) {
                                  formState.currentState!.validate();
                                }
                                setState(() {
                                  _yourNewEmailEmpty = value!.isEmpty;
                                });
                              },
                              shouldDisappear:
                                  !_yourNewEmailEmpty && !_yourNewEmailFocused,
                              action: TextInputAction.done,
                              onFieldSubmit: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_retypeYourEmailNode);
                              },
                              type: TextInputType.emailAddress,
                              isPhoneNumber: false,
                              isPassword: false,
                              isFocus: _yourNewEmailFocused,
                              focusNode: _yourNewEmailNode,
                              validator: (String? output) {
                                if (!isButtonPressed) {
                                  return null;
                                }
                                isError = true;
                                if (!validateUserEmail(output!)) {
                                  return emailValidatorMessage;
                                }
                                isError = false;
                                return null;
                              },
                              onSave: (String? saved) {
                                newEmail = saved;
                              },
                              labelText: 'البريد الالكتروني الجديد',
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            EditText(
                              autofillHints: const [AutofillHints.email],
                              readOnly: false,
                              controller: _retypeYourEmailController,
                              upperTitle: true,
                              onChange: (String? value) {
                                isButtonPressed = false;
                                if (isError) {
                                  formState.currentState!.validate();
                                }
                                setState(() {
                                  _retypeYourEmailEmpty = value!.isEmpty;
                                });
                              },
                              shouldDisappear: !_retypeYourEmailEmpty &&
                                  !_retypeYourEmailFocused,
                              action: TextInputAction.done,
                              onFieldSubmit: (_) {
                                FocusScope.of(context).unfocus();
                              },
                              type: TextInputType.emailAddress,
                              isPhoneNumber: false,
                              isPassword: false,
                              isFocus: _retypeYourEmailFocused,
                              focusNode: _retypeYourEmailNode,
                              validator: (String? output) {
                                if (!isButtonPressed) {
                                  return null;
                                }
                                isError = true;
                                if (!validateUserEmail(output!)) {
                                  return emailValidatorMessage;
                                } else if (output !=
                                    _yourNewEmailController.text) {
                                  return emailCheckValidatorMessage;
                                }
                                isError = false;
                                return null;
                              },
                              onSave: (String? saved) {
                                retypeNewEmail = saved;
                              },
                              labelText: 'اعد كتابة البريد الالكتروني الجديد',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    WeevoButton(
                      isStable: true,
                      color: weevoPrimaryOrangeColor,
                      onTap: () async {
                        isButtonPressed = true;
                        if (formState.currentState!.validate()) {
                          formState.currentState!.save();
                          await authProvider.updateEmail(
                            newEmail: retypeNewEmail,
                          );
                          if (authProvider.updateEmailState ==
                              NetworkState.success) {
                            showDialog(
                              context: navigator.currentContext!,
                              barrierDismissible: false,
                              builder: (context) => ActionDialog(
                                content: 'تم تغيير البريد الالكتروني بنجاح',
                                onCancelClick: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                cancelAction: 'حسناً',
                              ),
                            );
                          } else if (authProvider.updateEmailState ==
                              NetworkState.logout) {
                            check(
                                ctx: navigator.currentContext!,
                                auth: authProvider,
                                state: authProvider.updateEmailState!);
                          } else if (authProvider.updateEmailState ==
                              NetworkState.error) {
                            showDialog(
                                context: navigator.currentContext!,
                                barrierDismissible: false,
                                builder: (context) => ActionDialog(
                                      content: 'حدث خطأ من فضلك حاول مرة اخري',
                                      cancelAction: 'حسناً',
                                      onCancelClick: () {
                                        Navigator.pop(context);
                                      },
                                    ));
                          }
                        }
                      },
                      title: 'تغيير',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
