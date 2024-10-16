import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../logic/cubit/shipment_details_cubit.dart';

class ShipmentCallCourier extends StatelessWidget {
  const ShipmentCallCourier({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.read<ShipmentDetailsCubit>().shipmentDetails!;
    return GestureDetector(
      onTap: () async {
        await launchUrlString(
          'tel:${data.clientPhone}',
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xffFFE9DF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(
          'assets/images/big_phone_icon.png',
          height: 18.0.h,
          width: 18.0.w,
        ),
      ),
    );
  }
}
