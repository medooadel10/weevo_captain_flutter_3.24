import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weevo_captain_app/Providers/auth_provider.dart';
import 'package:weevo_captain_app/Providers/wallet_provider.dart';
import 'package:weevo_captain_app/core/router/router.dart';

import '../../../../../Dialogs/action_dialog.dart';
import '../../../../../Dialogs/inside_offer_dialog.dart';
import '../../../../../Dialogs/no_credit_dialog.dart';
import '../../../../../Dialogs/offer_confirmation_dialog.dart';
import '../../../../../Dialogs/update_offer_dialog.dart';
import '../../../../../Dialogs/update_offer_request_dialog.dart';
import '../../../../../Models/shipment_notification.dart';
import '../../../../../Models/shipment_tracking_model.dart';
import '../../../../../Providers/shipment_provider.dart';
import '../../../../../Screens/wallet.dart';
import '../../../../../Storage/shared_preference.dart';
import '../../../../../Utilits/colors.dart';
import '../../../../../Widgets/weevo_button.dart';
import '../../../../../core/networking/api_constants.dart';
import '../../../../../main.dart';
import '../../../logic/cubit/shipment_details_cubit.dart';

class ShipmentShippingBtn extends StatelessWidget {
  const ShipmentShippingBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShipmentDetailsCubit>();
    final walletProvider = context.read<WalletProvider>();
    final AuthProvider authProvider = context.read<AuthProvider>();
    final shipmentProvider = context.read<ShipmentProvider>();
    if (cubit.shipmentDetails!.isOfferBased == 1 &&
        cubit.shipmentDetails!.parentId == 0) {
      return SizedBox(
        width: double.infinity,
        child: WeevoButton(
          onTap: () async {
            showDialog(
              context: context,
              builder: (context) => InsideOfferDialog(
                onShippingCostPressed:
                    (String v, String shippingCost, String shippingAmount) {
                  log('onShippingCostPressed -> $v');
                  walletProvider.agreedAmount =
                      double.parse(shippingCost).toInt();
                  if (v == 'DONE') {
                    showDialog(
                        context: context,
                        builder: (c) => OfferConfirmationDialog(
                              onOkPressed: () async {
                                MagicRouter.pop();
                                await cubit.getShipmentDetails(
                                    cubit.shipmentDetails!.id);
                                WeevoCaptain.facebookAppEvents
                                    .logInitiatedCheckout(
                                        totalPrice: num.parse(
                                                cubit.shipmentDetails!.amount)
                                            .toDouble(),
                                        currency: 'EGP');
                                DocumentSnapshot userToken =
                                    await FirebaseFirestore
                                        .instance
                                        .collection('merchant_users')
                                        .doc(cubit.shipmentDetails!.merchant!.id
                                            .toString())
                                        .get();
                                String token = userToken['fcmToken'];
                                FirebaseFirestore.instance
                                    .collection('merchant_notifications')
                                    .doc(cubit.shipmentDetails!.merchantId
                                        .toString())
                                    .collection(cubit
                                        .shipmentDetails!.merchant!.id
                                        .toString())
                                    .add({
                                  'read': false,
                                  'date_time': DateTime.now().toIso8601String(),
                                  'type': 'cancel_shipment',
                                  'title': 'ويفو وفرلك كابتن',
                                  'body':
                                      'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالشحنة',
                                  'user_icon': authProvider.photo!.isNotEmpty
                                      ? authProvider.photo!
                                              .contains(ApiConstants.baseUrl)
                                          ? authProvider.photo
                                          : '${ApiConstants.baseUrl}${authProvider.photo}'
                                      : '',
                                  'screen_to': 'shipment_screen',
                                  'cubit': ShipmentTrackingModel(
                                          shipmentId: cubit.shipmentDetails!.id,
                                          hasChildren: 1)
                                      .toJson(),
                                });
                                authProvider.sendNotification(
                                    title: 'ويفو وفرلك كابتن',
                                    body:
                                        'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالشحنة',
                                    toToken: token,
                                    image: authProvider.photo!.isNotEmpty
                                        ? authProvider.photo!
                                                .contains(ApiConstants.baseUrl)
                                            ? authProvider.photo
                                            : '${ApiConstants.baseUrl}${authProvider.photo}'
                                        : '',
                                    data: ShipmentTrackingModel(
                                            shipmentId:
                                                cubit.shipmentDetails!.id,
                                            hasChildren: 1)
                                        .toJson(),
                                    screenTo: 'shipment_screen',
                                    type: 'cancel_shipment');
                              },
                              isDone: true,
                              isOffer: true,
                            ));
                  } else {
                    if (shipmentProvider.noCredit ?? false) {
                      showDialog(
                          context: navigator.currentContext!,
                          builder: (c) => NoCreditDialog(
                                onOkCancelCallback: () {
                                  Navigator.pop(c);
                                },
                                onChargeWalletCallback: () {
                                  Navigator.pop(c);
                                  walletProvider.setMainIndex(1);
                                  walletProvider.setDepositAmount(
                                      num.parse(cubit.shipmentDetails!.amount)
                                          .toInt());
                                  walletProvider.setDepositIndex(1);
                                  walletProvider.fromOfferPage = true;
                                  Navigator.pushReplacementNamed(c, Wallet.id);
                                },
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) => OfferConfirmationDialog(
                                onOkPressed: () async {
                                  Navigator.pop(c);
                                },
                                isDone: false,
                                isOffer: false,
                              ));
                    }
                  }
                },
                onShippingOfferPressed:
                    (String v, int offer, String totalCost) {
                  log('onShippingOfferPressed -> $v');
                  walletProvider.agreedAmount = offer;

                  if (v == 'DONE') {
                    if (authProvider.updateOffer ?? false) {
                      showDialog(
                          context: context,
                          builder: (c) => UpdateOfferRequestDialog(
                                onBetterOfferCallback: () {
                                  Navigator.pop(c);
                                  showDialog(
                                      context: c,
                                      builder: (ct) => UpdateOfferDialog(
                                            onBetterShippingOfferPressed:
                                                (String v, int offer,
                                                    String totalCost) {
                                              if (v == 'DONE') {
                                                showDialog(
                                                    context: ct,
                                                    builder: (cx) =>
                                                        OfferConfirmationDialog(
                                                          isOffer: true,
                                                          onOkPressed:
                                                              () async {
                                                            Navigator.pop(cx);
                                                            DocumentSnapshot
                                                                userToken =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'merchant_users')
                                                                    .doc(
                                                                      cubit
                                                                          .shipmentDetails!
                                                                          .merchantId
                                                                          .toString(),
                                                                    )
                                                                    .get();
                                                            String token =
                                                                userToken[
                                                                    'fcmToken'];
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'merchant_notifications')
                                                                .doc(cubit
                                                                    .shipmentDetails!
                                                                    .merchantId
                                                                    .toString())
                                                                .collection(cubit
                                                                    .shipmentDetails!
                                                                    .merchantId
                                                                    .toString())
                                                                .add({
                                                              'read': false,
                                                              'date_time': DateTime
                                                                      .now()
                                                                  .toIso8601String(),
                                                              'type': '',
                                                              'title':
                                                                  'عرض أفضل',
                                                              'body':
                                                                  'تم تقديم عرض أفضل من الكابتن ${authProvider.name}',
                                                              'user_icon': authProvider
                                                                      .photo!
                                                                      .isNotEmpty
                                                                  ? authProvider
                                                                          .photo!
                                                                          .contains(ApiConstants
                                                                              .baseUrl)
                                                                      ? authProvider
                                                                          .photo
                                                                      : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                  : '',
                                                              'screen_to':
                                                                  'shipment_offers',
                                                              'cubit':
                                                                  ShipmentNotification(
                                                                receivingState: cubit
                                                                    .shipmentDetails!
                                                                    .receivingState,
                                                                receivingCity:
                                                                    null,
                                                                deliveryState: cubit
                                                                    .shipmentDetails!
                                                                    .deliveringState,
                                                                deliveryCity:
                                                                    null,
                                                                totalShipmentCost:
                                                                    cubit
                                                                        .shipmentDetails!
                                                                        .amount,
                                                                shipmentId: cubit
                                                                    .shipmentDetails!
                                                                    .id,
                                                                merchantImage: cubit
                                                                    .shipmentDetails!
                                                                    .merchant!
                                                                    .photo,
                                                                merchantName: cubit
                                                                    .shipmentDetails!
                                                                    .merchant!
                                                                    .name,
                                                                childrenShipment:
                                                                    0,
                                                                shippingCost: cubit
                                                                    .shipmentDetails!
                                                                    .expectedShippingCost,
                                                              ).toMap(),
                                                            });
                                                            authProvider.sendNotification(
                                                                title: 'عرض أفضل',
                                                                body: 'تم تقديم عرض أفضل من الكابتن ${authProvider.name}',
                                                                toToken: token,
                                                                image: authProvider.photo!.isNotEmpty
                                                                    ? authProvider.photo!.contains(ApiConstants.baseUrl)
                                                                        ? authProvider.photo
                                                                        : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                    : '',
                                                                type: '',
                                                                screenTo: 'shipment_offers',
                                                                data: ShipmentNotification(
                                                                  receivingState: cubit
                                                                      .shipmentDetails!
                                                                      .receivingState,
                                                                  receivingCity:
                                                                      null,
                                                                  deliveryState: cubit
                                                                      .shipmentDetails!
                                                                      .deliveringState,
                                                                  deliveryCity:
                                                                      null,
                                                                  totalShipmentCost: cubit
                                                                      .shipmentDetails!
                                                                      .amount,
                                                                  shipmentId: cubit
                                                                      .shipmentDetails!
                                                                      .id,
                                                                  merchantImage: cubit
                                                                      .shipmentDetails!
                                                                      .merchant!
                                                                      .photo,
                                                                  merchantName: cubit
                                                                      .shipmentDetails!
                                                                      .merchant!
                                                                      .name,
                                                                  childrenShipment:
                                                                      0,
                                                                  shippingCost: cubit
                                                                      .shipmentDetails!
                                                                      .expectedShippingCost,
                                                                ).toMap());
                                                          },
                                                          isDone: true,
                                                        ));
                                              } else {
                                                if (authProvider
                                                    .betterOfferIsBiggerThanLastOne) {
                                                  showDialog(
                                                      context: ct,
                                                      builder: (cx) =>
                                                          ActionDialog(
                                                            content: authProvider
                                                                .betterOfferMessage,
                                                            onApproveClick: () {
                                                              Navigator.pop(cx);
                                                            },
                                                            approveAction:
                                                                'حسناً',
                                                          ));
                                                } else {
                                                  showDialog(
                                                      context: ct,
                                                      builder: (cx) =>
                                                          OfferConfirmationDialog(
                                                            isOffer: true,
                                                            onOkPressed: () {
                                                              Navigator.pop(cx);
                                                            },
                                                            isDone: false,
                                                          ));
                                                }
                                              }
                                            },
                                            shipmentNotification:
                                                ShipmentNotification(
                                              receivingState: cubit
                                                  .shipmentDetails!
                                                  .receivingState,
                                              receivingCity: null,
                                              deliveryState: cubit
                                                  .shipmentDetails!
                                                  .deliveringState,
                                              deliveryCity: null,
                                              shipmentId:
                                                  cubit.shipmentDetails!.id,
                                              offerId: authProvider.offerId,
                                              totalShipmentCost:
                                                  cubit.shipmentDetails!.amount,
                                              merchantImage: cubit
                                                  .shipmentDetails!
                                                  .merchant!
                                                  .photo,
                                              merchantName: cubit
                                                  .shipmentDetails!
                                                  .merchant!
                                                  .name,
                                              childrenShipment: 0,
                                              shippingCost: cubit
                                                  .shipmentDetails!
                                                  .expectedShippingCost,
                                            ),
                                          ));
                                },
                                onCancelCallback: () {
                                  Navigator.pop(c);
                                },
                                message: authProvider.message!,
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) => OfferConfirmationDialog(
                                isOffer: true,
                                onOkPressed: () async {
                                  Navigator.pop(c);
                                  DocumentSnapshot userToken =
                                      await FirebaseFirestore.instance
                                          .collection('merchant_users')
                                          .doc(cubit.shipmentDetails!.merchantId
                                              .toString())
                                          .get();
                                  String token = userToken['fcmToken'];
                                  FirebaseFirestore.instance
                                      .collection('merchant_notifications')
                                      .doc(cubit.shipmentDetails!.merchantId
                                          .toString())
                                      .collection(cubit
                                          .shipmentDetails!.merchantId
                                          .toString())
                                      .add({
                                    'read': false,
                                    'date_time':
                                        DateTime.now().toIso8601String(),
                                    'type': '',
                                    'title': 'عرض جديد',
                                    'body':
                                        'تم تقديم عرض جديد من الكابتن ${authProvider.name}',
                                    'user_icon': authProvider.photo!.isNotEmpty
                                        ? authProvider.photo!
                                                .contains(ApiConstants.baseUrl)
                                            ? authProvider.photo
                                            : '${ApiConstants.baseUrl}${authProvider.photo}'
                                        : '',
                                    'screen_to': 'shipment_offers',
                                    'cubit': ShipmentNotification(
                                      receivingState:
                                          cubit.shipmentDetails!.receivingState,
                                      receivingCity: null,
                                      deliveryState: cubit
                                          .shipmentDetails!.deliveringState,
                                      deliveryCity: null,
                                      totalShipmentCost:
                                          cubit.shipmentDetails!.amount,
                                      shipmentId: cubit.shipmentDetails!.id,
                                      merchantImage: cubit
                                          .shipmentDetails!.merchant!.photo,
                                      merchantName:
                                          cubit.shipmentDetails!.merchant!.name,
                                      childrenShipment: 0,
                                      shippingCost: cubit.shipmentDetails!
                                          .expectedShippingCost,
                                    ).toMap(),
                                  });
                                  authProvider.sendNotification(
                                      title: 'عرض جديد',
                                      body:
                                          'تم تقديم عرض جديد من الكابتن ${authProvider.name}',
                                      toToken: token,
                                      image: authProvider.photo!.isNotEmpty
                                          ? authProvider.photo!.contains(
                                                  ApiConstants.baseUrl)
                                              ? authProvider.photo
                                              : '${ApiConstants.baseUrl}${authProvider.photo}'
                                          : '',
                                      type: '',
                                      screenTo: 'shipment_offers',
                                      data: ShipmentNotification(
                                              receivingState: cubit
                                                  .shipmentDetails!
                                                  .receivingState,
                                              receivingCity: null,
                                              deliveryState: cubit
                                                  .shipmentDetails!
                                                  .deliveringState,
                                              deliveryCity: null,
                                              shipmentId:
                                                  cubit.shipmentDetails!.id,
                                              merchantImage: cubit
                                                  .shipmentDetails!
                                                  .merchant!
                                                  .photo,
                                              merchantName: cubit
                                                  .shipmentDetails!
                                                  .merchant!
                                                  .name,
                                              childrenShipment: 0,
                                              shippingCost: cubit
                                                  .shipmentDetails!
                                                  .expectedShippingCost,
                                              totalShipmentCost:
                                                  cubit.shipmentDetails!.amount)
                                          .toMap());
                                },
                                isDone: true,
                              ));
                    }
                  } else {
                    if (authProvider.noCredit) {
                      showDialog(
                          context: context,
                          builder: (c) => NoCreditDialog(
                                onOkCancelCallback: () {
                                  Navigator.pop(c);
                                },
                                onChargeWalletCallback: () {
                                  Navigator.pop(c);
                                  walletProvider.setMainIndex(1);
                                  walletProvider.setDepositAmount(
                                      num.parse(cubit.shipmentDetails!.amount)
                                          .toInt());
                                  walletProvider.setDepositIndex(1);
                                  walletProvider.fromOfferPage = true;
                                  Navigator.pushReplacementNamed(c, Wallet.id);
                                },
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (c) => OfferConfirmationDialog(
                                onOkPressed: () {
                                  Navigator.pop(c);
                                },
                                isOffer: true,
                                isDone: false,
                              ));
                    }
                  }
                },
                shipmentNotification: ShipmentNotification(
                  shipmentId: cubit.shipmentDetails!.id,
                  shippingCost:
                      cubit.shipmentDetails!.expectedShippingCost.toString(),
                  totalShipmentCost: cubit.shipmentDetails!.amount,
                  merchantImage: cubit.shipmentDetails!.merchant!.photo,
                  flags: cubit.shipmentDetails!.flags,
                  merchantName: cubit.shipmentDetails!.merchant!.name,
                  childrenShipment: 0,
                ),
              ),
            );
          },
          title: 'قدم عرض',
          color: weevoPrimaryOrangeColor,
          isStable: true,
        ),
      );
    }
    return Container();
  }
}
