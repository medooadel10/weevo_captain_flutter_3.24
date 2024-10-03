import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';
import 'package:weevo_captain_app/features/available_shipments/ui/screens/available_shipments_screen.dart';

import '../../../Dialogs/content_dialog.dart';
import '../../../Providers/auth_provider.dart';
import '../../../Providers/wallet_provider.dart';
import '../../../Storage/shared_preference.dart';
import '../../../Utilits/colors.dart';
import '../../../Widgets/weevo_button.dart';
import '../../../core/router/router.dart';

class DepositWaletFaweryPayment extends StatefulWidget {
  const DepositWaletFaweryPayment({super.key});

  @override
  State<DepositWaletFaweryPayment> createState() =>
      _DepositWaletFaweryPaymentState();
}

class _DepositWaletFaweryPaymentState extends State<DepositWaletFaweryPayment> {
  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<WalletProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 60.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(
                image: wallet.fawatrakAvailablePaymentGateways!
                    .where((e) => e.paymentId == wallet.initPaymentId)
                    .toList()[0]
                    .logo!,
                height: 40.h,
                width: 40.w,
                radius: 0,
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          (wallet.initPaymentId == 3 ||
                  wallet.initPaymentId == 12 ||
                  wallet.initPaymentId == 14)
              ? Text(
                  wallet.initPaymentId == 3
                      ? 'كود فوري'
                      : wallet.initPaymentId == 12
                          ? 'كود آمان'
                          : 'كود مصاري',
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                )
              : Text(
                  'تم إرسال رسالة نصية لتأكيد ايداع مبلغ ${wallet.depositAmount} جنية',
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
          SizedBox(
            height: 20.h,
          ),
          (wallet.initPaymentId == 3 ||
                  wallet.initPaymentId == 12 ||
                  wallet.initPaymentId == 14)
              ? InkWell(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(
                        text: wallet.initPaymentId == 3
                            ? wallet.initPaymentModel['fawryCode'].toString()
                            : wallet.initPaymentId == 12
                                ? wallet.initPaymentModel['amanCode'].toString()
                                : wallet.initPaymentModel['masaryCode']
                                    .toString()));
                    Fluttertoast.showToast(msg: 'تم نسخ الكود');
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: weevoOffWhiteOrange),
                        color: Colors.white),
                    child: Text(
                      wallet.initPaymentId == 3
                          ? wallet.initPaymentModel['fawryCode'].toString()
                          : wallet.initPaymentId == 12
                              ? wallet.initPaymentModel['amanCode'].toString()
                              : wallet.initPaymentModel['masaryCode']
                                  .toString(),
                      style: TextStyle(
                        fontSize: 20.0.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 20.h,
          ),
          WeevoButton(
            isStable: true,
            color: weevoPrimaryOrangeColor,
            weight: FontWeight.w700,
            onTap: () async {
              await wallet.getCurrentBalance(
                  authorization: auth.appAuthorization!, fromRefresh: true);
              showDialog(
                  context: navigator.currentContext!,
                  barrierDismissible: false,
                  builder: (context) => ContentDialog(
                        content:
                            ' جاري إيداع المبلغ في حالة\nالدفع عن طريق الكود',
                        callback: () {
                          if (wallet.fromOfferPage) {
                            Navigator.pop(context);
                            MagicRouter.navigateTo(
                                const AvailableShipmentsScreen());
                          } else {
                            Navigator.pop(context);
                            wallet.setMainIndex(0);
                            wallet.setDepositIndex(0);
                          }
                        },
                      ));
            },
            title:
                'تم الدفع عن طريق ${wallet.fawatrakAvailablePaymentGateways!.where((e) => e.paymentId == wallet.initPaymentId).toList()[0].nameAr} ',
          ),
        ],
      ),
    );
  }
}
