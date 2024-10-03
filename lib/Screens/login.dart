import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/connectivity_widget.dart';
import '../Widgets/edit_text.dart';
import '../Widgets/loading_widget.dart';
import '../Widgets/weevo_button.dart';
import 'after_registration.dart';
import 'reset_password.dart';

class Login extends StatefulWidget {
  static const String id = 'LOGIN';

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  late FocusNode _emailNode, _passwordNode;
  bool _emailFocused = false;
  bool _passwordFocused = false;
  bool _passwordIsEmpty = true;
  bool _emailIsEmpty = true;
  String? _emailAddress, _password;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _emailNode = FocusNode();
    _passwordNode = FocusNode();
    _emailNode.addListener(() {
      setState(() {
        _emailFocused = _emailNode.hasFocus;
      });
    });
    _passwordNode.addListener(() {
      setState(() {
        _passwordFocused = _passwordNode.hasFocus;
      });
    });
    _emailIsEmpty = _emailController.text.isEmpty;
    _passwordIsEmpty = _passController.text.isEmpty;
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ConnectivityWidget(
        callback: () {},
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                color: weevoPrimaryBlueColor,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: LoadingWidget(
            isLoading: authProvider.isLoading,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          SizedBox(
                            height: 20.h,
                          ),
                          const Text(
                            'تسجيل الدخول',
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: AutofillGroup(
                                child: Column(
                                  children: [
                                    EditText(
                                      autofillHints: const [
                                        AutofillHints.email
                                      ],
                                      readOnly: false,
                                      controller: _emailController,
                                      upperTitle: true,
                                      action: TextInputAction.done,
                                      shouldDisappear:
                                          !_emailIsEmpty && !_emailFocused,
                                      onChange: (String? value) {
                                        isButtonPressed = false;
                                        if (isError) {
                                          formState.currentState!.validate();
                                        }
                                        setState(() {
                                          _emailIsEmpty = value!.isEmpty;
                                        });
                                      },
                                      onFieldSubmit: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_passwordNode);
                                      },
                                      isPhoneNumber: false,
                                      type: TextInputType.emailAddress,
                                      isPassword: false,
                                      isFocus: _emailFocused,
                                      focusNode: _emailNode,
                                      validator: (String? output) {
                                        if (!isButtonPressed) {
                                          return null;
                                        }
                                        isError = true;
                                        if (output!.isEmpty) {
                                          return 'من فضلك أدخل البريد الاكتروني او رقم الهاتف';
                                        }
                                        isError = false;
                                        return null;
                                      },
                                      onSave: (String? saved) {
                                        _emailAddress = saved;
                                      },
                                      labelText:
                                          'البريد الالكتروني او رقم الهاتف',
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    EditText(
                                      readOnly: false,
                                      controller: _passController,
                                      upperTitle: true,
                                      action: TextInputAction.done,
                                      shouldDisappear: !_passwordIsEmpty &&
                                          !_passwordFocused,
                                      onChange: (String? value) {
                                        isButtonPressed = false;
                                        if (isError) {
                                          formState.currentState!.validate();
                                        }
                                        setState(() {
                                          _passwordIsEmpty = value!.isEmpty;
                                        });
                                      },
                                      isPhoneNumber: false,
                                      type: TextInputType.visiblePassword,
                                      isPassword: true,
                                      isFocus: _passwordFocused,
                                      focusNode: _passwordNode,
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
                                      onSave: (String? saved) {
                                        _password = saved;
                                      },
                                      labelText: 'كلمة السر',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, ResetPassword.id);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'نسيت كلمة المرور ؟',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  WeevoButton(
                    isStable: true,
                    color: weevoPrimaryOrangeColor,
                    onTap: () async {
                      if (authProvider.test) {
                        Navigator.pushNamed(context, AfterRegistration.id);
                      } else {
                        isButtonPressed = true;
                        if (formState.currentState!.validate()) {
                          formState.currentState!.save();
                          authProvider.setLoading(true);
                          await authProvider.loginUser(
                              email: _emailAddress, password: _password);
                        }
                      }
                    },
                    title: 'تسجيل الدخول',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void clear() {
    _emailController.clear();
    _passController.clear();
    setState(() {
      _emailIsEmpty = _emailController
          .text.isEmpty; // to make labelText installed after method clear
      _passwordIsEmpty = _passController.text.isEmpty;
    });
  }
}
