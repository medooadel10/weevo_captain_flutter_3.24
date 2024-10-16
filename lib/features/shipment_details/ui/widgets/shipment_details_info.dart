import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Utilits/colors.dart';
import '../../../../core/helpers/spacing.dart';
import '../../data/models/shipment_details_model.dart';
import '../../logic/cubit/shipment_details_cubit.dart';
import 'shipment_details_price_info.dart';

class ShipmentDetailsInfo extends StatelessWidget {
  final ShipmentDetailsModel? shipmentDetails;
  const ShipmentDetailsInfo({super.key, this.shipmentDetails});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        final cubit = context.read<ShipmentDetailsCubit>();
        log('Price ${shipmentDetails?.expectedShippingCost}');
        log('Price ${shipmentDetails?.agreedShippingCost}');
        log('Price ${shipmentDetails?.agreedShippingCostAfterDiscount}');
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
              )
            ],
          ),
          child: Column(
            children: [
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
                        ShipmentDetailsPriceInfo(
                          priceImage: 'weevo_money',
                          price: shipmentDetails?.amount ?? '',
                          title: 'قيمة الطلب الكلي',
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
                              cubit.shipmentDetails!.paymentMethod == 'cod'
                                  ? 'assets/images/shipment_inside_cod_icon.png'
                                  : 'assets/images/shipment_inside_online_icon.png',
                              height: 20.h,
                              width: 20.w,
                              fit: BoxFit.contain,
                            ),
                            horizontalSpace(2),
                            Text(
                              cubit.shipmentDetails!.paymentMethod == 'cod'
                                  ? 'دفع مقدم'
                                  : 'مدفوع أونلاين',
                              style: TextStyle(
                                color: weevoPrimaryBlueColor,
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
                        ShipmentDetailsPriceInfo(
                          priceImage: 'van_icon',
                          price: shipmentDetails!.flags == 'fixAmount'
                              ? 'مدفوعة'
                              : '${shipmentDetails!.agreedShippingCostAfterDiscount ?? shipmentDetails!.agreedShippingCost ?? shipmentDetails!.expectedShippingCost}',
                          title: 'رسوم التوصيل',
                          subTitle: shipmentDetails!.flags == 'fixAmount'
                              ? ''
                              : 'جنيه',
                        ),
                      ],
                    ),
                    verticalSpace(5),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
