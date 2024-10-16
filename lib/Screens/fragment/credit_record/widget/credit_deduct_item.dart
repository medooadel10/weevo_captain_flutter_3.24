import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Models/dedaction_model.dart';
import '../../../../core/router/router.dart';
import '../../../../features/shipment_details/ui/shipment_details_screen.dart';
import 'credit_deduct_trailling_widget.dart';
import 'credit_leading_icon.dart';

class CreditDeductItem extends StatelessWidget {
  final Data data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        MagicRouter.navigateTo(
          ShipmentDetailsScreen(id: data.details!.id!),
        );
      },
      title: Text(
        'عملية رقم ${data.details!.id}',
        style: TextStyle(
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        data.details!.description!,
        style: TextStyle(
          fontSize: 14.0.sp,
          color: Colors.black,
        ),
      ),
      leading: const CreditLeadingIcon(),
      trailing: CreditDeductTrailingWidget(
        data: data,
      ),
    );
  }

  const CreditDeductItem({
    super.key,
    required this.data,
  });
}
