import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class HeadLineText extends StatelessWidget {
  final String title;

  const HeadLineText({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0.sp,
          color: weevoLightBlack,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.end,
      ),
    );
  }
}
