import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget verticalSpace(double height) {
  return SizedBox(
    height: height.h,
  );
}

Widget horizontalSpace(double width) {
  return SizedBox(
    width: width.w,
  );
}
