import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';
import 'package:weevo_captain_app/core/router/router.dart';
import 'package:weevo_captain_app/features/available_shipments/ui/screens/available_shipments_screen.dart';
import 'package:weevo_captain_app/features/shipment_details/ui/shipment_details_screen.dart';

import '../Dialogs/action_dialog.dart';
import '../Dialogs/loading.dart';
import '../Dialogs/shipment_dialog.dart';
import '../Dialogs/wallet_dialog.dart';
import '../Models/accept_merchant_offer.dart';
import '../Models/chat_data.dart';
import '../Models/shipment_notification.dart';
import '../Models/shipment_tracking_model.dart';
import '../Providers/auth_provider.dart';
import '../Screens/chat_screen.dart';
import '../Screens/child_shipment_details.dart';
import '../Screens/handle_shipment.dart';
import '../Screens/wallet.dart';
import '../core/networking/api_constants.dart';
import '../features/wasully_details/logic/cubit/wasully_details_cubit.dart';
import 'constants.dart';

const String shipmentScreen = 'shipment_screen';
const String shipmentDetailsScreen = 'shipment_details_screen';
const String createShipmentScreen = 'available_shipment_screen';
const String homeScreen = 'home_screen';
const String wallet = 'wallet';
const String noScreen = 'no_screen';
const String walletScreen = 'wallet_screen';
const String chatScreen = 'chat_screen';
const String handleShipmentScreen = 'handle_shipment_screen';
const String weevoPlusScreen = 'weevo_plus_screen';

void whereTo(BuildContext ctx, String link) {
  switch (link) {
    case 'screen://wallet_screen':
      Navigator.pushNamed(ctx, Wallet.id);
      break;
    case 'screen://available_shipments_screen':
      MagicRouter.navigateTo(const AvailableShipmentsScreen());
      break;
  }
}

void notificationNavigation(
    BuildContext ctx,
    String type,
    Map<String, dynamic> data,
    String title,
    AuthProvider auth,
    WasullyDetailsCubit cubit) async {
  switch (type) {
    case 'cancel_shipment':
      showDialog(
          context: ctx,
          builder: (c) => ActionDialog(
                content:
                    'تم الغاء الطلب من قبل التاجر\nيمكنك التقديم علي طلبات اخري\nمن صفحة الطلبات المتاحة',
                approveAction: 'حسناً',
                onApproveClick: () {
                  Navigator.pop(c);
                },
              ));
      break;
    case '':
      showDialog(
          context: ctx,
          barrierDismissible: false,
          builder: (context) => const Loading());
      await auth.getShipmentStatus(data['shipment_id']);
      if (auth.shipmentStatusState == NetworkState.success) {
        Navigator.pop(navigator.currentContext!);
        if (title == 'عرض أفضل') {
          if (auth.stillAvailable) {
            ShipmentNotification shipmentNotification =
                ShipmentNotification.fromMap(data);
            showDialog(
                context: navigator.currentContext!,
                barrierDismissible: false,
                builder: (c) {
                  return ShipmentDialog(
                    shipmentNotification: ShipmentNotification.fromMap(data),
                    betterOffer: true,
                    onDetailsCallback: () {},
                    onAvailableOkPressed: () async {
                      DocumentSnapshot userToken = await FirebaseFirestore
                          .instance
                          .collection('merchant_users')
                          .doc(shipmentNotification.merchantId.toString())
                          .get();
                      String token = userToken['fcmToken'];
                      FirebaseFirestore.instance
                          .collection('merchant_notifications')
                          .doc(shipmentNotification.merchantId.toString())
                          .collection(
                              shipmentNotification.merchantId.toString())
                          .add({
                        'read': false,
                        'date_time': DateTime.now().toIso8601String(),
                        'type': '',
                        'title': 'ويفو وفرلك مندوب',
                        'body':
                            'الكابتن ${auth.name} قبل طلب الشحن وتم خصم مقدمالطلب',
                        'user_icon':
                            auth.photo != null && auth.photo!.isNotEmpty
                                ? auth.photo!.contains(ApiConstants.baseUrl)
                                    ? auth.photo
                                    : '${ApiConstants.baseUrl}${auth.photo}'
                                : '',
                        'screen_to': 'shipment_offers',
                        'data': shipmentNotification.toMap(),
                      });
                      auth.sendNotification(
                          title: 'ويفو وفرلك كابتن',
                          body:
                              'الكابتن ${auth.name} قبل طلب الشحن وتم خصم مقدمالطلب',
                          toToken: token,
                          image: auth.photo != null && auth.photo!.isNotEmpty
                              ? auth.photo!.contains(ApiConstants.baseUrl)
                                  ? auth.photo
                                  : '${ApiConstants.baseUrl}${auth.photo}'
                              : '',
                          type: '',
                          screenTo: 'shipment_offers',
                          data: shipmentNotification.toMap());
                    },
                    onOfferOkPressed: () async {
                      DocumentSnapshot userToken = await FirebaseFirestore
                          .instance
                          .collection('merchant_users')
                          .doc(shipmentNotification.merchantId.toString())
                          .get();
                      String token = userToken['fcmToken'];
                      FirebaseFirestore.instance
                          .collection('merchant_notifications')
                          .doc(shipmentNotification.merchantId.toString())
                          .collection(
                              shipmentNotification.merchantId.toString())
                          .add({
                        'read': false,
                        'date_time': DateTime.now().toIso8601String(),
                        'type': '',
                        'title': 'عرض أفضل',
                        'body': 'تم تقديم عرض أفضل من الكابتن ${auth.name}',
                        'user_icon':
                            auth.photo != null && auth.photo!.isNotEmpty
                                ? auth.photo!.contains(ApiConstants.baseUrl)
                                    ? auth.photo
                                    : '${ApiConstants.baseUrl}${auth.photo}'
                                : '',
                        'screen_to': 'shipment_offers',
                        'data': shipmentNotification.toMap(),
                      });
                      auth.sendNotification(
                          title: 'عرض أفضل',
                          body: 'تم تقديم عرض أفضل من الكابتن ${auth.name}',
                          toToken: token,
                          image: auth.photo != null && auth.photo!.isNotEmpty
                              ? auth.photo!.contains(ApiConstants.baseUrl)
                                  ? auth.photo
                                  : '${ApiConstants.baseUrl}${auth.photo}'
                              : '',
                          type: '',
                          screenTo: 'shipment_offers',
                          data: shipmentNotification.toMap());
                    },
                    onRefuseShipment: () {
                      Navigator.pop(ctx);
                    },
                  );
                });
          } else {
            showDialog(
                context: navigator.currentContext!,
                builder: (c) => ActionDialog(
                      content:
                          'هذه الطلب غير متاحة للتقديم\nعليها يمكنك التقديم علي طلبات اخري\nفي الطلبات الجديدة',
                      approveAction: 'حسناً',
                      onApproveClick: () {
                        Navigator.pop(c);
                      },
                    ));
          }
        } else {
          if (auth.canGoInside) {
            if (AcceptMerchantOffer.fromMap(data).childrenShipment == 0) {
              MagicRouter.navigateTo(ShipmentDetailsScreen(
                id: AcceptMerchantOffer.fromMap(data).shipmentId,
              ));
            } else {
              Navigator.pushNamed(
                  navigator.currentContext!, ChildShipmentDetails.id,
                  arguments: AcceptMerchantOffer.fromMap(data).shipmentId);
            }
          } else {
            showDialog(
                context: navigator.currentContext!,
                builder: (c) => ActionDialog(
                      content:
                          'تم الغاء الطلب من قبل التاجر\nيمكنك التقديم علي طلبات اخري\nمن صفحة الطلبات المتاحة',
                      approveAction: 'حسناً',
                      onApproveClick: () {
                        Navigator.pop(c);
                      },
                    ));
          }
        }
      } else {
        Navigator.pop(navigator.currentContext!);
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
      break;
    case 'tracking':
      Navigator.pushNamed(ctx, HandleShipment.id,
          arguments: ShipmentTrackingModel.fromJson(data));
      break;
    case 'wallet':
      Navigator.pushNamed(
        ctx,
        Wallet.id,
      );
      break;
    case 'chat':
      Navigator.pushNamed(ctx, ChatScreen.id,
          arguments: ChatData.fromJson(data));
      break;
    case shipmentDetailsScreen:
      if (AcceptMerchantOffer.fromMap(data).childrenShipment == 0) {
        MagicRouter.navigateTo(ShipmentDetailsScreen(
          id: AcceptMerchantOffer.fromMap(data).shipmentId,
        ));
      } else {
        Navigator.pushNamed(ctx, ChildShipmentDetails.id,
            arguments: AcceptMerchantOffer.fromMap(data).shipmentId);
      }
      break;
    case 'shipment':
      if (data['has_children'] == 0) {
        MagicRouter.navigateTo(ShipmentDetailsScreen(
          id: data['shipment_id'],
        ));
      } else {
        Navigator.pushNamed(ctx, ChildShipmentDetails.id,
            arguments: data['shipment_id']);
      }
      break;
    case 'new_shipment':
      if (data['children_shipment'] == 0) {
        MagicRouter.navigateTo(ShipmentDetailsScreen(
          id: data['shipment_id'],
        ));
      } else {
        Navigator.pushNamed(ctx, ChildShipmentDetails.id,
            arguments: data['shipment_id']);
      }
      break;
  }
}
