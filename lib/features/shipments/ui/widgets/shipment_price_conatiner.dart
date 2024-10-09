import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Storage/shared_preference.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../products/data/models/shipment_product_model.dart';
import '../../data/models/shipment_model.dart';

class ShipmentPriceContainer extends StatelessWidget {
  final ShipmentModel shipment;
  final ShipmentProductModel? product;
  const ShipmentPriceContainer({
    super.key,
    required this.shipment,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffD8F3FF),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/money_icon.png',
                    fit: BoxFit.contain,
                    color: const Color(0xff091147),
                    height: 20.h,
                    width: 20.w,
                  ),
                  horizontalSpace(5),
                  Expanded(
                    child: Text(
                      '${shipment.slug != null ? shipment.amount : product!.price.toStringAsFixed(0)} جنية',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          horizontalSpace(5),
          if (Preferences.instance.getUserFlags == 'freelance')
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/van_icon.png',
                    fit: BoxFit.contain,
                    color: const Color(0xff091147),
                    height: 20.h,
                    width: 20.w,
                  ),
                  horizontalSpace(5),
                  Expanded(
                    child: Text(
                      '${shipment.slug != null ? shipment.price?.toStringAsFixed0() : '${double.parse(shipment.agreedShippingCostAfterDiscount ?? shipment.agreedShippingCost ?? shipment.expectedShippingCost ?? '0').toInt()} '} جنية',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          if (shipment.tip != null && shipment.tip != 0) ...[
            horizontalSpace(5),
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/tip_black.png',
                    fit: BoxFit.contain,
                    color: const Color(0xff091147),
                    height: 20.h,
                    width: 20.w,
                  ),
                  horizontalSpace(5),
                  Expanded(
                    child: Text(
                      '${shipment.tip.toString().toStringAsFixed0()} جنية',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
