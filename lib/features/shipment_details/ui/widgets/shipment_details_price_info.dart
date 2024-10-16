import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/core/helpers/extensions.dart';

import '../../../../Utilits/colors.dart';
import '../../../../core/helpers/spacing.dart';

class ShipmentDetailsPriceInfo extends StatelessWidget {
  final String priceImage;
  final String price;
  final String title;
  final String subTitle;
  const ShipmentDetailsPriceInfo({
    super.key,
    required this.priceImage,
    required this.price,
    required this.title,
    this.subTitle = 'جنيه',
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
        Row(
          children: [
            Text(
              '$title : ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            horizontalSpace(2),
            Text(
              ' ${double.tryParse(price)?.toString().toStringAsFixed0() ?? price} $subTitle',
              style: TextStyle(
                color: weevoPrimaryBlueColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ],
    );
  }
}
