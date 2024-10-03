import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Utilits/colors.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../data/models/wasully_model.dart';

class WasullyDistances extends StatelessWidget {
  final WasullyModel wasullyModel;
  const WasullyDistances({super.key, required this.wasullyModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Image.asset(
              'assets/images/weevo_my_address_icon.png',
              height: 24.h,
              width: 24.w,
              color: weevoPrimaryBlueColor,
            ),
            verticalSpace(10),
            Text(
              'البداية',
              maxLines: 1,
              style: TextStyle(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w600,
              ),
              strutStyle: const StrutStyle(
                forceStrutHeight: true,
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                '${wasullyModel.distanceFromLocationToPickup}',
                style: TextStyle(
                  fontSize: 16.0.sp,
                  color: weevoPrimaryBlueColor,
                  fontWeight: FontWeight.bold,
                ),
                strutStyle: const StrutStyle(
                  forceStrutHeight: true,
                ),
              ),
              verticalSpace(6),
              Text(
                'KM',
                style: TextStyle(
                  fontSize: 16.0.sp,
                  color: weevoWhiteGrey,
                  fontWeight: FontWeight.bold,
                ),
                strutStyle: const StrutStyle(
                  forceStrutHeight: true,
                ),
              )
            ],
          ),
        ),
        Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/shipment_box_gray.png',
                  height: 24.h,
                  width: 24.w,
                  color: weevoPrimaryBlueColor,
                ),
              ],
            ),
            verticalSpace(10),
            Text(
              'الإستلام',
              maxLines: 1,
              style: TextStyle(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w600,
              ),
              strutStyle: const StrutStyle(
                forceStrutHeight: true,
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                '${wasullyModel.distanceFromPickupToDeliver}',
                style: TextStyle(
                  fontSize: 16.0.sp,
                  color: weevoPrimaryBlueColor,
                  fontWeight: FontWeight.bold,
                ),
                strutStyle: const StrutStyle(
                  forceStrutHeight: true,
                ),
              ),
              verticalSpace(6),
              Text(
                'KM',
                style: TextStyle(
                  fontSize: 16.0.sp,
                  color: weevoWhiteGrey,
                  fontWeight: FontWeight.bold,
                ),
                strutStyle: const StrutStyle(
                  forceStrutHeight: true,
                ),
              )
            ],
          ),
        ),
        Column(
          children: [
            Image.asset(
              'assets/images/shipment_delivery_icon.png',
              height: 24.h,
              width: 24.w,
              color: weevoPrimaryBlueColor,
            ),
            verticalSpace(10),
            Text(
              'التسليم',
              maxLines: 1,
              style: TextStyle(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w600,
              ),
              strutStyle: const StrutStyle(
                forceStrutHeight: true,
              ),
            ),
          ],
        ),
      ],
    ).paddingSymmetric(
      horizontal: 8.w,
    );
  }
}
