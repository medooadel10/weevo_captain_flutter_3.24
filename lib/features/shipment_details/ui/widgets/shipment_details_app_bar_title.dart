import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Utilits/colors.dart';
import '../../../../core/helpers/spacing.dart';
import '../../logic/cubit/shipment_details_cubit.dart';
import 'shipment_details_qr_code.dart';

class ShipmentDetailsAppBarTitle extends StatelessWidget {
  final int? id;
  const ShipmentDetailsAppBarTitle({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        final cubit = context.read<ShipmentDetailsCubit>();
        return Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'طلب رقم $id',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: weevoPrimaryOrangeColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            horizontalSpace(5),
            ShipmentDetailsQrCode(
              courierNationalId: cubit.courierNationalId,
              merchantNationalId: cubit.merchantNationalId,
              locationId: cubit.locationId,
              status: cubit.status,
            ),
          ],
        );
      },
    );
  }
}
