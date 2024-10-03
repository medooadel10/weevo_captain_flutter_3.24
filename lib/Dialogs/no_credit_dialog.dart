import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class NoCreditDialog extends StatelessWidget {
  final VoidCallback onOkCancelCallback;
  final VoidCallback onChargeWalletCallback;

  const NoCreditDialog({
    super.key,
    required this.onOkCancelCallback,
    required this.onChargeWalletCallback,
  });

  @override
  Widget build(BuildContext context) {
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
            Text(
              'الرصيد لا يكفي',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 6.0.h,
            ),
            Text(
              'يرجى إنهاء طلبات التوصيل المعلقة',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18.0.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 6.0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onOkCancelCallback,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      weevoPrimaryOrangeColor,
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0.0)),
                    fixedSize:
                        WidgetStateProperty.all<Size>(const Size(120.0, 50.0)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'الغاء',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0.sp,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.0.w,
                ),
                ElevatedButton(
                  onPressed: onChargeWalletCallback,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      weevoPrimaryOrangeColor,
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0.0)),
                    fixedSize:
                        WidgetStateProperty.all<Size>(const Size(120.0, 50.0)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'اشحن محفظتك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0.sp,
                    ),
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
