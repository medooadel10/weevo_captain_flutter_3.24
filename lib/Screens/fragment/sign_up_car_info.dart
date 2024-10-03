import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../../Models/cars/car_model.dart';
import '../../Models/cars/car_sub_model.dart';
import '../../Models/cars/cars.dart';
import '../../Models/color_model.dart';
import '../../Models/sign_up_data.dart';
import '../../Providers/auth_provider.dart';
import '../../Utilits/colors.dart';
import '../../Utilits/constants.dart';
import '../../Widgets/car_model_bottom_sheet.dart';
import '../../Widgets/car_sub_model_bottom_sheet.dart';
import '../../Widgets/color_bottom_sheet.dart';
import '../../Widgets/edit_text.dart';
import '../../Widgets/vehicle_type_bottom_sheet.dart';
import '../../Widgets/weevo_button.dart';

class SignUpCarInfo extends StatefulWidget {
  const SignUpCarInfo({super.key});

  @override
  State<SignUpCarInfo> createState() => _SignUpCarInfoState();
}

class _SignUpCarInfoState extends State<SignUpCarInfo> {
  late AuthProvider _authProvider;
  Color? _currentColor;
  int? _selectedColor, _selectedCarIndex;
  late FocusNode _colorNode, _deliveryMethodNode, _modelNameNode, _carPlateNode;
  late TextEditingController _colorController,
      _deliveryMethodController,
      _modelNameController,
      _carPlateController;
  bool _colorEmpty = true,
      _modelNameEmpty = true,
      _carPlateEmpty = true,
      _deliveryMethodEmpty = true,
      _deliveryMethodFocused = false,
      _colorFocused = false,
      _carPlateFocused = false,
      isANewModel = false;
  String? _deliveryMethod, _vehicleColor, _vehicleModel, _vehiclePlate;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  Cars? _cars;
  CarModel? _carModel;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _cars = Cars.fromJson(carModelsMap);
    _currentColor = colorList
        .firstWhereOrNull((e) => e.name == _authProvider.vehicleColor)
        ?.color;
    _colorNode = FocusNode();
    _deliveryMethodNode = FocusNode();
    _modelNameNode = FocusNode();
    _carPlateNode = FocusNode();
    _carPlateNode = FocusNode();
    _colorController = TextEditingController();
    _deliveryMethodController = TextEditingController();
    _modelNameController = TextEditingController();
    _carPlateController = TextEditingController();
    _carPlateController.text = _authProvider.vehiclePlate ?? '';
    _deliveryMethodController.text = _authProvider.deliveryMethod == 'truck'
        ? 'سيارة شحن'
        : _authProvider.deliveryMethod == 'bicycle'
            ? 'دراجة'
            : _authProvider.deliveryMethod == 'motorbike'
                ? 'دراجة نارية'
                : _authProvider.deliveryMethod == 'car'
                    ? 'سيارة ملاكي'
                    : _authProvider.deliveryMethod == 'none'
                        ? 'اخري'
                        : '';
    _deliveryMethod = _authProvider.deliveryMethod == 'truck'
        ? 'سيارة شحن'
        : _authProvider.deliveryMethod == 'bicycle'
            ? 'دراجة'
            : _authProvider.deliveryMethod == 'motorbike'
                ? 'دراجة نارية'
                : _authProvider.deliveryMethod == 'car'
                    ? 'سيارة ملاكي'
                    : _authProvider.deliveryMethod == 'none'
                        ? 'اخري'
                        : '';
    _modelNameController.text = _authProvider.vehicleModel ?? '';
    _colorController.text = _authProvider.vehicleColor ?? '';
    _colorNode.addListener(() {
      setState(() {
        _colorFocused = _colorNode.hasFocus;
      });
    });
    _deliveryMethodNode.addListener(() {
      setState(() {
        _deliveryMethodFocused = _deliveryMethodNode.hasFocus;
      });
    });
    _modelNameNode.addListener(() {
      setState(() {});
    });
    _carPlateNode.addListener(() {
      setState(() {
        _carPlateFocused = _carPlateNode.hasFocus;
      });
    });
    _colorController.addListener(() {
      setState(() {
        _colorEmpty = _colorController.text.isEmpty;
      });
    });
    _deliveryMethodController.addListener(() {
      setState(() {
        _deliveryMethodEmpty = _deliveryMethodController.text.isEmpty;
      });
    });
    _modelNameController.addListener(() {
      setState(() {
        _modelNameEmpty = _modelNameController.text.isEmpty;
      });
    });
    _carPlateController.addListener(() {
      setState(() {
        _carPlateEmpty = _carPlateController.text.isEmpty;
      });
    });
    _carPlateEmpty = _carPlateController.text.isEmpty;
    _modelNameEmpty = _modelNameController.text.isEmpty;
    _deliveryMethodEmpty = _deliveryMethodController.text.isEmpty;
    _colorEmpty = _colorController.text.isEmpty;
  }

  @override
  void dispose() {
    _colorNode.dispose();
    _modelNameNode.dispose();
    _carPlateNode.dispose();
    _deliveryMethodNode.dispose();
    _colorController.dispose();
    _modelNameController.dispose();
    _carPlateController.dispose();
    _deliveryMethodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Form(
              key: _formState,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    EditText(
                      readOnly: true,
                      controller: _deliveryMethodController,
                      upperTitle: true,
                      shouldDisappear:
                          !_deliveryMethodFocused && !_deliveryMethodEmpty,
                      action: TextInputAction.done,
                      isPhoneNumber: false,
                      isPassword: false,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      isFocus: _deliveryMethodFocused,
                      focusNode: _deliveryMethodNode,
                      validator: (String? output) {
                        if (!isButtonPressed) {
                          return null;
                        }
                        isError = true;
                        if (output!.isEmpty) {
                          return 'أدخل نوع المركبة';
                        }
                        isError = false;
                        return null;
                      },
                      onChange: (String? value) {
                        isButtonPressed = false;
                        if (isError) {
                          _formState.currentState!.validate();
                        }
                      },
                      onSave: (String? saved) {
                        _deliveryMethod = saved;
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
                                .requestFocus(_deliveryMethodNode);
                            return VehicleBottomSheet(
                              onTap: (String title, int i) {
                                _deliveryMethodController.text = title;
                                _colorController.text = '';
                                _currentColor = null;
                                _modelNameController.text = '';
                                _carPlateController.text = '';
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                        _deliveryMethodNode.unfocus();
                      },
                      labelText: 'نوع المركبة',
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    (_deliveryMethodController.text == 'سيارة شحن' ||
                            _deliveryMethodController.text == 'سيارة ملاكي')
                        ? EditText(
                            readOnly: true,
                            controller: _modelNameController,
                            upperTitle: true,
                            shouldDisappear: !_modelNameEmpty && true,
                            onTap: () async {
                              await showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  builder: (ctx) {
                                    return CarModelBottomSheet(
                                      onItemClick:
                                          (CarModel car, int carIndex) {
                                        _selectedCarIndex = carIndex;
                                        _carModel = car;
                                        isANewModel = true;
                                        Navigator.pop(ctx);
                                      },
                                      selectedItem: _selectedCarIndex ?? 0,
                                      models: _cars!.cars!,
                                    );
                                  });
                              if (isANewModel) {
                                isANewModel = false;
                                await showModalBottomSheet(
                                    context: navigator.currentContext!,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                        // 20.0,
                                      ),
                                    ),
                                    builder: (ctx) {
                                      return CarSubModelBottomSheet(
                                        onItemClick: (CarSubModels subCar,
                                            int carIndex) {
                                          _modelNameController.text =
                                              '${_carModel!.name} ${subCar.name}';
                                          _carModel = null;
                                          Navigator.pop(ctx);
                                        },
                                        subModels: _carModel!.models!,
                                        parentImageUrl: _carModel!.photo!,
                                      );
                                    });
                              }
                            },
                            isPhoneNumber: false,
                            isPassword: false,
                            isFocus: false,
                            focusNode: null,
                            onChange: (String? value) {
                              isButtonPressed = false;
                              if (isError) {
                                _formState.currentState!.validate();
                              }
                            },
                            validator: (String? output) {
                              if (!isButtonPressed) {
                                return null;
                              }
                              isError = true;
                              if (output!.isEmpty) {
                                return 'أدخل موديل المركبة';
                              }
                              isError = false;
                              return null;
                            },
                            onSave: (String? saved) {
                              _vehicleModel = saved;
                            },
                            labelText: 'موديل المركبة',
                          )
                        : Container(),
                    (_deliveryMethodController.text == 'سيارة شحن' ||
                            _deliveryMethodController.text == 'سيارة ملاكي')
                        ? SizedBox(
                            height: 10.h,
                          )
                        : Container(),
                    (_deliveryMethodController.text == 'سيارة شحن' ||
                            _deliveryMethodController.text == 'سيارة ملاكي')
                        ? EditText(
                            readOnly: true,
                            controller: _colorController,
                            upperTitle: true,
                            shouldDisappear: !_colorFocused && !_colorEmpty,
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  FocusScope.of(context)
                                      .requestFocus(_colorNode);
                                  return ColorBottomSheet(
                                    onItemClick: (ColorModel color, int i) {
                                      _selectedColor = i;
                                      _colorController.text = color.name;
                                      setState(() {
                                        _currentColor = color.color;
                                      });
                                      Navigator.pop(ctx);
                                    },
                                    selectedItem: _selectedColor ?? 0,
                                  );
                                },
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25.0),
                                    topLeft: Radius.circular(25.0),
                                  ),
                                ),
                              );
                              _colorNode.unfocus();
                            },
                            suffix: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 10.0,
                                width: 10.0,
                                decoration: BoxDecoration(
                                  border: _currentColor != null
                                      ? Border.all(
                                          color: _currentColor == Colors.grey
                                              ? Colors.black
                                              : Colors.grey,
                                        )
                                      : null,
                                  color: _currentColor,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                            isPhoneNumber: false,
                            type: TextInputType.text,
                            isPassword: false,
                            isFocus: _colorFocused,
                            focusNode: _colorNode,
                            onChange: (String? value) {
                              isButtonPressed = false;
                              if (isError) {
                                _formState.currentState!.validate();
                              }
                            },
                            validator: (String? output) {
                              if (!isButtonPressed) {
                                return null;
                              }
                              isError = true;
                              if (output!.isEmpty) {
                                return 'أدخل لون المركبة';
                              }
                              isError = false;
                              return null;
                            },
                            onSave: (String? saved) {
                              _vehicleColor = saved;
                            },
                            labelText: 'لون المركبة',
                          )
                        : Container(),
                    (_deliveryMethodController.text == 'سيارة شحن' ||
                            _deliveryMethodController.text == 'سيارة ملاكي' &&
                                _deliveryMethodController.text.isNotEmpty)
                        ? SizedBox(
                            height: 10.h,
                          )
                        : Container(),
                    (_deliveryMethodController.text != 'دراجة' &&
                            _deliveryMethodController.text != 'اخري' &&
                            _deliveryMethodController.text.isNotEmpty)
                        ? EditText(
                            readOnly: false,
                            controller: _carPlateController,
                            upperTitle: true,
                            shouldDisappear:
                                !_carPlateFocused && !_carPlateEmpty,
                            action: TextInputAction.done,
                            onFieldSubmit: (_) {
                              _carPlateNode.unfocus();
                            },
                            isPhoneNumber: false,
                            type: TextInputType.text,
                            isPassword: false,
                            isFocus: _carPlateFocused,
                            focusNode: _carPlateNode,
                            onChange: (String? value) {
                              isButtonPressed = false;
                              if (isError) {
                                _formState.currentState!.validate();
                              }
                            },
                            validator: (String? output) {
                              if (!isButtonPressed) {
                                return null;
                              }
                              isError = true;
                              if (output!.isEmpty) {
                                return 'أدخل حروف لوحة المركبة';
                              }
                              isError = false;
                              return null;
                            },
                            onSave: (String? saved) {
                              _vehiclePlate = saved;
                            },
                            labelText: 'لوحة المركبة',
                          )
                        : Container(),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: EditText(
                    //         readOnly: false,
                    //         controller: _carPlateAlphabetController,
                    //         upperTitle: true,
                    //         shouldDisappear: !_carPlateAlphabetFocused &&
                    //             !_carPlateAlphabetEmpty,
                    //         action: TextInputAction.next,
                    //         onFieldSubmit: (_) {
                    //           FocusScope.of(context)
                    //               .requestFocus(_carPlateNumbersNode);
                    //         },
                    //         onChange: (String v) {
                    //           setState(() {
                    //             _carPlateAlphabetText = v;
                    //           });
                    //           nextFocus(v, _carPlateNumbersNode, false);
                    //         },
                    //         maxLength: 3,
                    //         isPhoneNumber: false,
                    //         type: TextInputType.text,
                    //         isPassword: false,
                    //         isFocus: _carPlateAlphabetFocused,
                    //         focusNode: _carPlateAlphabetNode,
                    //         validator: (String output) => output.isEmpty
                    //             ? 'أدخل حروف لوحة المركبة'
                    //             : null,
                    //         onSave: (String saved) {
                    //           _vehiclePlateAlphabet = saved;
                    //         },
                    //         labelText: 'حروف لوحة المركبة',
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 4.0.w,
                    //     ),
                    //     VerticalDivider(
                    //       width: 3.0,
                    //       thickness: 3.0,
                    //       color: Colors.black,
                    //     ),
                    //     SizedBox(
                    //       width: 4.0.w,
                    //     ),
                    //     Expanded(
                    //       child: EditText(
                    //         readOnly: false,
                    //         controller: _carPlateNumbersController,
                    //         upperTitle: true,
                    //         shouldDisappear: !_carPlateNumbersFocused &&
                    //             !_carPlateNumbersEmpty,
                    //         action: TextInputAction.done,
                    //         onFieldSubmit: (_) {
                    //           FocusScope.of(context).unfocus();
                    //         },
                    //         onChange: (String v) {
                    //           if (v.isEmpty) {
                    //             previousFocus(v, _carPlateAlphabetNode);
                    //           } else {
                    //             nextFocus(v, _carPlateNumbersNode, true);
                    //           }
                    //           setState(() {
                    //             _carPlateNumbersText = v;
                    //           });
                    //         },
                    //         maxLength: 4,
                    //         isPhoneNumber: false,
                    //         type: TextInputType.number,
                    //         isPassword: false,
                    //         isFocus: _carPlateNumbersFocused,
                    //         focusNode: _carPlateNumbersNode,
                    //         validator: (String output) => output.isEmpty
                    //             ? 'أدخل ارقام لوحة المركبة'
                    //             : null,
                    //         onSave: (String saved) {
                    //           _vehiclePlateNumbers = saved;
                    //         },
                    //         labelText: 'أرقام لوحة المركبة',
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 20.0.h),
                    // Container(
                    //   height: 120.0.h,
                    //   width: double.infinity.w,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20.0),
                    //     border: Border.all(
                    //       width: 3.0,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Expanded(
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             color: Colors.cyan,
                    //             borderRadius: BorderRadius.only(
                    //               topRight: Radius.circular(18.0),
                    //               topLeft: Radius.circular(18.0),
                    //             ),
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceEvenly,
                    //             children: [
                    //               Text(
                    //                 'مصر',
                    //                 style: TextStyle(
                    //                   fontSize: 18.0.sp,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //               Text(
                    //                 'EGYPT',
                    //                 style: TextStyle(
                    //                   fontSize: 18.0.sp,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Divider(
                    //         color: Colors.black,
                    //         height: 3.0,
                    //         thickness: 3.0,
                    //       ),
                    //       Expanded(
                    //         flex: 2,
                    //         child: Row(
                    //           children: [
                    //             Expanded(
                    //               child: Center(
                    //                 child: Text(
                    //                   _carPlateAlphabetText.split('').join(' '),
                    //                   style: TextStyle(
                    //                     fontSize: 20.0.sp,
                    //                     fontWeight: FontWeight.w600,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               width: 4.0.w,
                    //             ),
                    //             VerticalDivider(
                    //               width: 3.0,
                    //               thickness: 3.0,
                    //               color: Colors.black,
                    //             ),
                    //             SizedBox(
                    //               width: 4.0.w,
                    //             ),
                    //             Expanded(
                    //               child: Center(
                    //                 child: Text(
                    //                   _carPlateNumbersText,
                    //                   style: TextStyle(
                    //                     fontSize: 20.0.sp,
                    //                     fontWeight: FontWeight.w600,
                    //                   ),
                    //                 ),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
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
              if (_formState.currentState!.validate()) {
                _formState.currentState!.save();
                authProvider.setUserDataFour(
                  SignUpData(
                    vehiclePlate: _vehiclePlate,
                    vehicleColor: _vehicleColor,
                    vehicleModel: _vehicleModel,
                    deliveryMethod: _deliveryMethod == 'سيارة ملاكي'
                        ? 'car'
                        : _deliveryMethod == 'سيارة شحن'
                            ? 'truck'
                            : _deliveryMethod == 'دراجة'
                                ? 'bicycle'
                                : _deliveryMethod == 'دراجة نارية'
                                    ? 'motorbike'
                                    : 'none',
                  ),
                );
                authProvider.updateScreen(3);
              }
            },
            title: 'التالي',
          )
        ],
      ),
    );
  }

  void nextFocus(String value, FocusNode node, bool isNumber) {
    if (isNumber) {
      if (value.length == 4) {
        node.unfocus();
      }
    } else {
      if (value.length == 3) {
        node.requestFocus();
      }
    }
  }

  void previousFocus(String value, FocusNode node) {
    if (value.isEmpty) {
      node.requestFocus();
    }
  }
}
