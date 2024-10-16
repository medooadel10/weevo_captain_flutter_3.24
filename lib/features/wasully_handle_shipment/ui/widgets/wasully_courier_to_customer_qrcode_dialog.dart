import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../Dialogs/done_dialog.dart';
import '../../../../Dialogs/loading.dart';
import '../../../../Dialogs/qr_code_scanner.dart';
import '../../../../Dialogs/wallet_dialog.dart';
import '../../../../Models/shipment_tracking_model.dart';
import '../../../../Providers/auth_provider.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../Utilits/colors.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/router/router.dart';
import '../../../../main.dart';
import '../../logic/cubit/wasully_handle_shipment_cubit.dart';
import 'wasully_rating_dialog.dart';

class WasullyCourierToCustomerQrCodeScanner extends StatelessWidget {
  final ShipmentTrackingModel model;
  final BuildContext parentContext;
  final String locationId;

  const WasullyCourierToCustomerQrCodeScanner({
    super.key,
    required this.parentContext,
    required this.model,
    required this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final WasullyHandleShipmentCubit wasullyHandleShipmentCubit =
        context.read();
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
                context: context,
                builder: (c) => QrCodeScanner(
                  onDataCallback: (String v) async {
                    if (v.isNotEmpty) {
                      MagicRouter.pop();
                      showDialog(
                          context: navigator.currentContext!,
                          barrierDismissible: false,
                          builder: (c) => BlocConsumer<
                                  WasullyHandleShipmentCubit,
                                  WasullyHandleShipmentState>(
                                listener: (context, state) async {
                                  if (state
                                      is WasullyHandleShipmentValidateQrCodeSuccess) {
                                    WeevoCaptain.facebookAppEvents.logPurchase(
                                        amount: num.parse(
                                                model.wasullyModel?.amount ??
                                                    '0')
                                            .toDouble(),
                                        currency: 'EGP');
                                    DocumentSnapshot userToken =
                                        await FirebaseFirestore.instance
                                            .collection('merchant_users')
                                            .doc(model.merchantId.toString())
                                            .get();
                                    String token = userToken['fcmToken'];
                                    authProvider.sendNotification(
                                        title: 'تم تسليم شحنتك بنجاح',
                                        body:
                                            'تم تسليم شحنتك بنجاح برجاء تقييم شحنتك مع الكابتن ${authProvider.name}',
                                        toToken: token,
                                        image: authProvider.photo!.isNotEmpty
                                            ? authProvider.photo!.contains(
                                                    ApiConstants.baseUrl)
                                                ? authProvider.photo
                                                : '${ApiConstants.baseUrl}${authProvider.photo}'
                                            : '',
                                        type: 'wasully_rating',
                                        screenTo: '',
                                        data: model.toJson());
                                    MagicRouter.pop();
                                    showDialog(
                                        context: navigator.currentContext!,
                                        barrierDismissible: false,
                                        builder: (c) => DoneDialog(
                                              content: 'تم تسلم الطلب بنجاح',
                                              callback: () {
                                                MagicRouter.pop();
                                                MagicRouter.navigateAndPopAll(
                                                    WasullyRatingDialog(
                                                  model: model,
                                                ));
                                              },
                                            ));
                                  }
                                  if (state
                                      is WasullyHandleShipmentValidateQrCodeError) {
                                    await FirebaseFirestore.instance
                                        .collection('locations')
                                        .doc(locationId)
                                        .set({
                                      'status': 'receivedShipment',
                                      'shipmentId': model.wasullyModel!.slug,
                                    });
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
                              ));
                      await wasullyHandleShipmentCubit
                          .markShipmentAsDeliveredByValidatingCourierToCustomerHandoverCode(
                        model.shipmentId!,
                        int.parse(v),
                        locationId,
                        model.wasullyModel!.slug,
                      );
                      // check(
                      //     auth: _authProvider,
                      //     ctx: context,
                      //     state: trackingProvider.state);
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
