import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/core/helpers/extensions.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../products/data/models/shipment_product_model.dart';
import '../../data/models/shipment_model.dart';

class ShipmentPriceContainer extends StatelessWidget {
  final ShipmentModel shipment;
  final ShipmentProductModel? product;
  const ShipmentPriceContainer(
      {super.key, required this.shipment, this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: shipment.tip != null && shipment.tip != 0 ? 50.h : 40.h,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffD8F3FF),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        'قيمة الطلب :',
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      horizontalSpace(5),
                      Expanded(
                        child: Text(
                          '${shipment.slug != null ? shipment.amount?.toStringAsFixed0() ?? 'غير محدد' : product?.price ?? 'غير محدد'} جنية',
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
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
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'رسوم التوصيل :',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    horizontalSpace(5),
                    Expanded(
                      child: Text(
                        shipment.flags != null && shipment.flags == 'fixAmount'
                            ? 'مدفوعة'
                            : '${shipment.slug != null ? shipment.price?.toStringAsFixed0() : shipment.agreedShippingCost != null ? shipment.agreedShippingCost?.toStringAsFixed0() : shipment.expectedShippingCost?.toStringAsFixed0() ?? 'غير محدد'} جنية',
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(5),
          if (shipment.tip != null && shipment.tip != 0)
            Row(
              children: [
                Text(
                  'الإكرامية :',
                  style: TextStyle(
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                horizontalSpace(5),
                Expanded(
                  child: Text(
                    '${shipment.tip?.toString().toStringAsFixed0()}',
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
