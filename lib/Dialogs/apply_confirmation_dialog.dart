import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class ApplyConfirmationDialog extends StatelessWidget {
  final VoidCallback onOkPressed;
  final bool isDone;
  final bool isWassully;

  const ApplyConfirmationDialog({
    super.key,
    required this.onOkPressed,
    required this.isDone,
    this.isWassully = false,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isDone
                    ? Image.asset(
                        'assets/images/done_icon.png',
                        height: 100.0.h,
                        width: 100.0.w,
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            isDone
                ? Text(
                    isWassully
                        ? 'الطلب بقت قيد التنفيذ وتم خصم المبلغ من المحفظة بالاضافة لنسبة ويفو'
                        : 'الشحنة بقت قيد التنفيذ وتم خصم المبلغ من المحفظة بالاضافة لنسبة ويفو',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    'حدث خطاً',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onOkPressed,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      weevoPrimaryOrangeColor,
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(0.0)),
                    fixedSize:
                        WidgetStateProperty.all<Size>(const Size(150.0, 60.0)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'حسناً',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0.sp,
                      color: Colors.white,
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
