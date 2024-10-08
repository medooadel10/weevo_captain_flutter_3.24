import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/features/available_shipments/ui/screens/available_shipments_screen.dart';

import '../Dialogs/action_dialog.dart';
import '../Dialogs/apply_confirmation_dialog.dart';
import '../Dialogs/cancel_shipment_dialog.dart';
import '../Dialogs/content_dialog.dart';
import '../Dialogs/deliver_shipment_dialog.dart';
import '../Dialogs/inside_offer_dialog.dart';
import '../Dialogs/loading.dart';
import '../Dialogs/no_credit_dialog.dart';
import '../Dialogs/offer_confirmation_dialog.dart';
import '../Dialogs/update_offer_dialog.dart';
import '../Dialogs/update_offer_request_dialog.dart';
import '../Models/shipment_notification.dart';
import '../Models/shipment_tracking_model.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Providers/wallet_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/child_shipment_item.dart';
import '../Widgets/connectivity_widget.dart';
import '../core/networking/api_constants.dart';
import '../core/router/router.dart';
import '../main.dart';
import 'handle_shipment.dart';
import 'home.dart';
import 'shipment_details_display.dart';
import 'wallet.dart';

class ChildShipmentDetails extends StatefulWidget {
  static const String id = 'ShipmentSummery';
  final int shipmentId;

  const ChildShipmentDetails({
    super.key,
    required this.shipmentId,
  });

  @override
  State<ChildShipmentDetails> createState() => _ChildShipmentDetailsState();
}

class _ChildShipmentDetailsState extends State<ChildShipmentDetails> {
  late ShipmentProvider _shipmentProvider;
  late AuthProvider _authProvider;
  Timer? t;

  @override
  void initState() {
    super.initState();
    _shipmentProvider = Provider.of<ShipmentProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    getData();
  }

  void getData() async {
    await _shipmentProvider.getBulkShipmentById(
        id: widget.shipmentId, isFirstTime: true);
    check(
        ctx: navigator.currentContext!,
        auth: _authProvider,
        state: _shipmentProvider.bulkShipmentByIdState!);
  }

  @override
  Widget build(BuildContext context) {
    ShipmentProvider shipmentProvider = Provider.of<ShipmentProvider>(context);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return PopScope(
      onPopInvokedWithResult: (value, result) async {
        if (shipmentProvider.fromNewShipment) {
          shipmentProvider.setFromNewShipment(false);
          shipmentProvider.setAvailableShipmentIndex(
              shipmentProvider.availableShipmentIndex);
          MagicRouter.navigateAndPop(const AvailableShipmentsScreen());
        } else if (authProvider.fromOutsideNotification) {
          authProvider.setFromOutsideNotification(false);
          Navigator.pushReplacementNamed(context, Home.id);
        } else {
          Navigator.pop(context);
        }
      },
      canPop: true,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ConnectivityWidget(
          callback: () {},
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if (shipmentProvider.fromNewShipment) {
                      shipmentProvider.setAvailableShipmentIndex(
                          shipmentProvider.availableShipmentIndex);
                      MagicRouter.navigateAndPop(
                          const AvailableShipmentsScreen());
                    } else if (authProvider.fromOutsideNotification) {
                      authProvider.setFromOutsideNotification(false);
                      Navigator.pushReplacementNamed(context, Home.id);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                  ),
                ),
                title: const Text(
                  'ملخص الشحنات',
                ),
              ),
              body: Consumer<ShipmentProvider>(
                builder: (context, data, child) => data.bulkShipmentByIdState ==
                        NetworkState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              weevoPrimaryOrangeColor),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount:
                                  data.bulkShipmentById!.children!.length,
                              itemBuilder: (context, i) => ChildShipmentItem(
                                shipment: data.bulkShipmentById!.children![i],
                                onItemClick: () {
                                  Navigator.pushNamed(
                                    context,
                                    ShipmentDetailsDisplay.id,
                                    arguments:
                                        data.bulkShipmentById!.children![i].id,
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    data.bulkShipmentById!.status == 'available' &&
                                            data.bulkShipmentById!.isOfferBased ==
                                                0
                                        ? Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6.0),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6.0),
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  // if (DateTime
                                                  //     .now()
                                                  //     .hour >= 10 && DateTime
                                                  //     .now()
                                                  //     .hour <= 22) {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) =>
                                                          DeliverShipmentDialog(
                                                            onOkPressed:
                                                                (String v) {
                                                              if (v == 'DONE') {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        false,
                                                                    builder: (c) =>
                                                                        ApplyConfirmationDialog(
                                                                          onOkPressed:
                                                                              () async {
                                                                            Navigator.pop(c);
                                                                            await data.getBulkShipmentById(
                                                                              id: data.bulkShipmentById!.id!,
                                                                              isFirstTime: false,
                                                                            );
                                                                            DocumentSnapshot
                                                                                userToken =
                                                                                await FirebaseFirestore.instance.collection('merchant_users').doc(data.bulkShipmentById!.merchantId.toString()).get();
                                                                            String
                                                                                token =
                                                                                userToken['fcmToken'];
                                                                            FirebaseFirestore.instance.collection('merchant_notifications').doc(data.bulkShipmentById!.merchantId.toString()).collection(data.bulkShipmentById!.merchantId.toString()).add({
                                                                              'read': false,
                                                                              'date_time': DateTime.now().toIso8601String(),
                                                                              'type': 'cancel_shipment',
                                                                              'title': 'ويفو وفرلك كابتن',
                                                                              'body': 'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالشحنة',
                                                                              'user_icon': authProvider.photo!.isNotEmpty
                                                                                  ? authProvider.photo!.contains(ApiConstants.baseUrl)
                                                                                      ? authProvider.photo
                                                                                      : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                                  : '',
                                                                              'screen_to': 'shipment_screen',
                                                                              'data': ShipmentTrackingModel(shipmentId: data.bulkShipmentById!.id, hasChildren: 1).toJson(),
                                                                            });
                                                                            await authProvider.sendNotification(
                                                                                title: 'ويفو وفرلك كابتن',
                                                                                body: 'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالشحنة',
                                                                                toToken: token,
                                                                                image: authProvider.photo!.isNotEmpty
                                                                                    ? authProvider.photo!.contains(ApiConstants.baseUrl)
                                                                                        ? authProvider.photo
                                                                                        : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                                    : '',
                                                                                data: ShipmentTrackingModel(shipmentId: data.bulkShipmentById!.id, hasChildren: 1).toJson(),
                                                                                screenTo: 'shipment_screen',
                                                                                type: 'cancel_shipment');
                                                                          },
                                                                          isDone:
                                                                              true,
                                                                        ));
                                                              } else {
                                                                if (shipmentProvider
                                                                    .noCredit!) {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (c) =>
                                                                              NoCreditDialog(
                                                                                onOkCancelCallback: () {
                                                                                  Navigator.pop(c);
                                                                                },
                                                                                onChargeWalletCallback: () {
                                                                                  Navigator.pop(c);
                                                                                  walletProvider.setMainIndex(1);
                                                                                  walletProvider.setDepositAmount(num.parse(data.bulkShipmentById!.amount!).toInt());
                                                                                  walletProvider.setDepositIndex(1);
                                                                                  walletProvider.fromOfferPage = true;
                                                                                  Navigator.pushReplacementNamed(c, Wallet.id);
                                                                                },
                                                                              ));
                                                                } else {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (c) =>
                                                                              ApplyConfirmationDialog(
                                                                                onOkPressed: () async {
                                                                                  Navigator.pop(c);
                                                                                },
                                                                                isDone: false,
                                                                              ));
                                                                }
                                                              }
                                                            },
                                                            shipmentId: data
                                                                .bulkShipmentById!
                                                                .id!,
                                                            amount: data
                                                                .bulkShipmentById!
                                                                .amount
                                                                .toString(),
                                                            shippingCost: data
                                                                .bulkShipmentById!
                                                                .expectedShippingCost!
                                                                .toString(),
                                                          ));
                                                  // }
                                                  // else {
                                                  //   showDialog(
                                                  //       context: context,
                                                  //       builder: (cx) =>
                                                  //           ActionDialog(
                                                  //             content: 'يمكنك التقديم علي الشحنات من ١٠ صباحاً حتي ١٠ مساءاً',
                                                  //             onApproveClick: () {
                                                  //               Navigator
                                                  //                   .pop(
                                                  //                   cx);
                                                  //             },
                                                  //             approveAction: 'حسناً',
                                                  //           ));
                                                  // }
                                                },
                                                style: ButtonStyle(
                                                  shape: WidgetStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        12.0,
                                                      ),
                                                    ),
                                                  ),
                                                  padding: WidgetStateProperty
                                                      .all<EdgeInsets>(
                                                    const EdgeInsets.all(
                                                      12.0,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      WidgetStateProperty.all<
                                                              Color>(
                                                          weevoPrimaryOrangeColor),
                                                ),
                                                icon: Image.asset(
                                                  'assets/images/deliver_shipment_icon.png',
                                                  height: 30.0,
                                                  width: 30.0,
                                                ),
                                                label: const Text(
                                                  'وصل الأوردر',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                  strutStyle: StrutStyle(
                                                    forceStrutHeight: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : data.bulkShipmentById!
                                                        .status ==
                                                    'available' &&
                                                data.bulkShipmentById!
                                                        .isOfferBased ==
                                                    1
                                            ? Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 6.0),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 6.0),
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (context) =>
                                                            InsideOfferDialog(
                                                          onShippingCostPressed:
                                                              (String v,
                                                                  String
                                                                      shippingCost,
                                                                  String
                                                                      shippingAmount) {
                                                            walletProvider
                                                                    .agreedAmount =
                                                                double.parse(
                                                                        shippingCost)
                                                                    .toInt();
                                                            if (v == 'DONE') {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (c) =>
                                                                      OfferConfirmationDialog(
                                                                        onOkPressed:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              c);
                                                                          await shipmentProvider.getOfferBasedShipment(
                                                                              isPagination: false,
                                                                              isRefreshing: false,
                                                                              isFirstTime: false);
                                                                          await data
                                                                              .getBulkShipmentById(
                                                                            id: data.bulkShipmentById!.id!,
                                                                            isFirstTime:
                                                                                false,
                                                                          );
                                                                          await WeevoCaptain.facebookAppEvents.logInitiatedCheckout(
                                                                              totalPrice: num.parse(data.bulkShipmentById!.amount!).toDouble(),
                                                                              currency: 'EGP');
                                                                          DocumentSnapshot userToken = await FirebaseFirestore
                                                                              .instance
                                                                              .collection('merchant_users')
                                                                              .doc(data.bulkShipmentById!.merchantId.toString())
                                                                              .get();
                                                                          String
                                                                              token =
                                                                              userToken['fcmToken'];
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('merchant_notifications')
                                                                              .doc(data.bulkShipmentById!.merchantId.toString())
                                                                              .collection(data.bulkShipmentById!.merchantId.toString())
                                                                              .add({
                                                                            'read':
                                                                                false,
                                                                            'date_time':
                                                                                DateTime.now().toIso8601String(),
                                                                            'type':
                                                                                'cancel_shipment',
                                                                            'title':
                                                                                'ويفو وفرلك كابتن',
                                                                            'body':
                                                                                'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالشحنة',
                                                                            'user_icon': authProvider.photo!.isNotEmpty
                                                                                ? authProvider.photo!.contains(ApiConstants.baseUrl)
                                                                                    ? authProvider.photo
                                                                                    : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                                : '',
                                                                            'screen_to':
                                                                                'shipment_screen',
                                                                            'data':
                                                                                ShipmentTrackingModel(shipmentId: data.bulkShipmentById!.id, hasChildren: 1).toJson(),
                                                                          });
                                                                          await authProvider.sendNotification(
                                                                              title: 'ويفو وفرلك كابتن',
                                                                              body: 'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالشحنة',
                                                                              toToken: token,
                                                                              image: authProvider.photo!.isNotEmpty
                                                                                  ? authProvider.photo!.contains(ApiConstants.baseUrl)
                                                                                      ? authProvider.photo
                                                                                      : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                                  : '',
                                                                              data: ShipmentTrackingModel(shipmentId: data.bulkShipmentById!.id, hasChildren: 1).toJson(),
                                                                              screenTo: 'shipment_screen',
                                                                              type: 'cancel_shipment');
                                                                        },
                                                                        isDone:
                                                                            true,
                                                                        isOffer:
                                                                            true,
                                                                      ));
                                                            } else {
                                                              if (shipmentProvider
                                                                  .noCredit!) {
                                                                showDialog(
                                                                    context:
                                                                        navigator
                                                                            .currentContext!,
                                                                    builder: (c) =>
                                                                        NoCreditDialog(
                                                                          onOkCancelCallback:
                                                                              () {
                                                                            Navigator.pop(c);
                                                                          },
                                                                          onChargeWalletCallback:
                                                                              () {
                                                                            Navigator.pop(c);
                                                                            walletProvider.setMainIndex(1);
                                                                            walletProvider.setDepositAmount(num.parse(data.bulkShipmentById!.amount!).toInt());
                                                                            walletProvider.setDepositIndex(1);
                                                                            walletProvider.fromOfferPage =
                                                                                true;
                                                                            Navigator.pushReplacementNamed(c,
                                                                                Wallet.id);
                                                                          },
                                                                        ));
                                                              } else {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (c) =>
                                                                        OfferConfirmationDialog(
                                                                          onOkPressed:
                                                                              () async {
                                                                            Navigator.pop(c);
                                                                          },
                                                                          isDone:
                                                                              false,
                                                                          isOffer:
                                                                              false,
                                                                        ));
                                                              }
                                                            }
                                                          },
                                                          onShippingOfferPressed:
                                                              (String v,
                                                                  int offer,
                                                                  String
                                                                      totalCost) {
                                                            walletProvider
                                                                    .agreedAmount =
                                                                offer;

                                                            if (v == 'DONE') {
                                                              if (authProvider
                                                                  .updateOffer!) {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (c) =>
                                                                        UpdateOfferRequestDialog(
                                                                          onBetterOfferCallback:
                                                                              () {
                                                                            Navigator.pop(c);
                                                                            showDialog(
                                                                                context: c,
                                                                                builder: (ct) => UpdateOfferDialog(
                                                                                      onBetterShippingOfferPressed: (String v, int offer, String totalCost) {
                                                                                        if (v == 'DONE') {
                                                                                          showDialog(
                                                                                              context: ct,
                                                                                              builder: (cx) => OfferConfirmationDialog(
                                                                                                    isOffer: true,
                                                                                                    onOkPressed: () async {
                                                                                                      Navigator.pop(cx);
                                                                                                      DocumentSnapshot userToken = await FirebaseFirestore.instance
                                                                                                          .collection('merchant_users')
                                                                                                          .doc(
                                                                                                            data.bulkShipmentById!.merchantId.toString(),
                                                                                                          )
                                                                                                          .get();
                                                                                                      String token = userToken['fcmToken'];
                                                                                                      FirebaseFirestore.instance.collection('merchant_notifications').doc(data.bulkShipmentById!.merchantId.toString()).collection(data.bulkShipmentById!.merchantId.toString()).add({
                                                                                                        'read': false,
                                                                                                        'date_time': DateTime.now().toIso8601String(),
                                                                                                        'type': '',
                                                                                                        'title': 'عرض أفضل',
                                                                                                        'body': 'تم تقديم عرض أفضل من الكابتن ${authProvider.name}',
                                                                                                        'user_icon': authProvider.photo!.isNotEmpty
                                                                                                            ? authProvider.photo!.contains(ApiConstants.baseUrl)
                                                                                                                ? authProvider.photo
                                                                                                                : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                                                            : '',
                                                                                                        'screen_to': 'shipment_offers',
                                                                                                        'data': ShipmentNotification(
                                                                                                          receivingState: data.bulkShipmentById!.receivingState,
                                                                                                          receivingCity: null,
                                                                                                          deliveryState: data.bulkShipmentById!.deliveringState,
                                                                                                          deliveryCity: null,
                                                                                                          totalShipmentCost: data.bulkShipmentById!.amount,
                                                                                                          shipmentId: data.bulkShipmentById!.id,
                                                                                                          merchantImage: data.bulkShipmentById!.merchant!.photo,
                                                                                                          merchantName: data.bulkShipmentById!.merchant!.name,
                                                                                                          childrenShipment: data.bulkShipmentById!.children!.length,
                                                                                                          shippingCost: data.bulkShipmentById!.expectedShippingCost,
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
                                                                                                            receivingState: data.bulkShipmentById!.receivingState,
                                                                                                            receivingCity: null,
                                                                                                            deliveryState: data.bulkShipmentById!.deliveringState,
                                                                                                            deliveryCity: null,
                                                                                                            totalShipmentCost: data.bulkShipmentById!.amount,
                                                                                                            shipmentId: data.bulkShipmentById!.id,
                                                                                                            merchantImage: data.bulkShipmentById!.merchant!.photo,
                                                                                                            merchantName: data.bulkShipmentById!.merchant!.name,
                                                                                                            childrenShipment: data.bulkShipmentById!.children!.length,
                                                                                                            shippingCost: data.bulkShipmentById!.expectedShippingCost,
                                                                                                          ).toMap());
                                                                                                    },
                                                                                                    isDone: true,
                                                                                                  ));
                                                                                        } else {
                                                                                          if (authProvider.betterOfferIsBiggerThanLastOne) {
                                                                                            showDialog(
                                                                                                context: ct,
                                                                                                builder: (cx) => ActionDialog(
                                                                                                      content: authProvider.betterOfferMessage,
                                                                                                      onApproveClick: () {
                                                                                                        Navigator.pop(cx);
                                                                                                      },
                                                                                                      approveAction: 'حسناً',
                                                                                                    ));
                                                                                          } else {
                                                                                            showDialog(
                                                                                                context: ct,
                                                                                                builder: (cx) => OfferConfirmationDialog(
                                                                                                      isOffer: true,
                                                                                                      onOkPressed: () {
                                                                                                        Navigator.pop(cx);
                                                                                                      },
                                                                                                      isDone: false,
                                                                                                    ));
                                                                                          }
                                                                                        }
                                                                                      },
                                                                                      shipmentNotification: ShipmentNotification(
                                                                                        receivingState: data.bulkShipmentById!.receivingState,
                                                                                        receivingCity: null,
                                                                                        deliveryState: data.bulkShipmentById!.deliveringState,
                                                                                        deliveryCity: null,
                                                                                        shipmentId: data.bulkShipmentById!.id,
                                                                                        offerId: authProvider.offerId,
                                                                                        totalShipmentCost: data.bulkShipmentById!.amount,
                                                                                        merchantImage: data.bulkShipmentById!.merchant!.photo,
                                                                                        merchantName: data.bulkShipmentById!.merchant!.name,
                                                                                        childrenShipment: data.bulkShipmentById!.children!.length,
                                                                                        shippingCost: data.bulkShipmentById!.expectedShippingCost,
                                                                                      ),
                                                                                    ));
                                                                          },
                                                                          onCancelCallback:
                                                                              () {
                                                                            Navigator.pop(c);
                                                                          },
                                                                          message:
                                                                              authProvider.message!,
                                                                        ));
                                                              } else {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (c) =>
                                                                        OfferConfirmationDialog(
                                                                          isOffer:
                                                                              true,
                                                                          onOkPressed:
                                                                              () async {
                                                                            Navigator.pop(c);
                                                                            DocumentSnapshot
                                                                                userToken =
                                                                                await FirebaseFirestore.instance.collection('merchant_users').doc(data.bulkShipmentById!.merchantId.toString()).get();
                                                                            String
                                                                                token =
                                                                                userToken['fcmToken'];
                                                                            FirebaseFirestore.instance.collection('merchant_notifications').doc(data.bulkShipmentById!.merchantId.toString()).collection(data.bulkShipmentById!.merchantId.toString()).add({
                                                                              'read': false,
                                                                              'date_time': DateTime.now().toIso8601String(),
                                                                              'type': '',
                                                                              'title': 'عرض جديد',
                                                                              'body': 'تم تقديم عرض جديد من الكابتن ${authProvider.name}',
                                                                              'user_icon': authProvider.photo!.isNotEmpty
                                                                                  ? authProvider.photo!.contains(ApiConstants.baseUrl)
                                                                                      ? authProvider.photo
                                                                                      : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                                  : '',
                                                                              'screen_to': 'shipment_offers',
                                                                              'data': ShipmentNotification(
                                                                                receivingState: data.bulkShipmentById!.receivingState,
                                                                                receivingCity: null,
                                                                                deliveryState: data.bulkShipmentById!.deliveringState,
                                                                                deliveryCity: null,
                                                                                totalShipmentCost: data.bulkShipmentById!.amount,
                                                                                shipmentId: data.bulkShipmentById!.id,
                                                                                merchantImage: data.bulkShipmentById!.merchant!.photo,
                                                                                merchantName: data.bulkShipmentById!.merchant!.name,
                                                                                childrenShipment: data.bulkShipmentById!.children!.length,
                                                                                shippingCost: data.bulkShipmentById!.expectedShippingCost,
                                                                              ).toMap(),
                                                                            });
                                                                            authProvider.sendNotification(
                                                                                title: 'عرض جديد',
                                                                                body: 'تم تقديم عرض جديد من الكابتن ${authProvider.name}',
                                                                                toToken: token,
                                                                                image: authProvider.photo!.isNotEmpty
                                                                                    ? authProvider.photo!.contains(ApiConstants.baseUrl)
                                                                                        ? authProvider.photo
                                                                                        : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                                    : '',
                                                                                type: '',
                                                                                screenTo: 'shipment_offers',
                                                                                data: ShipmentNotification(receivingState: data.bulkShipmentById!.receivingState, receivingCity: null, deliveryState: data.bulkShipmentById!.deliveringState, deliveryCity: null, shipmentId: data.bulkShipmentById!.id, merchantImage: data.bulkShipmentById!.merchant!.photo, merchantName: data.bulkShipmentById!.merchant!.name, childrenShipment: data.bulkShipmentById!.children!.length, shippingCost: data.bulkShipmentById!.expectedShippingCost, totalShipmentCost: data.bulkShipmentById!.amount).toMap());
                                                                          },
                                                                          isDone:
                                                                              true,
                                                                        ));
                                                              }
                                                            } else {
                                                              if (authProvider
                                                                  .noCredit) {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (c) =>
                                                                        NoCreditDialog(
                                                                          onOkCancelCallback:
                                                                              () {
                                                                            Navigator.pop(c);
                                                                          },
                                                                          onChargeWalletCallback:
                                                                              () {
                                                                            Navigator.pop(c);
                                                                            walletProvider.setMainIndex(1);
                                                                            walletProvider.setDepositAmount(num.parse(data.bulkShipmentById!.amount!).toInt());
                                                                            walletProvider.setDepositIndex(1);
                                                                            walletProvider.fromOfferPage =
                                                                                true;
                                                                            Navigator.pushReplacementNamed(c,
                                                                                Wallet.id);
                                                                          },
                                                                        ));
                                                              } else {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (c) =>
                                                                        OfferConfirmationDialog(
                                                                          onOkPressed:
                                                                              () {
                                                                            Navigator.pop(c);
                                                                          },
                                                                          isOffer:
                                                                              true,
                                                                          isDone:
                                                                              false,
                                                                        ));
                                                              }
                                                            }
                                                          },
                                                          shipmentNotification: ShipmentNotification(
                                                              shipmentId: data
                                                                  .bulkShipmentById!
                                                                  .id,
                                                              shippingCost: data
                                                                  .bulkShipmentById!
                                                                  .expectedShippingCost
                                                                  .toString(),
                                                              merchantName: data
                                                                  .bulkShipmentById!
                                                                  .merchant!
                                                                  .name,
                                                              flags: data
                                                                  .bulkShipmentById!
                                                                  .flags,
                                                              childrenShipment: data
                                                                  .bulkShipmentById!
                                                                  .children!
                                                                  .length,
                                                              totalShipmentCost:
                                                                  data.bulkShipmentById!
                                                                      .amount),
                                                        ),
                                                      );
                                                    },
                                                    style: ButtonStyle(
                                                      shape: WidgetStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            12.0,
                                                          ),
                                                        ),
                                                      ),
                                                      padding:
                                                          WidgetStateProperty
                                                              .all<EdgeInsets>(
                                                        const EdgeInsets.all(
                                                          12.0,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          WidgetStateProperty.all<
                                                                  Color>(
                                                              weevoPrimaryOrangeColor),
                                                    ),
                                                    icon: Container(
                                                      height: 30.0,
                                                    ),
                                                    label: const Text(
                                                      'تقديم عرض',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                      strutStyle: StrutStyle(
                                                        forceStrutHeight: true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : (data.bulkShipmentById!
                                                                .status ==
                                                            'merchant-accepted-shipping-offer' ||
                                                        data.bulkShipmentById!
                                                                .status ==
                                                            'on-the-way-to-get-shipment-from-merchant' ||
                                                        data.bulkShipmentById!
                                                                .status ==
                                                            'courier-applied-to-shipment') &&
                                                    data.bulkShipmentById!
                                                            .courierId ==
                                                        int.parse(Preferences
                                                            .instance.getUserId)
                                                ? Expanded(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 6.0),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6.0),
                                                      child:
                                                          ElevatedButton.icon(
                                                        onPressed: () async {
                                                          showDialog(
                                                              context: navigator
                                                                  .currentContext!,
                                                              barrierDismissible:
                                                                  false,
                                                              builder: (context) =>
                                                                  const Loading());

                                                          await data
                                                              .getBulkShipmentById(
                                                            id: data
                                                                .bulkShipmentById!
                                                                .id!,
                                                            isFirstTime: false,
                                                          );

                                                          if (data.bulkShipmentById!.status == 'delivered' ||
                                                              data.bulkShipmentById!
                                                                      .status ==
                                                                  'cancelled' ||
                                                              data.bulkShipmentById!
                                                                      .status ==
                                                                  'bulk-shipment-closed' ||
                                                              data.bulkShipmentById!
                                                                      .status ==
                                                                  'returned') {
                                                            MagicRouter.pop();
                                                            return;
                                                          }

                                                          DocumentSnapshot
                                                              userToken =
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'merchant_users')
                                                                  .doc(data
                                                                      .bulkShipmentById!
                                                                      .merchantId
                                                                      .toString())
                                                                  .get();
                                                          String
                                                              merchantNationalId =
                                                              userToken[
                                                                  'national_id'];
                                                          MagicRouter.pop();
                                                          MagicRouter
                                                              .navigateTo(
                                                            HandleShipment(
                                                              model:
                                                                  ShipmentTrackingModel(
                                                                status: data
                                                                    .bulkShipmentById
                                                                    ?.status,
                                                                merchantRating: data
                                                                    .bulkShipmentById!
                                                                    .merchant!
                                                                    .cachedAverageRating!,
                                                                merchantNationalId:
                                                                    merchantNationalId,
                                                                courierNationalId:
                                                                    authProvider
                                                                        .getNationalId,
                                                                hasChildren: 1,
                                                                shipmentId: data
                                                                    .bulkShipmentById!
                                                                    .id,
                                                                deliveringState: data
                                                                    .bulkShipmentById!
                                                                    .children![
                                                                        0]
                                                                    .deliveringState,
                                                                deliveringCity: data
                                                                    .bulkShipmentById!
                                                                    .children![
                                                                        0]
                                                                    .deliveringCity,
                                                                receivingState: data
                                                                    .bulkShipmentById!
                                                                    .children![
                                                                        0]
                                                                    .receivingState,
                                                                receivingCity: data
                                                                    .bulkShipmentById!
                                                                    .children![
                                                                        0]
                                                                    .receivingCity,
                                                                receivingStreet: data
                                                                    .bulkShipmentById!
                                                                    .children![
                                                                        0]
                                                                    .receivingStreet,
                                                                deliveringStreet: data
                                                                    .bulkShipmentById!
                                                                    .children![
                                                                        0]
                                                                    .deliveringStreet,
                                                                receivingApartment: data
                                                                    .bulkShipmentById!
                                                                    .receivingApartment,
                                                                receivingBuildingNumber: data
                                                                    .bulkShipmentById!
                                                                    .receivingBuildingNumber,
                                                                receivingFloor: data
                                                                    .bulkShipmentById!
                                                                    .receivingFloor,
                                                                receivingLandmark: data
                                                                    .bulkShipmentById!
                                                                    .receivingLandmark,
                                                                receivingLat: data
                                                                    .bulkShipmentById!
                                                                    .receivingLat,
                                                                receivingLng: data
                                                                    .bulkShipmentById!
                                                                    .receivingLng,
                                                                deliveringLat: data
                                                                    .bulkShipmentById!
                                                                    .deliveringLat,
                                                                deliveringLng: data
                                                                    .bulkShipmentById!
                                                                    .deliveringLng,
                                                                fromLat: authProvider
                                                                    .locationData
                                                                    ?.latitude,
                                                                fromLng: authProvider
                                                                    .locationData
                                                                    ?.longitude,
                                                                merchantId: data
                                                                    .bulkShipmentById!
                                                                    .merchantId,
                                                                courierId: data
                                                                    .bulkShipmentById!
                                                                    .courierId,
                                                                merchantImage: data
                                                                    .bulkShipmentById!
                                                                    .merchant!
                                                                    .photo,
                                                                courierImage:
                                                                    authProvider
                                                                        .photo,
                                                                merchantName: data
                                                                    .bulkShipmentById!
                                                                    .merchant!
                                                                    .name,
                                                                courierName:
                                                                    authProvider
                                                                        .name,
                                                                merchantPhone: data
                                                                    .bulkShipmentById!
                                                                    .merchant!
                                                                    .phone,
                                                                courierPhone:
                                                                    authProvider
                                                                        .phone,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        style: ButtonStyle(
                                                          shape: WidgetStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                12.0,
                                                              ),
                                                            ),
                                                          ),
                                                          padding:
                                                              WidgetStateProperty
                                                                  .all<
                                                                      EdgeInsets>(
                                                            const EdgeInsets
                                                                .all(
                                                              12.0,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              WidgetStateProperty
                                                                  .all<Color>(
                                                                      weevoPrimaryOrangeColor),
                                                        ),
                                                        icon: Container(
                                                          height: 30.0,
                                                        ),
                                                        label: const Text(
                                                          'إبدأ التوصيل',
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                          strutStyle:
                                                              StrutStyle(
                                                            forceStrutHeight:
                                                                true,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                    (data.bulkShipmentById!.status ==
                                                    'merchant-accepted-shipping-offer' ||
                                                data.bulkShipmentById!.status ==
                                                    'courier-applied-to-shipment' ||
                                                data.bulkShipmentById!.status ==
                                                    'on-the-way-to-get-shipment-from-merchant') &&
                                            data.bulkShipmentById!.courierId ==
                                                int.parse(Preferences
                                                    .instance.getUserId)
                                        ? Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6.0),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6.0),
                                              child: ElevatedButton.icon(
                                                onPressed: () async {
                                                  if (await authProvider
                                                      .checkConnection()) {
                                                    await cancelShippingCallback(
                                                        data, authProvider);
                                                  } else {
                                                    showDialog(
                                                      context: navigator
                                                          .currentContext!,
                                                      builder: (ctx) =>
                                                          ActionDialog(
                                                        content:
                                                            'تأكد من الاتصال بشبكة الانترنت',
                                                        cancelAction: 'حسناً',
                                                        approveAction:
                                                            'حاول مرة اخري',
                                                        onApproveClick:
                                                            () async {
                                                          Navigator.pop(
                                                              context);
                                                          await cancelShippingCallback(
                                                              data,
                                                              authProvider);
                                                        },
                                                        onCancelClick: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  shape: WidgetStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        12.0,
                                                      ),
                                                    ),
                                                  ),
                                                  padding: WidgetStateProperty
                                                      .all<EdgeInsets>(
                                                    const EdgeInsets.all(
                                                      12.0,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      WidgetStateProperty.all<
                                                          Color>(Colors.red),
                                                ),
                                                icon: Container(
                                                  height: 30.0,
                                                ),
                                                label: const Text(
                                                  'إلغاء التوصيل',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                  strutStyle: StrutStyle(
                                                    forceStrutHeight: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12.0),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      12.0,
                                    ),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'جنية',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 6.0.w,
                                          ),
                                          Text(
                                            double.parse(data
                                                    .bulkShipmentById!.amount!)
                                                .toInt()
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        'التكلفة الكلية للشحنات',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              )),
        ),
      ),
    );
  }

  Future<void> cancelShippingCallback(
      ShipmentProvider data, AuthProvider authProvider) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => CancelShipmentDialog(onOkPressed: () async {
              Navigator.pop(ctx);
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Loading());
              await data.cancelShipping(data.bulkShipmentById!.id!);
              check(
                  ctx: navigator.currentContext!,
                  auth: authProvider,
                  state: data.cancelShippingState!);
              if (data.cancelShippingState == NetworkState.success) {
                Navigator.pop(navigator.currentContext!);
                await showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (context) => ActionDialog(
                          content: data.cancelMessage,
                          onApproveClick: () {
                            Navigator.pop(context);
                          },
                          approveAction: 'حسناً',
                        ));
                showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (context) => const Loading());

                DocumentSnapshot userToken = await FirebaseFirestore.instance
                    .collection('merchant_users')
                    .doc(data.bulkShipmentById!.merchantId.toString())
                    .get();
                String token = userToken['fcmToken'];
                FirebaseFirestore.instance
                    .collection('merchant_notifications')
                    .doc(data.bulkShipmentById!.merchantId.toString())
                    .collection(data.bulkShipmentById!.merchantId.toString())
                    .add({
                  'read': false,
                  'date_time': DateTime.now().toIso8601String(),
                  'type': 'cancel_shipment',
                  'title': 'تم إلغاء الشحن',
                  'body':
                      'قام الكابتن ${authProvider.name} بالغاء الشحنة يمكنك الذهاب للشحنة في الشحنات المتاحة',
                  'user_icon': authProvider.photo!.isNotEmpty
                      ? authProvider.photo!.contains(ApiConstants.baseUrl)
                          ? authProvider.photo
                          : '${ApiConstants.baseUrl}${authProvider.photo}'
                      : '',
                  'screen_to': 'shipment_screen',
                  'data': {
                    'has_children': 1,
                    'shipment_id': data.bulkShipmentById!.id,
                  },
                });
                Provider.of<AuthProvider>(navigator.currentContext!,
                        listen: false)
                    .sendNotification(
                        title: 'تم إلغاء الشحن',
                        body:
                            'قام الكابتن ${authProvider.name} بالغاء الشحنة يمكنك الذهاب للشحنة في الشحنات المتاحة',
                        image: authProvider.photo!.isNotEmpty
                            ? authProvider.photo!.contains(ApiConstants.baseUrl)
                                ? authProvider.photo
                                : '${ApiConstants.baseUrl}${authProvider.photo}'
                            : '',
                        toToken: token,
                        data: {
                          'has_children': 1,
                          'shipment_id': data.bulkShipmentById!.id,
                        },
                        screenTo: 'shipment_screen',
                        type: 'cancel_shipment');
                String courierPhoneNumber = Preferences.instance.getPhoneNumber;
                String merchantPhoneNumber =
                    data.bulkShipmentById!.merchant!.phone!;
                String locationId =
                    '$courierPhoneNumber-$merchantPhoneNumber-${data.bulkShipmentById!.id}';
                FirebaseFirestore.instance
                    .collection('locations')
                    .doc(locationId)
                    .set(
                  {'status': 'closed'},
                );
                Navigator.pop(navigator.currentContext!);
                Navigator.pop(navigator.currentContext!);
              } else if (data.cancelShippingState == NetworkState.error) {
                Navigator.pop(navigator.currentContext!);
                showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (context) => ActionDialog(
                          content: 'حدث خطأ من فضلك حاول مرة اخري',
                          cancelAction: 'حسناً',
                          onCancelClick: () {
                            Navigator.pop(context);
                          },
                        ));
              }
            }, onCancelPressed: () {
              Navigator.pop(context);
            }));
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
              authorization: authProvider.appAuthorization, fromRefresh: false);
          Navigator.pop(navigator.currentContext!);
          showDialog(
              context: navigator.currentContext!,
              barrierDismissible: false,
              builder: (context) => ContentDialog(
                    content:
                        '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider.meezaCard!.transaction!.amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
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
