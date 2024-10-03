import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Providers/shipment_provider.dart';
import '../Utilits/colors.dart';
import '../router/router.dart';

class CouponInfoDialog extends StatelessWidget {
  const CouponInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    ShipmentProvider shipment = Provider.of<ShipmentProvider>(context);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 20.0.w,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/mobile_man_image.png',
                  height: 110.h,
                  width: 110.h,
                )
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Text(
              'هتحصل من العميل ${num.parse(shipment.shipmentById!.agreedShippingCostAfterDiscount!).toInt()} ج سعر التوصيل + ${num.parse(shipment.shipmentById!.amount!).toInt()} ج سعر مقدم الشحنة',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    MagicRouter.pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      const Color(0xffFFF3EE),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 12.0)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'حسناً',
                    style: TextStyle(
                        color: weevoPrimaryOrangeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.0.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
