import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/helpers/extensions.dart';

import '../Models/shipment_notification.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Providers/wallet_provider.dart';
import '../Screens/child_shipment_details.dart';
import '../Screens/wallet.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../core/networking/api_constants.dart';
import '../core/router/router.dart';
import '../features/shipment_details/ui/shipment_details_screen.dart';
import '../features/wasully_details/ui/wasully_details_screen.dart';
import '../features/wasully_details/ui/widgets/wasully_offer_dialog.dart';
import 'content_dialog.dart';
import 'no_credit_dialog.dart';
import 'offer_confirmation_dialog.dart';
import 'offer_dialog.dart';

class ShipmentDialog extends StatelessWidget {
  final VoidCallback onRefuseShipment;
  final VoidCallback onOfferOkPressed;
  final VoidCallback onAvailableOkPressed;
  final VoidCallback onDetailsCallback;
  final ShipmentNotification shipmentNotification;
  final bool betterOffer;
  final bool isWasully;
  final String? merchantPhone;
  const ShipmentDialog({
    super.key,
    required this.onRefuseShipment,
    required this.onAvailableOkPressed,
    required this.onOfferOkPressed,
    required this.onDetailsCallback,
    required this.shipmentNotification,
    required this.betterOffer,
    this.isWasully = false,
    this.merchantPhone,
  });

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of(context);
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    final ShipmentProvider shipmentProvider =
        Provider.of<ShipmentProvider>(context);
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: shipmentNotification.merchantImage == null ||
                          shipmentNotification.merchantImage!.isEmpty
                      ? const AssetImage('assets/images/profile_picture.png')
                      : NetworkImage(
                          shipmentNotification.merchantImage!
                                  .contains(ApiConstants.baseUrl)
                              ? shipmentNotification.merchantImage!
                              : '${ApiConstants.baseUrl}${shipmentNotification.merchantImage}',
                        ),
                ),
                SizedBox(
                  width: 10.0.w,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shipmentNotification.merchantName!,
                        style: const TextStyle(
                          color: weevoBlack,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                shipmentNotification.childrenShipment! > 0
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: weevoPrimaryOrangeColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(14.0.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0.w,
                          vertical: 5.0.h,
                        ),
                        child: Text(
                          '${shipmentNotification.childrenShipment} طلبات',
                          style: const TextStyle(
                            color: weevoPrimaryOrangeColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      shipmentNotification.childrenShipment! > 0
                          ? 'تكلفة الشحن الكلية'
                          : 'تكلفة الشحن',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${double.parse(shipmentNotification.shippingCost!).toInt()}',
                      style: TextStyle(
                        color: weevoPrimaryBlueColor,
                        fontSize: 30.0.sp,
                        height: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'جنية',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.0.sp,
                        height: 0.9,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      shipmentNotification.childrenShipment! > 0
                          ? 'مقدم الطلبات الكلية'
                          : 'مقدم الطلب',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${double.parse(shipmentNotification.totalShipmentCost!).toInt()}',
                      style: TextStyle(
                        color: weevoPrimaryBlueColor,
                        fontSize: 30.0.sp,
                        height: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'جنية',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.0.sp,
                        height: 0.9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            (shipmentNotification.deliveryCity != null &&
                    shipmentNotification.receivingCity != null)
                ? Column(
                    children: [
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            shipmentNotification.deliveryState!.isInt()
                                ? authProvider.getStateNameById(int.parse(
                                        shipmentNotification.deliveryState!)) ??
                                    ''
                                : shipmentNotification.deliveryState!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 10.0.w,
                          ),
                          Text(
                            shipmentNotification.receivingState!.isInt()
                                ? authProvider.getStateNameById(int.parse(
                                        shipmentNotification
                                            .receivingState!)) ??
                                    ''
                                : shipmentNotification.receivingState!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            shipmentNotification.receivingState!.isInt()
                                ? authProvider.getCityNameById(
                                        int.parse(shipmentNotification
                                            .receivingState!),
                                        int.parse(shipmentNotification
                                            .receivingCity!)) ??
                                    ''
                                : shipmentNotification.receivingCity!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 10.0.w,
                          ),
                          Row(
                            children: List.generate(
                              25,
                              (index) => Container(
                                height: 3.0,
                                width: 3.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 1.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0.w,
                          ),
                          Text(
                            shipmentNotification.deliveryState!.isInt()
                                ? authProvider.getCityNameById(
                                        int.parse(shipmentNotification
                                            .deliveryState!),
                                        int.parse(shipmentNotification
                                            .deliveryCity!)) ??
                                    ''
                                : shipmentNotification.deliveryCity!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        authProvider.getStateNameById(int.parse(
                                shipmentNotification.deliveryState!)) ??
                            '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 10.0.w,
                      ),
                      Text(
                        authProvider.getStateNameById(int.parse(
                                shipmentNotification.receivingState!)) ??
                            '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
            SizedBox(
              height: 10.0.h,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onRefuseShipment,
                    style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all<Size>(
                            const Size(100.0, 45.0)),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(0.0)),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.red,
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        )),
                    child: Text(
                      'رفض',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.0.w,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onDetailsCallback();
                      MagicRouter.pop();
                      if (isWasully) {
                        MagicRouter.navigateTo(
                          WasullyDetailsScreen(
                            id: shipmentNotification.shipmentId!,
                          ),
                        );
                      } else {
                        if (shipmentNotification.childrenShipment! > 0) {
                          Navigator.pushNamed(
                            context,
                            ChildShipmentDetails.id,
                            arguments: shipmentNotification.shipmentId,
                          );
                        }
                        {
                          MagicRouter.navigateTo(ShipmentDetailsScreen(
                            id: shipmentNotification.shipmentId!,
                          ));
                        }
                      }
                    },
                    style: ButtonStyle(
                      fixedSize: WidgetStateProperty.all<Size>(
                          const Size(100.0, 45.0)),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(0.0)),
                      backgroundColor: WidgetStateProperty.all<Color>(
                        weevoPrimaryBlueColor,
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'التفاصيل',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0.sp,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.0.w,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      MagicRouter.pop();
                      if (isWasully) {
                        showDialog(
                            context: context,
                            builder: (c) => WasullyOfferDialog(
                                  merchantImage:
                                      shipmentNotification.merchantImage!,
                                  merchantName:
                                      shipmentNotification.merchantName!,
                                  price: shipmentNotification.shippingCost!,
                                  wasullyId: shipmentNotification.shipmentId!,
                                  merchantRating: '4.5',
                                ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => OfferDialog(
                            betterOffer: betterOffer,
                            shipmentNotification: shipmentNotification,
                            onShippingCostPressed: (String v,
                                String shippingCost, String shippingAmount) {
                              log('onShippingCostPressed -> $v');
                              walletProvider.agreedAmount =
                                  double.parse(shippingCost).toInt();
                              if (v == 'DONE') {
                                showDialog(
                                    context: navigator.currentContext!,
                                    builder: (c) => OfferConfirmationDialog(
                                          onOkPressed: () async {
                                            Navigator.pop(c);
                                            onAvailableOkPressed();
                                            // await authProvider
                                            //     .sendNotification(
                                            //     title:
                                            //     'ويفو وفرلك مندوب',
                                            //     body:
                                            //     'المندوب ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالطلب',
                                            //     toToken: token,
                                            //     image: authProvider
                                            //         .photo
                                            //         .isNotEmpty
                                            //         ? authProvider
                                            //         .photo
                                            //         .contains(
                                            //         base_url)
                                            //         ? authProvider
                                            //         .photo
                                            //         : '$base_url${authProvider.photo}'
                                            //         : '',
                                            //     data: ShipmentTrackingModel(
                                            //         shipmentId: widget
                                            //             .bulkShipment
                                            //             .id,
                                            //         hasChildren:
                                            //         1)
                                            //         .toJson(),
                                            //     screenTo:
                                            //     'shipment_screen',
                                            //     type:
                                            //     'cancel_shipment');
                                          },
                                          isDone: true,
                                          isOffer: false,
                                        ));
                              } else {
                                if (shipmentProvider.noCredit!) {
                                  showDialog(
                                      context: navigator.currentContext!,
                                      builder: (c) => NoCreditDialog(
                                            onOkCancelCallback: () {
                                              Navigator.pop(c);
                                              onAvailableOkPressed();
                                            },
                                            onChargeWalletCallback: () {
                                              Navigator.pop(c);
                                              walletProvider.setMainIndex(1);
                                              walletProvider.setDepositAmount(
                                                  num.parse(shipmentNotification
                                                          .totalShipmentCost!)
                                                      .toInt());
                                              walletProvider.setDepositIndex(1);
                                              walletProvider.fromOfferPage =
                                                  true;
                                              Navigator.pushReplacementNamed(
                                                  c, Wallet.id);
                                            },
                                          ));
                                } else {
                                  showDialog(
                                      context: navigator.currentContext!,
                                      builder: (c) => OfferConfirmationDialog(
                                            onOkPressed: () async {
                                              Navigator.pop(c);
                                              onAvailableOkPressed();
                                            },
                                            isDone: false,
                                            isOffer: false,
                                          ));
                                }
                              }
                            },
                            onShippingOfferPressed:
                                (String v, int offer, String totalShipment) {
                              walletProvider.agreedAmount = offer;

                              if (v == 'DONE') {
                                showDialog(
                                    context: navigator.currentContext!,
                                    builder: (c) => OfferConfirmationDialog(
                                          isOffer: true,
                                          onOkPressed: () async {
                                            Navigator.pop(c);
                                            onOfferOkPressed();
                                          },
                                          isDone: true,
                                        ));
                              } else {
                                if (authProvider.noCredit) {
                                  showDialog(
                                      context: navigator.currentContext!,
                                      barrierDismissible: false,
                                      builder: (c) => NoCreditDialog(
                                            onOkCancelCallback: () {
                                              Navigator.pop(c);
                                              onOfferOkPressed();
                                            },
                                            onChargeWalletCallback: () {
                                              Navigator.pop(c);
                                              walletProvider.setMainIndex(1);
                                              walletProvider.setDepositAmount(
                                                  num.parse(shipmentNotification
                                                          .totalShipmentCost!)
                                                      .toInt());
                                              walletProvider.setDepositIndex(1);
                                              walletProvider.fromOfferPage =
                                                  true;
                                              Navigator.pushReplacementNamed(
                                                  c, Wallet.id);
                                            },
                                          ));
                                } else {
                                  showDialog(
                                      context: navigator.currentContext!,
                                      builder: (c) => OfferConfirmationDialog(
                                            isOffer: true,
                                            onOkPressed: () {
                                              Navigator.pop(c);
                                              onOfferOkPressed();
                                            },
                                            isDone: false,
                                          ));
                                }
                              }
                            },
                          ),
                          barrierDismissible: false,
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        weevoPrimaryOrangeColor,
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(0.0)),
                      fixedSize: WidgetStateProperty.all<Size>(
                          const Size(100.0, 45.0)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'تقديم عرض',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0.sp,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getMezaStatus(
      {required WalletProvider walletProvider,
      required AuthProvider authProvider,
      required String value}) async {
    log(value);
    log('${walletProvider.meezaCard!.transaction!.id}');
    Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      log('t');
      await walletProvider.checkPaymentStatus(
          systemReferenceNumber: value,
          transactionId: walletProvider.meezaCard!.transaction!.id!);
      if (walletProvider.state == NetworkState.success) {
        log('success');
        if (walletProvider.creditStatus!.status == 'completed') {
          log('status compeleted');
          if (t.isActive) {
            t.cancel();
            log('timer cancelled');
          }
          log(walletProvider.creditStatus!.status!);
          await walletProvider.getCurrentBalance(
              authorization: authProvider.appAuthorization!,
              fromRefresh: false);
          Navigator.pop(navigator.currentContext!);
          showDialog(
              context: navigator.currentContext!,
              barrierDismissible: false,
              builder: (context) => ContentDialog(
                    content:
                        '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider.meezaCard!.transaction!.amount}\nيمكنك الان التقديم على الطلب مرة اخرى',
                    callback: () {
                      Navigator.pop(context);
                      walletProvider.setDepositIndex(5);
                      walletProvider.setAccountTypeIndex(null);
                    },
                  ));
        } else {
          log('not compeleted');
        }
      } else {
        log('else');
        if (t.isActive) {
          t.cancel();
          log('timer cancelled');
        }
        Navigator.pop(navigator.currentContext!);
        showDialog(
          context: navigator.currentContext!,
          barrierDismissible: false,
          builder: (context) => ContentDialog(
            content: 'برجاء التأكد من وجود رصيد كافي',
            callback: () {
              Navigator.pop(context);
            },
          ),
        );
      }
    });
  }
}
