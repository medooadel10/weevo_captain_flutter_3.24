import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../../../../Utilits/colors.dart';
import '../../../../core/helpers/spacing.dart';
import '../../data/models/wasully_model.dart';
import 'wasully_details_price_info.dart';

class WasullyDetailsInfo extends StatelessWidget {
  final WasullyModel wasullyModel;
  const WasullyDetailsInfo({super.key, required this.wasullyModel});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wasullyModel.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          verticalSpace(10),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    WasullyDetailsPriceInfo(
                      priceImage: 'weevo_money',
                      price: wasullyModel.amount,
                      title: 'قيمة الطلب',
                    ),
                    Text(
                      '|',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/shipment_inside_online_icon.png',
                          height: 20.h,
                          width: 20.w,
                          fit: BoxFit.contain,
                        ),
                        horizontalSpace(2),
                        Text(
                          'مدفوع أونلاين',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                verticalSpace(5),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  runSpacing: 5,
                  direction: Axis.horizontal,
                  children: [
                    if (Preferences.instance.getUserFlags == 'freelance')
                      WasullyDetailsPriceInfo(
                        priceImage: 'van_icon',
                        price: wasullyModel.price,
                        title: 'رسوم التوصيل',
                      ),
                    if (wasullyModel.tip != null && wasullyModel.tip! > 0) ...[
                      Text(
                        '|',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      WasullyDetailsPriceInfo(
                        priceImage: 'tip_black',
                        price: '${wasullyModel.tip}',
                        title: 'مكافأة',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          verticalSpace(10),
          Row(
            children: [
              Text(
                'سيتم تحصيل رسوم التوصيل من',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.sp,
                ),
                textAlign: TextAlign.center,
              ),
              horizontalSpace(4),
              Expanded(
                child: Text(
                  wasullyModel.whoPay == 'me' ? 'المرسل' : 'المستلم',
                  style: TextStyle(
                    color: weevoPrimaryOrangeColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
