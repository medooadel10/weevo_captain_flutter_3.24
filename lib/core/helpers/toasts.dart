import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Utilits/colors.dart';

showToast(String message, {bool isError = false}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: isError ? Colors.red : weevoGreen,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
