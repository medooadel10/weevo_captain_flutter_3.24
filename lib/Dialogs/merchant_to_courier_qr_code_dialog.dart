import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/router/router.dart';

import '../Models/shipment_tracking_model.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Providers/shipment_tracking_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import 'done_dialog.dart';
import 'loading.dart';
import 'qr_code_scanner.dart';
import 'wallet_dialog.dart';

class MerchantToCourierQrCodeScanner extends StatelessWidget {
  final ShipmentTrackingModel model;
  final BuildContext parentContext;
  final String locationId;
  final pref = Preferences.instance;

  MerchantToCourierQrCodeScanner({
    super.key,
    required this.parentContext,
    required this.model,
    required this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    log('${model.merchantId}');
    final ShipmentTrackingProvider trackingProvider =
        Provider.of<ShipmentTrackingProvider>(context);
    final ShipmentProvider shipmentProvider =
        Provider.of<ShipmentProvider>(context);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
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
            'عشان تستلم الشحنة \nلازم تعمل مسح لرمز ال Qrcode \nاو تكتب الكود اللي عند التاجر',
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
                barrierDismissible: false,
                builder: (c) => QrCodeScanner(
                  onDataCallback: (String v) async {
                    if (v.isNotEmpty) {
                      MagicRouter.pop();
                      showDialog(context: c, builder: (c) => const Loading());
                      await trackingProvider
                          .handleReceivingShipmentByValidatingMerchantToCourierHandoverCode(
                              model.shipmentId!, int.parse(v));
                      check(
                          ctx: navigator.currentContext!,
                          state: trackingProvider.state!,
                          auth: authProvider);
                      if (trackingProvider.state == NetworkState.success) {
                        FirebaseFirestore.instance
                            .collection('locations')
                            .doc(locationId)
                            .set({
                          'status': 'receivedShipment',
                          'shipmentId': model.shipmentId,
                        });
                        if (model.hasChildren == 1) {
                          List<String> splittedList = locationId.split('-');
                          String newLocationId =
                              '${splittedList[0]}-${splittedList[1]}-';
                          for (var i
                              in shipmentProvider.bulkShipmentById!.children!) {
                            FirebaseFirestore.instance
                                .collection('locations')
                                .doc('$newLocationId${i.id}')
                                .set({
                              'status': 'receivedShipment',
                              'shipmentId': model.shipmentId,
                            });
                          }
                        }
                        MagicRouter.pop();
                        showDialog(
                            context: navigator.currentContext!,
                            builder: (c) => DoneDialog(
                                  callback: () {
                                    if (model.hasChildren == 1) {
                                      shipmentProvider.getBulkShipmentById(
                                          id: model.shipmentId!,
                                          isFirstTime: false);
                                      MagicRouter.pop();
                                      MagicRouter.pop();
                                    } else {
                                      MagicRouter.pop();
                                    }
                                  },
                                  content: 'تم استلام الشحنة بنجاح',
                                ));
                      } else {
                        MagicRouter.pop();
                        if (trackingProvider.mtcQrCodeError) {
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
