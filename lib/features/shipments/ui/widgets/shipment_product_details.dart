import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../products/data/models/shipment_product_model.dart';
import '../../data/models/shipment_model.dart';

class ShipmentProductDetails extends StatelessWidget {
  final ShipmentModel shipment;
  final ShipmentProductModel? product;
  const ShipmentProductDetails({
    super.key,
    required this.shipment,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shipment.title ?? product!.productInfo.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              verticalSpace(3),
              Text(
                shipment.slug != null
                    ? 'وصلي'
                    : product!.productInfo.description,
                style: TextStyle(
                  fontSize: 12.0.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        horizontalSpace(8),
        Image.asset(
          shipment.slug != null
              ? 'assets/images/shipment_online_icon.png'
              : shipment.paymentMethod == 'cod'
                  ? 'assets/images/shipment_cod_icon.png'
                  : 'assets/images/shipment_online_icon.png',
          height: 35.h,
          width: 35.w,
        ),
      ],
    );
  }
}
