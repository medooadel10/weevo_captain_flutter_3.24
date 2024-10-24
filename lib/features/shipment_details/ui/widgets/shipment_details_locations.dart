import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weevo_captain_app/core/helpers/extensions.dart';

import '../../../../Utilits/colors.dart';
import '../../../../core/helpers/spacing.dart';
import '../../data/models/shipment_details_model.dart';
import '../../logic/cubit/shipment_details_cubit.dart';

class ShipmentDetailsLocations extends StatelessWidget {
  final ShipmentDetailsModel shipmentModel;
  const ShipmentDetailsLocations({super.key, required this.shipmentModel});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShipmentDetailsCubit>();
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
                      'المنزل',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      'من ${shipmentModel.receivingStateModel?.name ?? 'غير محدد'} - ${shipmentModel.receivingCityModel?.name ?? 'غير محدد'}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      shipmentModel.receivingStreet ?? 'غير محدد',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              horizontalSpace(10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Text(
                      cubit.shipmentDetails!.dateToReceiveShipment?.dateLabel ??
                          'غير محدد',
                      style: TextStyle(
                        color: weevoPrimaryOrangeColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    horizontalSpace(4),
                    Text(
                      cubit.shipmentDetails!.dateToReceiveShipment != null
                          ? DateFormat('hh:mm a', 'ar-EG').format(
                              DateTime.parse(
                                cubit.shipmentDetails!.dateToReceiveShipment ??
                                    '',
                              ),
                            )
                          : 'غير محدد',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
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
                    if (cubit.shipmentDetails!.merchant != null) ...[
                      Text(
                        shipmentModel.merchant!.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      verticalSpace(4),
                    ],
                    Text(
                      'إلي ${shipmentModel.deliveringStateModel?.name} - ${shipmentModel.deliveringCityModel?.name}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    verticalSpace(4),
                    Text(
                      shipmentModel.deliveringStreet ?? 'غير محدد',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              horizontalSpace(10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Text(
                      cubit.shipmentDetails!.dateToDeliverShipment?.dateLabel ??
                          'غير محدد',
                      style: TextStyle(
                        color: weevoPrimaryBlueColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    horizontalSpace(4),
                    Text(
                      cubit.shipmentDetails!.dateToDeliverShipment != null
                          ? DateFormat('hh:mm a', 'ar-EG').format(
                              DateTime.parse(
                                cubit.shipmentDetails!.dateToDeliverShipment ??
                                    '',
                              ),
                            )
                          : 'غير محدد',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
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
