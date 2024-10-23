import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';
import '../router/router.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.get(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete,
              color: Colors.red,
              size: 50.sp,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'هل تود حذف الحساب ؟',
              style: TextStyle(
                fontSize: 17.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'يرجي العلم انه في حالة حذف الحساب الخاص بك\nسيتم حذف كل بياناتك والرصيد المتاح لديك بالمحفظة\nهل توافق علي ذلك ؟',
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      MagicRouter.pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                          color: weevoPrimaryOrangeColor,
                          borderRadius: BorderRadius.circular(20.r)),
                      child: Center(
                        child: Text(
                          'لا',
                          style: TextStyle(
                            fontSize: 18.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      MagicRouter.pop();
                      auth.deleteAccount();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                          color: weevoRedColor,
                          borderRadius: BorderRadius.circular(20.r)),
                      child: Center(
                        child: Text(
                          'نعم',
                          style: TextStyle(
                            fontSize: 18.0.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
