import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Dialogs/image_picker_dialog.dart';
import '../../Models/image.dart';
import '../../Models/sign_up_data.dart';
import '../../Providers/auth_provider.dart';
import '../../Utilits/colors.dart';
import '../../Utilits/constants.dart';
import '../../Widgets/id_image_container.dart';
import '../../Widgets/weevo_button.dart';

class SignUpNationalIDScreen extends StatefulWidget {
  const SignUpNationalIDScreen({super.key});

  @override
  State<SignUpNationalIDScreen> createState() => _SignUpNationalIDScreenState();
}

class _SignUpNationalIDScreenState extends State<SignUpNationalIDScreen> {
  late AuthProvider _authProvider;
  int? productCategory, _frontIdImageCounter = 0, _backIdImageCounter = 0;
  Img? _frontIdImg, _backIdImg, _oldBackIdImage, _oldFrontIdImage;
  bool _frontIdImageHasError = false, _backIdImageHasError = false;
  String? _nationalIdPhotoFrontPath, _nationalIdPhotoBackPath;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of(context, listen: false);
    _nationalIdPhotoBackPath = _authProvider.nationalIdPhotoBack;
    _nationalIdPhotoFrontPath = _authProvider.nationalIdPhotoFront;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    log('_frontIdImg -> $_frontIdImg');
    log('_backIdImg -> $_backIdImg');
    log('_nationalIdPhotoFront -> $_nationalIdPhotoFrontPath');
    log('_nationalIdPhotoBack -> $_nationalIdPhotoBackPath');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IDImageContainer(
            text: 'صورة البطاقة الأمامية',
            isLoading: authProvider.frontIdImageLoading,
            imagePath: _nationalIdPhotoFrontPath,
            onImagePressed: () {
              if (_frontIdImageHasError) {
                setState(() {
                  _frontIdImageHasError = false;
                });
              }
              if (_frontIdImg != null) {
                _oldFrontIdImage = _frontIdImg;
              }
              !authProvider.frontIdImageLoading &&
                      !authProvider.backIdImageLoading
                  ? showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                      builder: (_) => ImagePickerDialog(
                            onImageReceived: (XFile imageFile) async {
                              _frontIdImageCounter = _frontIdImageCounter! + 1;
                              Navigator.pop(context);
                              authProvider.setFrontIdImageLoading(true);
                              File? compressedImage =
                                  await compressFile(imageFile.path);
                              if (compressedImage == null) return;

                              if (_frontIdImageCounter! > 1) {
                                await authProvider.deletePhotoID(
                                  token: _oldFrontIdImage!.token,
                                  imageName: _oldFrontIdImage!.filename,
                                );
                                _frontIdImg = await authProvider.uploadPhotoID(
                                  path: base64Encode(
                                      await compressedImage.readAsBytes()),
                                  imageName: imageFile.path.split('/').last,
                                );
                              } else {
                                _frontIdImg = await authProvider.uploadPhotoID(
                                  path: base64Encode(
                                      await compressedImage.readAsBytes()),
                                  imageName: imageFile.path.split('/').last,
                                );
                              }
                              if (_frontIdImg != null) {
                                setState(
                                  () => _nationalIdPhotoFrontPath =
                                      _frontIdImg!.path,
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'برجاء المحاولة مرة اخري');
                              }
                              authProvider.setFrontIdImageLoading(false);
                            },
                          ))
                  : Container();
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          _frontIdImageHasError
              ? Text(
                  'من فضلك أختر الصورة الأمامية للبطاقة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Container(),
          _frontIdImageHasError
              ? SizedBox(
                  height: 10.h,
                )
              : Container(),
          IDImageContainer(
            text: 'صورة البطاقة الخلفية',
            isLoading: authProvider.backIdImageLoading,
            imagePath: _nationalIdPhotoBackPath,
            onImagePressed: () {
              if (_backIdImageHasError) {
                setState(() {
                  _backIdImageHasError = false;
                });
              }
              if (_backIdImg != null) {
                _oldBackIdImage = _backIdImg;
              }
              !authProvider.backIdImageLoading &&
                      !authProvider.frontIdImageLoading
                  ? showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25.0),
                        topLeft: Radius.circular(25.0),
                      )),
                      builder: (_) => ImagePickerDialog(
                        onImageReceived: (XFile imageFile) async {
                          _backIdImageCounter = _backIdImageCounter! + 1;
                          Navigator.pop(context);
                          authProvider.setBackIdImageLoading(true);
                          File? compressedImage =
                              await compressFile(imageFile.path);
                          if (compressedImage == null) return;
                          if (_backIdImageCounter! > 1) {
                            await authProvider.deletePhotoID(
                              token: _oldBackIdImage!.token,
                              imageName: _oldBackIdImage!.filename,
                            );
                            _backIdImg = await authProvider.uploadPhotoID(
                              path: base64Encode(
                                await compressedImage.readAsBytes(),
                              ),
                              imageName: imageFile.path.split('/').last,
                            );
                          } else {
                            _backIdImg = await authProvider.uploadPhotoID(
                              path: base64Encode(
                                await compressedImage.readAsBytes(),
                              ),
                              imageName: imageFile.path.split('/').last,
                            );
                          }
                          if (_backIdImg != null) {
                            setState(
                              () => _nationalIdPhotoBackPath = _backIdImg!.path,
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: 'برجاء المحاولة مرة اخري');
                          }
                          authProvider.setBackIdImageLoading(false);
                        },
                      ),
                    )
                  : Container();
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          _backIdImageHasError
              ? Text(
                  'من فضلك أختر الصورة الخلفية للبطاقة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Container(),
          _backIdImageHasError
              ? SizedBox(
                  height: 10.h,
                )
              : Container(),
          Text(
            'تأكد من ظهور صورة البطاقة الشخصية \nبشكل واضح وصحيح',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18.0.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.0.h,
          ),
          Consumer<AuthProvider>(
            builder: (ctx, data, ch) => WeevoButton(
              isStable: true,
              color: weevoPrimaryOrangeColor,
              onTap: authProvider.backIdImageLoading ||
                      authProvider.frontIdImageLoading
                  ? () {}
                  : () async {
                      if (_nationalIdPhotoBackPath != null &&
                          _nationalIdPhotoFrontPath != null) {
                        setState(() {
                          _backIdImageHasError = false;
                          _frontIdImageHasError = false;
                        });
                        authProvider.setUserDataThree(
                          SignUpData(
                            nationalIdFront: '$_nationalIdPhotoFrontPath',
                            nationalIdBack: '$_nationalIdPhotoBackPath',
                          ),
                        );
                        authProvider.updateScreen(2);
                      } else {
                        if (_backIdImg == null) {
                          setState(() {
                            _backIdImageHasError = true;
                          });
                        }
                        if (_frontIdImg == null) {
                          setState(() {
                            _frontIdImageHasError = true;
                          });
                        }
                      }
                    },
              title: 'التالي',
            ),
          )
        ],
      ),
    );
  }
}
