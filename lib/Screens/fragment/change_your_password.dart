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

class ChangeYourPassword extends StatefulWidget {
  static const String id = 'Change Password';

  const ChangeYourPassword({super.key});

  @override
  State<ChangeYourPassword> createState() => _ChangeYourPasswordState();
}

class _ChangeYourPasswordState extends State<ChangeYourPassword> {
  late FocusNode _yourCurrentPasswordNode,
      _yourNewPasswordNode,
      _retypeYourNewPasswordNode;
  late TextEditingController _yourNewPasswordController,
      _retypeYourNewPasswordController,
      _yourCurrentPasswordController;
  bool _yourNewPasswordFocused = false;
  bool _retypeYourNewPasswordFocused = false;
  bool _yourCurrentPasswordFocused = false;
  bool _yourNewPasswordEmpty = true;
  bool _retypeYourNewPasswordEmpty = true;
  bool _yourCurrentPasswordEmpty = true;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String? _retypeNewPassword;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _yourCurrentPasswordNode = FocusNode();
    _yourNewPasswordNode = FocusNode();
    _retypeYourNewPasswordNode = FocusNode();
    _yourNewPasswordController = TextEditingController();
    _retypeYourNewPasswordController = TextEditingController();
    _yourCurrentPasswordController = TextEditingController();
    _yourCurrentPasswordNode.addListener(() {
      setState(() {
        _yourCurrentPasswordFocused = _yourCurrentPasswordNode.hasFocus;
      });
    });
    _yourNewPasswordNode.addListener(() {
      setState(() {
        _yourNewPasswordFocused = _yourNewPasswordNode.hasFocus;
      });
    });
    _retypeYourNewPasswordNode.addListener(() {
      setState(() {
        _retypeYourNewPasswordFocused = _retypeYourNewPasswordNode.hasFocus;
      });
    });
    _yourNewPasswordEmpty = _yourNewPasswordController.text.isEmpty;
    _retypeYourNewPasswordEmpty = _retypeYourNewPasswordController.text.isEmpty;
    _yourCurrentPasswordEmpty = _yourCurrentPasswordController.text.isEmpty;
  }

  @override
  void dispose() {
    _yourCurrentPasswordNode.dispose();
    _yourNewPasswordNode.dispose();
    _retypeYourNewPasswordNode.dispose();
    _yourNewPasswordController.dispose();
    _retypeYourNewPasswordController.dispose();
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
              'تغير كلمة المرور',
            ),
          ),
          body: LoadingWidget(
            isLoading: authProvider.updatePasswordState == NetworkState.waiting,
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
                      child: Column(
                        children: [
                          EditText(
                            readOnly: false,
                            controller: _yourCurrentPasswordController,
                            upperTitle: true,
                            onChange: (String? value) {
                              isButtonPressed = false;
                              if (isError) {
                                formState.currentState!.validate();
                              }
                              setState(() {
                                _yourCurrentPasswordEmpty = value!.isEmpty;
                              });
                            },
                            shouldDisappear: !_yourCurrentPasswordEmpty &&
                                !_yourCurrentPasswordFocused,
                            action: TextInputAction.done,
                            onFieldSubmit: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_yourNewPasswordNode);
                            },
                            type: TextInputType.emailAddress,
                            isPhoneNumber: false,
                            isPassword: true,
                            isFocus: _yourCurrentPasswordFocused,
                            focusNode: _yourCurrentPasswordNode,
                            validator: (String? output) {
                              if (!isButtonPressed) {
                                return null;
                              }
                              isError = true;
                              if (output!.length < 6 ||
                                  output != authProvider.password) {
                                return passwordValidatorMessage;
                              }
                              isError = false;
                              return null;
                            },
                            onSave: (String? saved) {},
                            labelText: 'كلمة المرور الحالية',
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          EditText(
                            readOnly: false,
                            controller: _yourNewPasswordController,
                            upperTitle: true,
                            onChange: (String? value) {
                              isButtonPressed = false;
                              if (isError) {
                                formState.currentState!.validate();
                              }
                              setState(() {
                                _yourNewPasswordEmpty = value!.isEmpty;
                              });
                            },
                            shouldDisappear: !_yourNewPasswordEmpty &&
                                !_yourNewPasswordFocused,
                            action: TextInputAction.done,
                            onFieldSubmit: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_retypeYourNewPasswordNode);
                            },
                            type: TextInputType.visiblePassword,
                            isPhoneNumber: false,
                            isPassword: true,
                            isFocus: _yourNewPasswordFocused,
                            focusNode: _yourNewPasswordNode,
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
                            onSave: (String? saved) {},
                            labelText: 'كلمة المرور الجديدة',
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          EditText(
                            readOnly: false,
                            controller: _retypeYourNewPasswordController,
                            upperTitle: true,
                            onChange: (String? value) {
                              isButtonPressed = false;
                              if (isError) {
                                formState.currentState!.validate();
                              }
                              setState(() {
                                _retypeYourNewPasswordEmpty = value!.isEmpty;
                              });
                            },
                            shouldDisappear: !_retypeYourNewPasswordEmpty &&
                                !_retypeYourNewPasswordFocused,
                            action: TextInputAction.done,
                            onFieldSubmit: (_) {
                              _retypeYourNewPasswordNode.unfocus();
                            },
                            type: TextInputType.visiblePassword,
                            isPhoneNumber: false,
                            isPassword: true,
                            isFocus: _retypeYourNewPasswordFocused,
                            focusNode: _retypeYourNewPasswordNode,
                            validator: (String? output) {
                              if (!isButtonPressed) {
                                return null;
                              }
                              isError = true;
                              if (output!.length < 6 ||
                                  output != _yourNewPasswordController.text) {
                                return passwordValidatorMessage;
                              }
                              isError = false;
                              return null;
                            },
                            onSave: (String? saved) {
                              _retypeNewPassword = saved;
                            },
                            labelText: 'اعد كتابة كلمة المرور الجديدة',
                          ),
                        ],
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
                          await authProvider.updatePassword(
                            password: _retypeNewPassword,
                            currentPassword: authProvider.password,
                          );
                          if (authProvider.updatePasswordState ==
                              NetworkState.success) {
                            showDialog(
                              context: navigator.currentContext!,
                              builder: (context) => ActionDialog(
                                content: 'تم تغيير كلمة السر بنجاح',
                                onCancelClick: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                cancelAction: 'حسناً',
                              ),
                            );
                          } else if (authProvider.updatePasswordState ==
                              NetworkState.logout) {
                            check(
                                ctx: navigator.currentContext!,
                                auth: authProvider,
                                state: authProvider.updatePasswordState!);
                          } else if (authProvider.updatePasswordState ==
                              NetworkState.error) {
                            if (authProvider.currentPasswordIsIncorrect!) {
                              showDialog(
                                  context: navigator.currentContext!,
                                  barrierDismissible: false,
                                  builder: (context) => ActionDialog(
                                        content: 'كلمة السر الحالية غير صحيحة',
                                        cancelAction: 'حسناً',
                                        onCancelClick: () {
                                          Navigator.pop(context);
                                        },
                                      ));
                            } else {
                              showDialog(
                                  context: navigator.currentContext!,
                                  barrierDismissible: false,
                                  builder: (context) => ActionDialog(
                                        content:
                                            'حدث خطأ من فضلك حاول مرة اخري',
                                        cancelAction: 'حسناً',
                                        onCancelClick: () {
                                          Navigator.pop(context);
                                        },
                                      ));
                            }
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
