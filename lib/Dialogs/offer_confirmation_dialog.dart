import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/Utilits/colors.dart';

class OfferConfirmationDialog extends StatelessWidget {
  final VoidCallback onOkPressed;
  final bool isDone;
  final bool isOffer;
  final String? message;

  const OfferConfirmationDialog({
    super.key,
    required this.onOkPressed,
    required this.isDone,
    required this.isOffer,
    this.message,
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
                        isOffer
                            ? 'assets/images/mobile_man_image.png'
                            : 'assets/images/package_delivery_success_icon.png',
                        height: 110.h,
                        width: 110.h,
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            isDone
                ? Text(
                    isOffer
                        ? 'تم أرسال عرض التوصيل الخاص بك'
                        : 'تهانينا لقد قمت بقبول عرض التوصيل',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    'حدث خطاً',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
            SizedBox(
              height: 6.0.h,
            ),
            isDone
                ? Text(
                    isOffer
                        ? 'انتظر قبول التاجر لعرض التوصيل'
                        : 'يمكنك الذهاب لاستلام الشحنة من التاجر وتسليمها',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    message ??
                        'يرجي المحاولة مرة اخري\nيمكنك الدخول للشحنات الجديدة\nوتقديم العرض',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13.0.sp,
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
                  onPressed: onOkPressed,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      weevoPrimaryOrangeColor,
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
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
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
