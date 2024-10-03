import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Utilits/colors.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../data/models/wasully_model.dart';
import 'wasully_distances.dart';

class WasullyDetailsLocations extends StatelessWidget {
  final WasullyModel wasullyModel;
  const WasullyDetailsLocations({super.key, required this.wasullyModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            spreadRadius: 1.0,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        children: [
          WasullyDistances(
            wasullyModel: wasullyModel,
          ),
          verticalSpace(10),
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xffE2E2E2),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: weevoPrimaryOrangeColor,
                radius: 8,
              ).paddingOnly(top: 4),
              horizontalSpace(6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${wasullyModel.merchant.name}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${wasullyModel.receivingStateModel.name} - ${wasullyModel.receivingCityModel.name}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      wasullyModel.receivingStreet,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(8),
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xffE2E2E2),
          ),
          verticalSpace(8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: weevoPrimaryBlueColor,
                radius: 8,
              ).paddingOnly(top: 4),
              horizontalSpace(6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${wasullyModel.deliveringStateModel.name} - ${wasullyModel.deliveringCityModel.name}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      wasullyModel.deliveringStreet,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
