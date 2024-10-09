import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class NoCreditInWalletDialog extends StatelessWidget {
  final VoidCallback onPressedCallback;

  const NoCreditInWalletDialog({
    super.key,
    required this.onPressedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/mobile_man_image.png',
                  height: 110.h,
                  width: 110.h,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  'ليس لديك رصيد كافي',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                const Text('يمكنك شحن محفظتك الأن بمقدم الأوردر'),
                SizedBox(
                  height: 8.h,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xffFFF3EE)),
                      foregroundColor: WidgetStateProperty.all<Color>(
                          weevoPrimaryOrangeColor),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: 40.0.w, vertical: 7.h)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r))),
                    ),
                    onPressed: onPressedCallback,
                    child: Text(
                      'حسناً',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0.sp,
                        color: Colors.white,
                      ),
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
