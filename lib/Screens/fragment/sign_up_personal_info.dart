import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../../Dialogs/action_dialog.dart';
import '../../Dialogs/image_picker_dialog.dart';
import '../../Dialogs/loading.dart';
import '../../Models/image.dart';
import '../../Models/sign_up_data.dart';
import '../../Providers/auth_provider.dart';
import '../../Utilits/colors.dart';
import '../../Utilits/constants.dart';
import '../../Widgets/edit_text.dart';
import '../../Widgets/image_container.dart';
import '../../Widgets/weevo_button.dart';
import '../../Widgets/weevo_checkbox.dart';

class SignUpPersonalInfo extends StatefulWidget {
  final bool? isUpdated;

  const SignUpPersonalInfo({
    super.key,
    this.isUpdated,
  });

  @override
  State<SignUpPersonalInfo> createState() => _SignUpPersonalInfoState();
}

class _SignUpPersonalInfoState extends State<SignUpPersonalInfo> {
  int _imageCounter = 0;
  Img? _img, _oldImage;
  late AuthProvider _authProvider;
  late FocusNode _emailNode,
      _firstNameNode,
      _lastNameNode,
      _phoneNode,
      _passwordNode,
      _nationalIdNumberNode;
  late TextEditingController _emailController,
      _firstNameController,
      _lastNameController,
      _phoneController,
      _passwordController,
      _nationalIdNumberController;
  bool _firstNameFocused = false;
  bool _lastNameFocused = false;
  bool _nationalIdNumberFocused = false;
  bool _emailFocused = false;
  bool _phoneFocused = false;
  bool _passwordFocused = false;
  bool _firstNameIsEmpty = true;
  bool _lastNameIsEmpty = true;
  bool _nationalIdNumberEmpty = false;
  bool _emailIsEmpty = true;
  bool _phoneIsEmpty = true;
  bool _passwordIsEmpty = true;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String? _uploadedImagePath,
      productImage,
      _firstName,
      _lastName,
      _nationalIdNumber,
      _emailAddress,
      _password,
      _phoneNumber;
  bool isError = false;
  bool isButtonPressed = false;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _emailNode = FocusNode();
    _firstNameNode = FocusNode();
    _lastNameNode = FocusNode();
    _phoneNode = FocusNode();
    _passwordNode = FocusNode();
    _nationalIdNumberNode = FocusNode();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _nationalIdNumberController = TextEditingController();
    _phoneController = TextEditingController();
    _emailNode.addListener(() {
      setState(() {
        _emailFocused = _emailNode.hasFocus;
      });
    });
    _nationalIdNumberNode.addListener(() {
      setState(() {
        _nationalIdNumberFocused = _nationalIdNumberNode.hasFocus;
      });
    });
    _passwordNode.addListener(() {
      setState(() {
        _passwordFocused = _passwordNode.hasFocus;
      });
    });
    _phoneNode.addListener(() {
      setState(() {
        _phoneFocused = _phoneNode.hasFocus;
      });
    });
    _firstNameNode.addListener(() {
      setState(() {
        _firstNameFocused = _firstNameNode.hasFocus;
      });
    });
    _lastNameNode.addListener(() {
      setState(() {
        _lastNameFocused = _lastNameNode.hasFocus;
      });
    });
    _phoneController.text = _authProvider.userPhone ?? '';
    _firstNameController.text = _authProvider.firstName ?? '';
    _lastNameController.text = _authProvider.lastName ?? '';
    _emailController.text = _authProvider.userEmail ?? '';
    _passwordController.text = _authProvider.userPassword ?? '';
    _nationalIdNumberController.text = _authProvider.nationalIdNumber ?? '';
    _uploadedImagePath = _authProvider.userPhoto;
    _phoneIsEmpty = _phoneController.text.isEmpty;
    _passwordIsEmpty = _passwordController.text.isEmpty;
    _firstNameIsEmpty = _firstNameController.text.isEmpty;
    _lastNameIsEmpty = _lastNameController.text.isEmpty;
    _emailIsEmpty = _emailController.text.isEmpty;
    _nationalIdNumberEmpty = _nationalIdNumberController.text.isEmpty;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _nationalIdNumberController.dispose();
    _phoneNode.dispose();
    _emailNode.dispose();
    _nationalIdNumberNode.dispose();
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<AuthProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageContainer(
            isLoading: signUpProvider.profileImageLoading,
            imagePath: _uploadedImagePath,
            onImagePressed: () {
              if (_img != null) {
                _oldImage = _img;
              }
              !signUpProvider.profileImageLoading
                  ? showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                            20.0,
                          ),
                          topLeft: Radius.circular(
                            20.0,
                          ),
                        ),
                      ),
                      builder: (_) => ImagePickerDialog(
                            onImageReceived: (XFile imageFile) async {
                              _imageCounter++;
                              Navigator.pop(context);
                              signUpProvider.setImageLoading(true);
                              File? compressedImage =
                                  await compressFile(imageFile.path);
                              if (compressedImage == null) return;

                              if (_imageCounter > 1) {
                                await signUpProvider.deletePhoto(
                                  token: _oldImage!.token,
                                  imageName: _oldImage!.filename,
                                );
                                _img = await signUpProvider.uploadPhoto(
                                  path: base64Encode(
                                      await compressedImage.readAsBytes()),
                                  imageName: imageFile.path.split('/').last,
                                );
                                _uploadedImagePath = _img!.path;
                              } else {
                                _img = await signUpProvider.uploadPhoto(
                                  path: base64Encode(
                                      await compressedImage.readAsBytes()),
                                  imageName: imageFile.path.split('/').last,
                                );
                                _uploadedImagePath = _img!.path;
                              }
                              setState(
                                () => _uploadedImagePath = _img!.path,
                              );
                              signUpProvider.setImageLoading(false);
                            },
                          ))
                  : Container();
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: formState,
                child: AutofillGroup(
                  child: Column(
                    children: [
                      EditText(
                        autofillHints: const [AutofillHints.givenName],
                        readOnly: false,
                        controller: _firstNameController,
                        upperTitle: true,
                        onChange: (String? value) {
                          isButtonPressed = false;
                          if (isError) {
                            formState.currentState!.validate();
                          }
                          setState(() {
                            _firstNameIsEmpty = value!.isEmpty;
                          });
                        },
                        shouldDisappear:
                            !_firstNameIsEmpty && !_firstNameFocused,
                        action: TextInputAction.done,
                        onFieldSubmit: (_) {
                          FocusScope.of(context).requestFocus(_lastNameNode);
                        },
                        isPhoneNumber: false,
                        isPassword: false,
                        isFocus: _firstNameFocused,
                        focusNode: _firstNameNode,
                        validator: (String? output) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (output!.isEmpty) {
                            return nameValidatorMessage;
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? saved) {
                          _firstName = saved;
                        },
                        labelText: 'الاسم الاول',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      EditText(
                        autofillHints: const [AutofillHints.familyName],
                        readOnly: false,
                        controller: _lastNameController,
                        upperTitle: true,
                        onChange: (String? value) {
                          isButtonPressed = false;
                          if (isError) {
                            formState.currentState!.validate();
                          }
                          setState(() {
                            _lastNameIsEmpty = value!.isEmpty;
                          });
                        },
                        shouldDisappear: !_lastNameIsEmpty && !_lastNameFocused,
                        action: TextInputAction.done,
                        onFieldSubmit: (_) {
                          FocusScope.of(context).requestFocus(_emailNode);
                        },
                        isPhoneNumber: false,
                        isPassword: false,
                        isFocus: _lastNameFocused,
                        focusNode: _lastNameNode,
                        validator: (String? output) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (output!.isEmpty) {
                            return nameValidatorMessage;
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? saved) {
                          _lastName = saved;
                        },
                        labelText: 'الاسم الاخير',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      EditText(
                        autofillHints: const [AutofillHints.email],
                        readOnly: false,
                        controller: _emailController,
                        upperTitle: true,
                        onChange: (String? value) {
                          isButtonPressed = false;
                          if (isError) {
                            formState.currentState!.validate();
                          }
                          setState(() {
                            _emailIsEmpty = value!.isEmpty;
                          });
                        },
                        shouldDisappear: !_emailIsEmpty && !_emailFocused,
                        action: TextInputAction.done,
                        onFieldSubmit: (_) {
                          FocusScope.of(context).unfocus();
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
                          if (!validateUserEmail(output!)) {
                            return emailValidatorMessage;
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? saved) {
                          _emailAddress = saved;
                        },
                        labelText: 'البريد الالكتروني',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      EditText(
                        readOnly: false,
                        controller: _phoneController,
                        upperTitle: true,
                        onChange: (String? value) {
                          isButtonPressed = false;
                          if (isError) {
                            formState.currentState!.validate();
                          }
                          setState(() {
                            _phoneIsEmpty = value!.isEmpty;
                          });
                        },
                        shouldDisappear: !_phoneIsEmpty && !_phoneFocused,
                        action: TextInputAction.done,
                        onFieldSubmit: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        isPhoneNumber: true,
                        type: TextInputType.phone,
                        isPassword: false,
                        isFocus: _phoneFocused,
                        focusNode: _phoneNode,
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
                        onSave: (String? saved) {
                          _phoneNumber = saved;
                        },
                        labelText: 'رقم الهاتف',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      EditText(
                        readOnly: false,
                        controller: _nationalIdNumberController,
                        upperTitle: true,
                        onChange: (String? value) {
                          isButtonPressed = false;
                          if (isError) {
                            formState.currentState!.validate();
                          }
                          setState(() {
                            _nationalIdNumberEmpty = value!.isEmpty;
                          });
                        },
                        type: TextInputType.number,
                        shouldDisappear: !_nationalIdNumberEmpty &&
                            !_nationalIdNumberFocused,
                        action: TextInputAction.done,
                        onFieldSubmit: (_) {
                          FocusScope.of(context).requestFocus(_passwordNode);
                        },
                        isPhoneNumber: false,
                        isPassword: false,
                        maxLength: 14,
                        isFocus: _nationalIdNumberFocused,
                        focusNode: _nationalIdNumberNode,
                        validator: (String? output) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (output!.isEmpty) {
                            return nationalIdNumberValidatorMessage;
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? saved) {
                          _nationalIdNumber = saved;
                        },
                        labelText: 'الرقم القومي',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      EditText(
                        readOnly: false,
                        controller: _passwordController,
                        upperTitle: true,
                        onChange: (String? value) {
                          isButtonPressed = false;
                          if (isError) {
                            formState.currentState!.validate();
                          }
                          setState(() {
                            _passwordIsEmpty = value!.isEmpty;
                          });
                        },
                        shouldDisappear: !_passwordIsEmpty && !_passwordFocused,
                        action: TextInputAction.done,
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
                      SizedBox(
                        height: 10.h,
                      ),
                      WeevoCheckbox(
                        content: 'أوافق علي سياسة الخصوصية والشروط والأحكام',
                        onCheck: (bool v) {
                          _agreed = v;
                        },
                        value: _agreed,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          WeevoButton(
            isStable: false,
            color: weevoPrimaryOrangeColor,
            onTap: signUpProvider.profileImageLoading
                ? () {}
                : () async {
                    isButtonPressed = true;
                    if (formState.currentState!.validate()) {
                      formState.currentState!.save();
                      if (_agreed) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Loading());
                        if (await signUpProvider
                                .checkEmailExisted(_emailAddress) &&
                            signUpProvider.existedState ==
                                NetworkState.success) {
                          Navigator.pop(navigator.currentContext!);
                          showDialog(
                              context: navigator.currentContext!,
                              barrierDismissible: false,
                              builder: (ctx) => ActionDialog(
                                    content: 'الإيميل موجود بالفعل',
                                    onApproveClick: () {
                                      Navigator.pop(context);
                                    },
                                    approveAction: 'حسناً',
                                  ));
                        } else if (await signUpProvider
                                .checkPhoneExisted(_phoneNumber) &&
                            signUpProvider.existedState ==
                                NetworkState.success) {
                          Navigator.pop(navigator.currentContext!);
                          showDialog(
                              context: navigator.currentContext!,
                              barrierDismissible: false,
                              builder: (ctx) => ActionDialog(
                                    content: 'الهاتف موجود بالفعل',
                                    onApproveClick: () {
                                      Navigator.pop(context);
                                    },
                                    approveAction: 'حسناً',
                                  ));
                        } else {
                          Navigator.pop(navigator.currentContext!);
                          if (_img == null) {
                            signUpProvider.setUserDataOne(
                              SignUpData(
                                firstName: _firstName,
                                lastName: _lastName,
                                phone: _phoneNumber,
                                email: _emailAddress,
                                gender: 'male',
                                password: _password,
                                nationalIdNumber: _nationalIdNumber,
                              ),
                            );
                          } else {
                            signUpProvider.setUserDataOne(
                              SignUpData(
                                firstName: _firstName,
                                lastName: _lastName,
                                phone: _phoneNumber,
                                email: _emailAddress,
                                gender: 'male',
                                password: _password,
                                photo: _uploadedImagePath,
                                nationalIdNumber: _nationalIdNumber,
                              ),
                            );
                          }
                          signUpProvider.updateScreen(1);
                        }
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => ActionDialog(
                            content:
                                'عليك الموافقة علي سياسة الخصوصية\nوالشروط والأحكام الخاصة بويفو',
                            onApproveClick: () {
                              Navigator.pop(context);
                            },
                            approveAction: 'حسناً',
                          ),
                        );
                      }
                    } else {
                      log('form not valid');
                    }
                  },
            title: 'التالي',
          ),
        ],
      ),
    );
  }
}
