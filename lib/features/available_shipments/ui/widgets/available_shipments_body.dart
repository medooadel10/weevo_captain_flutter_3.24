import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions.dart';
import 'available_shipments_list_bloc_builder.dart';

class AvailableShipmentsBody extends StatelessWidget {
  const AvailableShipmentsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const AvailableShipmentsListBlocBuilder().paddingSymmetric(
      vertical: 10.h,
      horizontal: 10.w,
    );
  }
}
