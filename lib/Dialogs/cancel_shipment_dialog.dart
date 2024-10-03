import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class CancelShipmentDialog extends StatefulWidget {
  final VoidCallback onOkPressed;
  final VoidCallback onCancelPressed;

  const CancelShipmentDialog({
    super.key,
    required this.onOkPressed,
    required this.onCancelPressed,
  });

  @override
  State<CancelShipmentDialog> createState() => _CancelShipmentDialogState();
}

class _CancelShipmentDialogState extends State<CancelShipmentDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 20.0.w,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 20.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/atm_wallet_1500px_resized.png',
              height: 150.h,
              width: 150.h,
            ),
            const Text(
              'سيتم خصم رسوم الغاء الشحنة\nهل تود ذلك ؟',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onCancelPressed,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        weevoPrimaryBlueColor,
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(vertical: 8),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'لا أوافق',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onOkPressed,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        weevoPrimaryOrangeColor,
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(vertical: 8),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'موافق',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
