import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Dialogs/done_dialog.dart';
import '../../../../Dialogs/loading.dart';
import '../../../../Dialogs/qr_code_scanner.dart';
import '../../../../Dialogs/wallet_dialog.dart';
import '../../../../Models/shipment_tracking_model.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../Utilits/colors.dart';
import '../../../../core/router/router.dart';
import '../../logic/cubit/wasully_handle_shipment_cubit.dart';

class WasullyMerchantToCourierQrCodeScanner extends StatelessWidget {
  final ShipmentTrackingModel model;
  final BuildContext parentContext;
  final String locationId;
  final pref = Preferences.instance;

  WasullyMerchantToCourierQrCodeScanner({
    super.key,
    required this.parentContext,
    required this.model,
    required this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    log('${model.merchantId}');

    final wasullyHandleShipmentCubit =
        context.read<WasullyHandleShipmentCubit>();
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
            'عشان تستلم الطلب \nلازم تعمل مسح لرمز ال Qrcode \nاو تكتب الكود اللي عند التاجر',
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
                      MagicRouter.pop();
                      showDialog(
                        context: navigator.currentContext!,
                        builder: (c) => BlocConsumer<WasullyHandleShipmentCubit,
                            WasullyHandleShipmentState>(
                          listener: (context, state) {
                            if (state
                                is WasullyHandleShipmentValidateQrCodeSuccess) {
                              MagicRouter.pop();
                              showDialog(
                                  context: navigator.currentContext!,
                                  builder: (c) => DoneDialog(
                                        callback: () {
                                          MagicRouter.pop();
                                        },
                                        content: 'تم استلام الطلب بنجاح',
                                      ));
                            }
                            if (state
                                is WasullyHandleShipmentValidateQrCodeError) {
                              MagicRouter.pop();
                              showDialog(
                                context: navigator.currentContext!,
                                builder: (context) => WalletDialog(
                                  msg: state.error,
                                  onPress: () {
                                    MagicRouter.pop();
                                  },
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return const Loading();
                          },
                        ),
                        barrierDismissible: false,
                      );
                      await wasullyHandleShipmentCubit
                          .handleReceiveShipmentByValidatingHandoverCodeFromMerchantToCourier(
                        model.shipmentId!,
                        int.parse(v),
                        locationId,
                        model.wasullyModel!.slug,
                      );
                      // check(
                      //     ctx: c,
                      //     state: trackingProvider.state,
                      //     auth: authProvider);
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
