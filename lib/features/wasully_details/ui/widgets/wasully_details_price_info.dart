import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/core/helpers/extensions.dart';

import '../../../../core/helpers/spacing.dart';

class WasullyDetailsPriceInfo extends StatelessWidget {
  final String priceImage;
  final String price;
  final String title;
  const WasullyDetailsPriceInfo({
    super.key,
    required this.priceImage,
    required this.price,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/$priceImage.png',
          height: 20.h,
          width: 20.w,
          fit: BoxFit.contain,
        ),
        horizontalSpace(4),
        Text(
          '$title : ${price.toStringAsFixed0()} جنيه',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
