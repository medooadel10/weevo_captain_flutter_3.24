import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utilits/colors.dart';

class WalletDialog extends StatelessWidget {
  final String msg;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              msg,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 17.0.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onPress,
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
                  ),
                  child: Text(
                    'حسناً',
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  const WalletDialog({
    super.key,
    required this.msg,
    required this.onPress,
  });
}
