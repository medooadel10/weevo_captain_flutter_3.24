import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/shipment_tracking_model.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_tracking_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../core/networking/api_constants.dart';
import '../core/router/router.dart';
import '../main.dart';
import 'done_dialog.dart';
import 'loading.dart';
import 'qr_code_scanner.dart';
import 'rating_dialog.dart';
import 'wallet_dialog.dart';

class CourierToCustomerQrCodeScanner extends StatelessWidget {
  final ShipmentTrackingModel model;
  final BuildContext parentContext;
  final String locationId;

  const CourierToCustomerQrCodeScanner({
    super.key,
    required this.parentContext,
    required this.model,
    required this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    final ShipmentTrackingProvider trackingProvider =
        Provider.of<ShipmentTrackingProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/weevo_scan_qr_code.gif'),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            'عشان تسلم الطلب \nلازم تعمل مسح لرمز ال Qrcode \nاو تكتب الكود اللي عند العميل',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[600],
              fontWeight: FontWeight.w300,
              height: 1.21,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () {
              MagicRouter.pop();
              showDialog(
                context: navigator.currentContext!,
                builder: (c) => QrCodeScanner(
                  onDataCallback: (String v) async {
                    if (v.isNotEmpty) {
                      Navigator.pop(c);
                      showDialog(
                          context: c,
                          barrierDismissible: false,
                          builder: (c) => const Loading());
                      await trackingProvider
                          .markShipmentAsDeliveredByValidatingCourierToCustomerHandoverCode(
                              model.shipmentId!, int.parse(v));
                      check(
                          auth: authProvider,
                          ctx: navigator.currentContext!,
                          state: trackingProvider.state!);
                      if (trackingProvider.state == NetworkState.success) {
                        WeevoCaptain.facebookAppEvents.logPurchase(
                            amount: num.parse(
                                    model.shipmentDetailsModel?.amount ?? '0')
                                .toDouble(),
                            currency: 'EGP');
                        await FirebaseFirestore.instance
                            .collection('locations')
                            .doc(locationId)
                            .update(
                          {
                            'status': 'closed',
                            'shipmentId': model.shipmentId,
                          },
                        );
                        DocumentSnapshot userToken = await FirebaseFirestore
                            .instance
                            .collection('merchant_users')
                            .doc(model.merchantId.toString())
                            .get();
                        String token = userToken['fcmToken'];
                        authProvider.sendNotification(
                            title: 'تم تسليم طلبك بنجاح',
                            body:
                                'تم تسليم طلبك بنجاح برجاء تقييم طلبك مع الكابتن ${Preferences.instance.getUserName}',
                            toToken: token,
                            image: authProvider.photo!.isNotEmpty
                                ? authProvider.photo!
                                        .contains(ApiConstants.baseUrl)
                                    ? authProvider.photo
                                    : '${ApiConstants.baseUrl}${authProvider.photo}'
                                : '',
                            type: 'rating',
                            screenTo: '',
                            data: model.toJson());
                        MagicRouter.pop();
                        await showDialog(
                            context: navigator.currentContext!,
                            barrierDismissible: false,
                            builder: (c) => DoneDialog(
                                  content: 'تم تسلم طلبك بنجاح',
                                  callback: () {
                                    MagicRouter.pop();
                                  },
                                ));
                        MagicRouter.navigateAndPopAll(
                            RatingDialog(model: model));
                      } else if (trackingProvider.state == NetworkState.error) {
                        FirebaseFirestore.instance
                            .collection('locations')
                            .doc(locationId)
                            .set({
                          'status': 'receivedShipment',
                          'shipmentId': model.shipmentId,
                        });
                        Navigator.pop(navigator.currentContext!);
                        if (trackingProvider.ctcQrCodeError) {
                          showDialog(
                            context: navigator.currentContext!,
                            builder: (context) => WalletDialog(
                              msg:
                                  'الكود الذي أدخلته غير صحيح\nيرجي التأكد من الكود\nوأعادة المحاولة مرة آخري',
                              onPress: () {
                                Navigator.pop(context);
                              },
                            ),
                          );
                        } else {
                          showDialog(
                            context: navigator.currentContext!,
                            builder: (context) => WalletDialog(
                              msg: 'حدث خطأ برجاء المحاولة مرة اخري',
                              onPress: () {
                                Navigator.pop(context);
                              },
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
              );
            },
            child: const Text(
              'حسناً',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
