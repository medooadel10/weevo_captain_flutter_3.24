import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../../Dialogs/action_dialog.dart';
import '../../Dialogs/image_picker_dialog.dart';
import '../../Models/image.dart';
import '../../Providers/auth_provider.dart';
import '../../Utilits/colors.dart';
import '../../Utilits/constants.dart';
import '../../Widgets/connectivity_widget.dart';
import '../../Widgets/edit_text.dart';
import '../../Widgets/gender_bottom_sheet.dart';
import '../../Widgets/image_container.dart';
import '../../Widgets/loading_widget.dart';

class ProfileInformation extends StatefulWidget {
  static const String id = 'Profile Information';

  const ProfileInformation({super.key});

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  late AuthProvider _authProvider;
  int _imageCounter = 0;
  Img? _img, _oldImage;
  String? _dateTime, _firstName, _lastName, _gender, _imagePath;
  late FocusNode _firstNameNode, _lastNameNode, _genderNode;
  late TextEditingController _firstNameController,
      _lastNameController,
      _genderController,
      _dateTimeController;
  bool _firstNameFocused = false;
  bool _lastNameFocused = false;
  bool _genderFocused = false;
  bool _dateTimeEmpty = true;
  bool _genderEmpty = true;
  bool _firstNameEmpty = true;
  bool _lastNameEmpty = true;
  int? _selectedItem;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _firstNameNode = FocusNode();
    _lastNameNode = FocusNode();
    _genderNode = FocusNode();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _dateTimeController = TextEditingController();
    _genderController = TextEditingController();
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
    _genderNode.addListener(() {
      setState(() {
        _genderFocused = _genderNode.hasFocus;
      });
    });
    _dateTimeController.text = _authProvider.dateOfBirth ?? '';
    _genderController.text = _authProvider.gender == 'male' ? 'ذكر' : 'انثي';
    _firstNameController.text = _authProvider.name?.split(' ')[0] ?? '';
    _lastNameController.text = _authProvider.name?.split(' ')[1] ?? '';
    _dateTimeEmpty = _dateTimeController.text.isEmpty;
    _firstNameEmpty = _firstNameController.text.isEmpty;
    _lastNameEmpty = _lastNameController.text.isEmpty;
    _genderEmpty = _genderController.text.isEmpty;
    _imagePath = _authProvider.photo;
    _selectedItem = genders.indexOf(_genderController.text);
  }

  @override
  void dispose() {
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _genderNode.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
              'معلومات الحساب',
            ),
          ),
          body: LoadingWidget(
            isLoading: authProvider.updateCourierPersonalInfoState ==
                NetworkState.waiting,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: Form(
                  key: _formState,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        ImageContainer(
                          isLoading: authProvider.profileImageLoading,
                          imagePath: _imagePath,
                          onImagePressed: () {
                            _oldImage = _img;
                            !authProvider.profileImageLoading
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
                                          onImageReceived:
                                              (XFile imageFile) async {
                                            _imageCounter++;
                                            Navigator.pop(context);
                                            authProvider.setImageLoading(true);
                                            File? compressedImage =
                                                await compressFile(
                                                    imageFile.path);
                                            if (compressedImage == null) return;
                                            if (_imageCounter > 1) {
                                              await authProvider.deletePhoto(
                                                token: _oldImage?.token,
                                                imageName: _oldImage?.filename,
                                              );
                                              _img = await authProvider
                                                  .uploadPhoto(
                                                path: base64Encode(
                                                    await compressedImage
                                                        .readAsBytes()),
                                                imageName: imageFile.path
                                                    .split('/')
                                                    .last,
                                              );
                                            } else {
                                              _img = await authProvider
                                                  .uploadPhoto(
                                                path: base64Encode(
                                                    await compressedImage
                                                        .readAsBytes()),
                                                imageName: imageFile.path
                                                    .split('/')
                                                    .last,
                                              );
                                            }
                                            setState(
                                              () => _imagePath = imageFile.path,
                                            );
                                            authProvider.setImageLoading(false);
                                          },
                                        ))
                                : Container();
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        EditText(
                          autofillHints: const [AutofillHints.givenName],
                          readOnly: false,
                          radius: 16,
                          controller: _firstNameController,
                          upperTitle: true,
                          onChange: (String? value) {
                            isButtonPressed = false;
                            if (isError) {
                              _formState.currentState!.validate();
                            }
                            setState(() => _firstNameEmpty = value!.isEmpty);
                          },
                          shouldDisappear:
                              !_firstNameEmpty && !_firstNameFocused,
                          action: TextInputAction.done,
                          onFieldSubmit: (_) {
                            FocusScope.of(context).unfocus();
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
                              return 'ادخل الاسم الاول';
                            }
                            isError = false;
                            return null;
                          },
                          onSave: (String? saved) {
                            _firstName = saved;
                          },
                          labelText: 'الاسم الأول',
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        EditText(
                          autofillHints: const [AutofillHints.familyName],
                          readOnly: false,
                          controller: _lastNameController,
                          upperTitle: true,
                          radius: 16,
                          onChange: (String? value) {
                            isButtonPressed = false;
                            if (isError) {
                              _formState.currentState!.validate();
                            }
                            setState(() => _lastNameEmpty = value!.isEmpty);
                          },
                          shouldDisappear: !_lastNameEmpty && !_lastNameFocused,
                          action: TextInputAction.done,
                          onFieldSubmit: (_) {
                            FocusScope.of(context).unfocus();
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
                              return 'ادخل الاسم الاخير';
                            }
                            isError = false;
                            return null;
                          },
                          onSave: (String? saved) {
                            _lastName = saved;
                          },
                          labelText: 'الاسم الأخير',
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        EditText(
                          readOnly: true,
                          upperTitle: true,
                          labelText: 'تاريخ الميلاد',
                          shouldDisappear: !_dateTimeEmpty && true,
                          controller: _dateTimeController,
                          isPassword: false,
                          isPhoneNumber: false,
                          onChange: (String? value) {
                            isButtonPressed = false;
                            if (isError) {
                              _formState.currentState!.validate();
                            }
                          },
                          validator: (String? value) {
                            if (!isButtonPressed) {
                              return null;
                            }
                            isError = true;
                            if (value!.isEmpty) {
                              return 'من فضلك أدخل تاريخ الميلاد';
                            }
                            isError = false;
                            return null;
                          },
                          onSave: (String? value) {
                            _dateTime = value;
                          },
                          focusNode: null,
                          isFocus: false,
                          onTap: () async {
                            DateTime? dt = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1919),
                              lastDate: DateTime.now(),
                              builder: (BuildContext ctx, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    dialogTheme: DialogTheme(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          25.0,
                                        ),
                                      ),
                                    ),
                                    colorScheme: const ColorScheme.light(
                                      primary: weevoPrimaryOrangeColor,
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: weevoPrimaryOrangeColor,
                                    ),
                                    dialogBackgroundColor: Colors.white,
                                  ),
                                  child: child ?? Container(),
                                );
                              },
                            );
                            final dateTime = DateTime(
                              dt?.year ?? DateTime.now().year,
                              dt?.month ?? DateTime.now().month,
                              dt?.day ?? DateTime.now().day,
                            );
                            _dateTime =
                                intl.DateFormat('yyyy-MM-dd').format(dateTime);
                            _dateTimeController.text = _dateTime ?? '';
                          },
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        EditText(
                          readOnly: true,
                          upperTitle: true,
                          labelText: 'النوع',
                          onChange: (String? value) {
                            isButtonPressed = false;
                            if (isError) {
                              _formState.currentState!.validate();
                            }
                          },
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25.0),
                                  topLeft: Radius.circular(25.0),
                                ),
                              ),
                              builder: (ctx) {
                                FocusScope.of(context)
                                    .requestFocus(_genderNode);
                                return GenderBottomSheet(
                                  onItemClick: (String item, int i) {
                                    setState(() {
                                      _selectedItem = i;
                                      _genderController.text = item;
                                      _genderEmpty =
                                          _genderController.text.isEmpty;
                                      Navigator.pop(ctx);
                                    });
                                  },
                                  selectedItem: _selectedItem ?? 0,
                                );
                              },
                            );
                            _genderNode.unfocus();
                          },
                          shouldDisappear: !_genderEmpty && !_genderFocused,
                          controller: _genderController,
                          isPassword: false,
                          isPhoneNumber: false,
                          validator: (String? value) {
                            if (!isButtonPressed) {
                              return null;
                            }
                            isError = true;
                            if (value!.isEmpty) {
                              return 'من فضلك اختر النوع';
                            }
                            isError = false;
                            return null;
                          },
                          onSave: (String? value) {
                            _gender = value;
                          },
                          focusNode: _genderNode,
                          isFocus: _genderFocused,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all<Size>(
                              Size(
                                size.width,
                                30.h,
                              ),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                              weevoPrimaryOrangeColor,
                            ),
                          ),
                          onPressed: authProvider.profileImageLoading
                              ? null
                              : () async {
                                  isButtonPressed = true;
                                  if (_formState.currentState!.validate()) {
                                    _formState.currentState!.save();
                                    await authProvider.updatePersonalInfo(
                                      firstName: _firstName,
                                      lastName: _lastName,
                                      dateOfBirth: _dateTime,
                                      gender:
                                          _gender == 'ذكر' ? 'male' : 'female',
                                      photo: _img != null
                                          ? _img?.path
                                          : _imagePath,
                                    );
                                    if (authProvider
                                            .updateCourierPersonalInfoState ==
                                        NetworkState.success) {
                                      await FirebaseFirestore.instance
                                          .collection('courier_users')
                                          .doc(authProvider.id)
                                          .set({
                                        'id': authProvider.id,
                                        'email': authProvider.email,
                                        'name': authProvider.name,
                                        'imageUrl': authProvider.photo,
                                        'fcmToken': authProvider.fcmToken,
                                        'national_id':
                                            authProvider.getNationalId
                                      });
                                      showDialog(
                                        context: navigator.currentContext!,
                                        builder: (context) => ActionDialog(
                                          content:
                                              'تم تغيير معلومات الحساب بنجاح',
                                          onCancelClick: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          cancelAction: 'حسناً',
                                        ),
                                      );
                                    } else if (authProvider
                                            .updateCourierPersonalInfoState ==
                                        NetworkState.logout) {
                                      check(
                                          ctx: navigator.currentContext!,
                                          auth: authProvider,
                                          state: authProvider
                                              .updateCourierPersonalInfoState!);
                                    } else if (authProvider
                                            .updateCourierPersonalInfoState ==
                                        NetworkState.error) {
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
                                },
                          child: Text(
                            'حفظ',
                            style: TextStyle(
                              fontSize: 18.0.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
