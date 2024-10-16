import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';

import '../Dialogs/action_dialog.dart';
import '../Dialogs/content_dialog.dart';
import '../Dialogs/inside_offer_dialog.dart';
import '../Dialogs/no_credit_dialog.dart';
import '../Dialogs/offer_confirmation_dialog.dart';
import '../Dialogs/update_offer_dialog.dart';
import '../Dialogs/update_offer_request_dialog.dart';
import '../Models/bulk_shipment.dart';
import '../Models/shipment_notification.dart';
import '../Models/shipment_tracking_model.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Providers/wallet_provider.dart';
import '../Screens/wallet.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../core/networking/api_constants.dart';
import '../main.dart';
import 'slide_dotes.dart';

class BulkShipmentItem extends StatefulWidget {
  final BulkShipment bulkShipment;
  final VoidCallback onItemPressed;

  const BulkShipmentItem({
    super.key,
    required this.bulkShipment,
    required this.onItemPressed,
  });

  @override
  State<BulkShipmentItem> createState() => _BulkShipmentItemState();
}

class _BulkShipmentItemState extends State<BulkShipmentItem> {
  int _currentIndex = 0;
  PageController? _pageController;
  Timer? t;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final shipmentProvider = Provider.of<ShipmentProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.onItemPressed,
      child: widget.bulkShipment.children!.isNotEmpty
          ? Container(
              margin: const EdgeInsets.all(6.0),
              height: 170.h,
              child: PageView.builder(
                onPageChanged: (int i) {
                  setState(() {
                    _currentIndex = i;
                  });
                },
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                itemCount: widget.bulkShipment.children!.length,
                itemBuilder: (context, i) => Stack(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 150.0.h,
                          width: 150.0.h,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.5),
                                    child: CustomImage(
                                      image: widget.bulkShipment.children![i]
                                          .products![0].productInfo!.image!,
                                      height: 150.0.h,
                                      width: 150.0.h,
                                    ),
                                  ),
                                  widget.bulkShipment.children!.length > 1
                                      ? Container(
                                          padding: const EdgeInsets.all(6.0),
                                          height: 40.h,
                                          margin:
                                              const EdgeInsets.only(top: 20.0),
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  'assets/images/clip_path_background.png',
                                                ),
                                                fit: BoxFit.fill),
                                          ),
                                          child: Text(
                                            '${widget.bulkShipment.children!.length} شحنة',
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              widget.bulkShipment.status == 'available'
                                  ? Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 6.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                InsideOfferDialog(
                                              onShippingCostPressed: (String v,
                                                  String shippingCost,
                                                  String shippingAmount) {
                                                walletProvider.agreedAmount =
                                                    double.parse(shippingCost)
                                                        .toInt();
                                                if (v == 'DONE') {
                                                  showDialog(
                                                      context: context,
                                                      builder: (c) =>
                                                          OfferConfirmationDialog(
                                                            onOkPressed:
                                                                () async {
                                                              Navigator.pop(c);
                                                              await shipmentProvider
                                                                  .getOfferBasedShipment(
                                                                      isPagination:
                                                                          false,
                                                                      isRefreshing:
                                                                          false,
                                                                      isFirstTime:
                                                                          false);
                                                              await WeevoCaptain
                                                                  .facebookAppEvents
                                                                  .logInitiatedCheckout(
                                                                      totalPrice: num.parse(widget
                                                                              .bulkShipment
                                                                              .amount!)
                                                                          .toDouble(),
                                                                      currency:
                                                                          'EGP');
                                                              DocumentSnapshot
                                                                  userToken =
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'merchant_users')
                                                                      .doc(widget
                                                                          .bulkShipment
                                                                          .merchantId
                                                                          .toString())
                                                                      .get();
                                                              String token =
                                                                  userToken[
                                                                      'fcmToken'];
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'merchant_notifications')
                                                                  .doc(widget
                                                                      .bulkShipment
                                                                      .merchantId
                                                                      .toString())
                                                                  .collection(widget
                                                                      .bulkShipment
                                                                      .merchantId
                                                                      .toString())
                                                                  .add({
                                                                'read': false,
                                                                'date_time': DateTime
                                                                        .now()
                                                                    .toIso8601String(),
                                                                'type':
                                                                    'cancel_shipment',
                                                                'title':
                                                                    'ويفو وفرلك كابتن',
                                                                'body':
                                                                    'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالشحنة',
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
                                                                    'shipment_screen',
                                                                'data': ShipmentTrackingModel(
                                                                        shipmentId: widget
                                                                            .bulkShipment
                                                                            .id,
                                                                        hasChildren:
                                                                            1)
                                                                    .toJson(),
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
                                                                  data: ShipmentTrackingModel(shipmentId: widget.bulkShipment.id, hasChildren: 1).toJson(),
                                                                  screenTo: 'shipment_screen',
                                                                  type: 'cancel_shipment');
                                                            },
                                                            isDone: true,
                                                            isOffer: true,
                                                          ));
                                                } else {
                                                  if (shipmentProvider
                                                      .noCredit!) {
                                                    showDialog(
                                                        context: navigator
                                                            .currentContext!,
                                                        builder:
                                                            (c) =>
                                                                NoCreditDialog(
                                                                  onOkCancelCallback:
                                                                      () {
                                                                    Navigator
                                                                        .pop(c);
                                                                  },
                                                                  onChargeWalletCallback:
                                                                      () {
                                                                    Navigator
                                                                        .pop(c);
                                                                    walletProvider
                                                                        .setMainIndex(
                                                                            1);
                                                                    walletProvider.setDepositAmount(num.parse(widget
                                                                            .bulkShipment
                                                                            .amount!)
                                                                        .toInt());
                                                                    walletProvider
                                                                        .setDepositIndex(
                                                                            1);
                                                                    walletProvider
                                                                            .fromOfferPage =
                                                                        true;
                                                                    Navigator.pushReplacementNamed(
                                                                        c,
                                                                        Wallet
                                                                            .id);

                                                                    // showDialog(
                                                                    //     context: Preferences
                                                                    //         .instance
                                                                    //         .navigator
                                                                    //         .currentContext,
                                                                    //     barrierDismissible:
                                                                    //     false,
                                                                    //     builder:
                                                                    //         (ctx) =>
                                                                    //         ChargeWalletDialog(
                                                                    //           shipmentAmount: num
                                                                    //               .parse(
                                                                    //               widget
                                                                    //                   .bulkShipment
                                                                    //                   .amount)
                                                                    //               .toInt(),
                                                                    //           onSubmit: (
                                                                    //               String type,
                                                                    //               String value,
                                                                    //               String cardNumber,
                                                                    //               String walletNumber,
                                                                    //               String dateMonth,
                                                                    //               String dateYear,
                                                                    //               String ccvNumber,) async {
                                                                    //             if (type ==
                                                                    //                 'meeza-card') {
                                                                    //               showDialog(
                                                                    //                   context: Preferences
                                                                    //                       .instance
                                                                    //                       .navigator
                                                                    //                       .currentContext,
                                                                    //                   barrierDismissible: false,
                                                                    //                   builder: (
                                                                    //                       context) =>
                                                                    //                       Loading());
                                                                    //               await walletProvider
                                                                    //                   .addCreditWithMeeza(
                                                                    //                 amount: num
                                                                    //                     .parse(
                                                                    //                     value)
                                                                    //                     .toDouble(),
                                                                    //                 method: 'meeza-card',
                                                                    //                 pan: cardNumber
                                                                    //                     .split(
                                                                    //                     '-')
                                                                    //                     .join(),
                                                                    //                 expirationDate: '$dateYear$dateMonth',
                                                                    //                 cvv: ccvNumber,
                                                                    //               );
                                                                    //               if (walletProvider
                                                                    //                   .state ==
                                                                    //                   NetworkState
                                                                    //                       .SUCCESS) {
                                                                    //                 if (walletProvider
                                                                    //                     .meezaCard
                                                                    //                     .upgResponse !=
                                                                    //                     null) {
                                                                    //                   Navigator
                                                                    //                       .pop(
                                                                    //                       Preferences
                                                                    //                           .instance
                                                                    //                           .navigator
                                                                    //                           .currentContext);
                                                                    //                   dynamic value = await Navigator
                                                                    //                       .pushNamed(
                                                                    //                       Preferences
                                                                    //                           .instance
                                                                    //                           .navigator
                                                                    //                           .currentContext,
                                                                    //                       TransactionWebView
                                                                    //                           .id,
                                                                    //                       arguments: TransactionWebViewModel(
                                                                    //                           url: walletProvider
                                                                    //                               .meezaCard
                                                                    //                               .upgResponse
                                                                    //                               .threeDSUrl,
                                                                    //                           selectedValue: 1));
                                                                    //                   if (value !=
                                                                    //                       null) {
                                                                    //                     if (value ==
                                                                    //                         'no funds') {
                                                                    //                       showDialog(
                                                                    //                           context: Preferences
                                                                    //                               .instance
                                                                    //                               .navigator
                                                                    //                               .currentContext,
                                                                    //                           builder: (
                                                                    //                               c) =>
                                                                    //                               NoCreditInWalletDialog(
                                                                    //                                 onPressedCallback: () {
                                                                    //                                   Navigator
                                                                    //                                       .pop(
                                                                    //                                       c);
                                                                    //                                 },
                                                                    //                               ));
                                                                    //                     } else {
                                                                    //                       showDialog(
                                                                    //                           context: Preferences
                                                                    //                               .instance
                                                                    //                               .navigator
                                                                    //                               .currentContext,
                                                                    //                           barrierDismissible: false,
                                                                    //                           builder: (
                                                                    //                               context) =>
                                                                    //                               Loading());
                                                                    //                       await getMezaStatus(
                                                                    //                           walletProvider: walletProvider,
                                                                    //                           authProvider: authProvider,
                                                                    //                           value: value);
                                                                    //                     }
                                                                    //                   }
                                                                    //                 } else {
                                                                    //                   if (walletProvider
                                                                    //                       .meezaCard
                                                                    //                       .status ==
                                                                    //                       'completed') {
                                                                    //                     log(
                                                                    //                         'status compeleted');
                                                                    //                     log(
                                                                    //                         '${walletProvider
                                                                    //                             .meezaCard
                                                                    //                             .status}');
                                                                    //                     Navigator
                                                                    //                         .pop(
                                                                    //                         Preferences
                                                                    //                             .instance
                                                                    //                             .navigator
                                                                    //                             .currentContext);
                                                                    //                     showDialog(
                                                                    //                         context: Preferences
                                                                    //                             .instance
                                                                    //                             .navigator
                                                                    //                             .currentContext,
                                                                    //                         barrierDismissible: false,
                                                                    //                         builder: (
                                                                    //                             context) =>
                                                                    //                             ContentDialog(
                                                                    //                                 content: '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider
                                                                    //                                     .meezaCard
                                                                    //                                     .transaction
                                                                    //                                     .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
                                                                    //                               callback: () {
                                                                    //                                 Navigator
                                                                    //                                     .pop(
                                                                    //                                     Preferences
                                                                    //                                         .instance
                                                                    //                                         .navigator
                                                                    //                                         .currentContext);
                                                                    //                                 walletProvider
                                                                    //                                     .setDepositIndex(
                                                                    //                                     5);
                                                                    //                                 walletProvider
                                                                    //                                     .setAccountTypeIndex(
                                                                    //                                     null);
                                                                    //                               },
                                                                    //                             ));
                                                                    //                   }
                                                                    //                 }
                                                                    //               } else
                                                                    //               if (walletProvider
                                                                    //                   .state ==
                                                                    //                   NetworkState
                                                                    //                       .ERROR) {
                                                                    //                 Navigator
                                                                    //                     .pop(
                                                                    //                     Preferences
                                                                    //                         .instance
                                                                    //                         .navigator
                                                                    //                         .currentContext);
                                                                    //                 showDialog(
                                                                    //                   context: Preferences
                                                                    //                       .instance
                                                                    //                       .navigator
                                                                    //                       .currentContext,
                                                                    //                   builder: (
                                                                    //                       context) =>
                                                                    //                       WalletDialog(
                                                                    //                         msg: 'برجاء محاولة الأيداع مرة اخري',
                                                                    //                         onPress: () {
                                                                    //                           Navigator
                                                                    //                               .pop(
                                                                    //                               Preferences
                                                                    //                                   .instance
                                                                    //                                   .navigator
                                                                    //                                   .currentContext);
                                                                    //                         },
                                                                    //                       ),
                                                                    //                 );
                                                                    //               }
                                                                    //             }
                                                                    //             else
                                                                    //             if (type ==
                                                                    //                 'e-wallet') {
                                                                    //               showDialog(
                                                                    //                   context: Preferences
                                                                    //                       .instance
                                                                    //                       .navigator
                                                                    //                       .currentContext,
                                                                    //                   barrierDismissible: false,
                                                                    //                   builder: (
                                                                    //                       context) =>
                                                                    //                       MsgDialog(
                                                                    //                         content: 'سيصلك اشعار على رقم موبايلك المسجل على محفظتك الإلكترونية لأستكمال العملية',
                                                                    //                       ));
                                                                    //               await walletProvider
                                                                    //                   .addCreditWithEWallet(
                                                                    //                 amount: num
                                                                    //                     .parse(
                                                                    //                     value)
                                                                    //                     .toDouble(),
                                                                    //                 method: 'e-wallet',
                                                                    //                 mobileNumber: walletNumber,
                                                                    //               );
                                                                    //               if (walletProvider
                                                                    //                   .state ==
                                                                    //                   NetworkState
                                                                    //                       .SUCCESS) {
                                                                    //                 t =
                                                                    //                     Timer
                                                                    //                         .periodic(
                                                                    //                         Duration(
                                                                    //                             seconds: 5), (
                                                                    //                         timer) async {
                                                                    //                       await walletProvider
                                                                    //                           .checkPaymentStatus(
                                                                    //                           systemReferenceNumber: walletProvider
                                                                    //                               .eWallet
                                                                    //                               .transaction
                                                                    //                               .details
                                                                    //                               .upgSystemRef,
                                                                    //                           transactionId: walletProvider
                                                                    //                               .eWallet
                                                                    //                               .transaction
                                                                    //                               .details
                                                                    //                               .transactionId);
                                                                    //                       if (walletProvider
                                                                    //                           .state ==
                                                                    //                           NetworkState
                                                                    //                               .SUCCESS) {
                                                                    //                         if (walletProvider
                                                                    //                             .creditStatus
                                                                    //                             .status ==
                                                                    //                             'completed') {
                                                                    //                           if (t
                                                                    //                               .isActive) {
                                                                    //                             t
                                                                    //                                 .cancel();
                                                                    //                             t =
                                                                    //                             null;
                                                                    //                           }
                                                                    //                           Navigator
                                                                    //                               .pop(
                                                                    //                               Preferences
                                                                    //                                   .instance
                                                                    //                                   .navigator
                                                                    //                                   .currentContext);
                                                                    //                           showDialog(
                                                                    //                               context: Preferences
                                                                    //                                   .instance
                                                                    //                                   .navigator
                                                                    //                                   .currentContext,
                                                                    //                               barrierDismissible: false,
                                                                    //                               builder: (
                                                                    //                                   context) =>
                                                                    //                                   ContentDialog(
                                                                    //                                     content: '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider
                                                                    //                                         .eWallet
                                                                    //                                         .transaction
                                                                    //                                         .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
                                                                    //                                     callback: () {
                                                                    //                                       Navigator
                                                                    //                                           .pop(
                                                                    //                                           Preferences
                                                                    //                                               .instance
                                                                    //                                               .navigator
                                                                    //                                               .currentContext);
                                                                    //                                       walletProvider
                                                                    //                                           .setDepositIndex(
                                                                    //                                           5);
                                                                    //                                       walletProvider
                                                                    //                                           .setAccountTypeIndex(
                                                                    //                                           null);
                                                                    //                                     },
                                                                    //                                   ));
                                                                    //                         }
                                                                    //                       }
                                                                    //                     });
                                                                    //               } else
                                                                    //               if (walletProvider
                                                                    //                   .state ==
                                                                    //                   NetworkState
                                                                    //                       .ERROR) {
                                                                    //                 Navigator
                                                                    //                     .pop(
                                                                    //                     Preferences
                                                                    //                         .instance
                                                                    //                         .navigator
                                                                    //                         .currentContext);
                                                                    //                 showDialog(
                                                                    //                   context: Preferences
                                                                    //                       .instance
                                                                    //                       .navigator
                                                                    //                       .currentContext,
                                                                    //                   builder: (
                                                                    //                       context) =>
                                                                    //                       WalletDialog(
                                                                    //                         msg: 'حدث خطأ برحاء المحاولة مرة اخري',
                                                                    //                         onPress: () {
                                                                    //                           Navigator
                                                                    //                               .pop(
                                                                    //                               Preferences
                                                                    //                                   .instance
                                                                    //                                   .navigator
                                                                    //                                   .currentContext);
                                                                    //                         },
                                                                    //                       ),
                                                                    //                 );
                                                                    //               }
                                                                    //             }
                                                                    //             log(
                                                                    //                 'type -> $type');
                                                                    //             log(
                                                                    //                 'value -> $value');
                                                                    //             log(
                                                                    //                 'cardNumber -> $cardNumber');
                                                                    //             log(
                                                                    //                 'walletNumber -> $walletNumber');
                                                                    //             log(
                                                                    //                 'dateYear -> $dateYear');
                                                                    //             log(
                                                                    //                 'dateMonth -> $dateMonth');
                                                                    //             log(
                                                                    //                 'ccvNumber -> $ccvNumber');
                                                                    //           },
                                                                    //         ));
                                                                  },
                                                                ));
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (c) =>
                                                            OfferConfirmationDialog(
                                                              onOkPressed:
                                                                  () async {
                                                                Navigator.pop(
                                                                    c);
                                                              },
                                                              isDone: false,
                                                              isOffer: false,
                                                            ));
                                                  }
                                                }
                                              },
                                              onShippingOfferPressed: (String v,
                                                  int offer, String totalCost) {
                                                log('onShippingOfferPressed -> $v');
                                                walletProvider.agreedAmount =
                                                    offer;

                                                if (v == 'DONE') {
                                                  if (authProvider
                                                      .updateOffer!) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (c) =>
                                                            UpdateOfferRequestDialog(
                                                              onBetterOfferCallback:
                                                                  () {
                                                                Navigator.pop(
                                                                    c);
                                                                showDialog(
                                                                    context: c,
                                                                    builder:
                                                                        (ct) =>
                                                                            UpdateOfferDialog(
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
                                                                                                    widget.bulkShipment.merchantId.toString(),
                                                                                                  )
                                                                                                  .get();
                                                                                              String token = userToken['fcmToken'];
                                                                                              FirebaseFirestore.instance.collection('merchant_notifications').doc(widget.bulkShipment.merchantId.toString()).collection(widget.bulkShipment.merchantId.toString()).add({
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
                                                                                                  receivingState: widget.bulkShipment.receivingState,
                                                                                                  receivingCity: null,
                                                                                                  deliveryState: widget.bulkShipment.deliveringState,
                                                                                                  deliveryCity: null,
                                                                                                  totalShipmentCost: widget.bulkShipment.amount,
                                                                                                  shipmentId: widget.bulkShipment.id,
                                                                                                  merchantImage: widget.bulkShipment.merchant!.photo,
                                                                                                  merchantName: widget.bulkShipment.merchant!.name,
                                                                                                  childrenShipment: widget.bulkShipment.children!.length,
                                                                                                  shippingCost: widget.bulkShipment.expectedShippingCost,
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
                                                                                                    receivingState: widget.bulkShipment.receivingState,
                                                                                                    receivingCity: null,
                                                                                                    deliveryState: widget.bulkShipment.deliveringState,
                                                                                                    deliveryCity: null,
                                                                                                    totalShipmentCost: widget.bulkShipment.amount,
                                                                                                    shipmentId: widget.bulkShipment.id,
                                                                                                    merchantImage: widget.bulkShipment.merchant!.photo,
                                                                                                    merchantName: widget.bulkShipment.merchant!.name,
                                                                                                    childrenShipment: widget.bulkShipment.children!.length,
                                                                                                    shippingCost: widget.bulkShipment.expectedShippingCost,
                                                                                                  ).toMap());
                                                                                            },
                                                                                            isDone: true,
                                                                                          ));
                                                                                } else {
                                                                                  if (authProvider.betterOfferIsBiggerThanLastOne) {
                                                                                    showDialog(
                                                                                        context: ct,
                                                                                        builder: (cx) => ActionDialog(
                                                                                              content: authProvider.betterOfferMessage!,
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
                                                                                receivingState: widget.bulkShipment.receivingState,
                                                                                receivingCity: null,
                                                                                deliveryState: widget.bulkShipment.deliveringState,
                                                                                deliveryCity: null,
                                                                                shipmentId: widget.bulkShipment.id,
                                                                                offerId: authProvider.offerId,
                                                                                totalShipmentCost: widget.bulkShipment.amount,
                                                                                merchantImage: widget.bulkShipment.merchant!.photo,
                                                                                merchantName: widget.bulkShipment.merchant!.name,
                                                                                childrenShipment: widget.bulkShipment.children!.length,
                                                                                shippingCost: widget.bulkShipment.expectedShippingCost,
                                                                              ),
                                                                            ));
                                                              },
                                                              onCancelCallback:
                                                                  () {
                                                                Navigator.pop(
                                                                    c);
                                                              },
                                                              message:
                                                                  authProvider
                                                                      .message!,
                                                            ));
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (c) =>
                                                            OfferConfirmationDialog(
                                                              isOffer: true,
                                                              onOkPressed:
                                                                  () async {
                                                                Navigator.pop(
                                                                    c);
                                                                DocumentSnapshot
                                                                    userToken =
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'merchant_users')
                                                                        .doc(widget
                                                                            .bulkShipment
                                                                            .merchantId
                                                                            .toString())
                                                                        .get();
                                                                String token =
                                                                    userToken[
                                                                        'fcmToken'];
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'merchant_notifications')
                                                                    .doc(widget
                                                                        .bulkShipment
                                                                        .merchantId
                                                                        .toString())
                                                                    .collection(widget
                                                                        .bulkShipment
                                                                        .merchantId
                                                                        .toString())
                                                                    .add({
                                                                  'read': false,
                                                                  'date_time': DateTime
                                                                          .now()
                                                                      .toIso8601String(),
                                                                  'type': '',
                                                                  'title':
                                                                      'عرض جديد',
                                                                  'body':
                                                                      'تم تقديم عرض جديد من الكابتن ${authProvider.name}',
                                                                  'user_icon': authProvider
                                                                          .photo!
                                                                          .isNotEmpty
                                                                      ? authProvider
                                                                              .photo!
                                                                              .contains(ApiConstants.baseUrl)
                                                                          ? authProvider.photo
                                                                          : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                      : '',
                                                                  'screen_to':
                                                                      'shipment_offers',
                                                                  'data':
                                                                      ShipmentNotification(
                                                                    receivingState: widget
                                                                        .bulkShipment
                                                                        .receivingState,
                                                                    receivingCity:
                                                                        null,
                                                                    deliveryState: widget
                                                                        .bulkShipment
                                                                        .deliveringState,
                                                                    deliveryCity:
                                                                        null,
                                                                    totalShipmentCost: widget
                                                                        .bulkShipment
                                                                        .amount,
                                                                    shipmentId:
                                                                        widget
                                                                            .bulkShipment
                                                                            .id,
                                                                    merchantImage: widget
                                                                        .bulkShipment
                                                                        .merchant!
                                                                        .photo,
                                                                    merchantName: widget
                                                                        .bulkShipment
                                                                        .merchant!
                                                                        .name,
                                                                    childrenShipment: widget
                                                                        .bulkShipment
                                                                        .children!
                                                                        .length,
                                                                    shippingCost: widget
                                                                        .bulkShipment
                                                                        .expectedShippingCost,
                                                                  ).toMap(),
                                                                });
                                                                authProvider
                                                                    .sendNotification(
                                                                  title:
                                                                      'عرض جديد',
                                                                  body:
                                                                      'تم تقديم عرض جديد من الكابتن ${authProvider.name}',
                                                                  toToken:
                                                                      token,
                                                                  image: authProvider
                                                                          .photo!
                                                                          .isNotEmpty
                                                                      ? authProvider
                                                                              .photo!
                                                                              .contains(ApiConstants.baseUrl)
                                                                          ? authProvider.photo
                                                                          : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                      : '',
                                                                  type: '',
                                                                  screenTo:
                                                                      'shipment_offers',
                                                                  data: ShipmentNotification(
                                                                          receivingState: widget
                                                                              .bulkShipment
                                                                              .receivingState,
                                                                          receivingCity:
                                                                              null,
                                                                          deliveryState: widget
                                                                              .bulkShipment
                                                                              .deliveringState,
                                                                          deliveryCity:
                                                                              null,
                                                                          shipmentId: widget
                                                                              .bulkShipment
                                                                              .id,
                                                                          merchantImage: widget
                                                                              .bulkShipment
                                                                              .merchant!
                                                                              .photo,
                                                                          merchantName: widget
                                                                              .bulkShipment
                                                                              .merchant!
                                                                              .name,
                                                                          childrenShipment: widget
                                                                              .bulkShipment
                                                                              .children!
                                                                              .length,
                                                                          shippingCost: widget
                                                                              .bulkShipment
                                                                              .expectedShippingCost,
                                                                          totalShipmentCost: widget
                                                                              .bulkShipment
                                                                              .amount)
                                                                      .toMap(),
                                                                );
                                                              },
                                                              isDone: true,
                                                            ));
                                                  }
                                                } else {
                                                  if (authProvider.noCredit) {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (c) =>
                                                                NoCreditDialog(
                                                                  onOkCancelCallback:
                                                                      () {
                                                                    Navigator
                                                                        .pop(c);
                                                                  },
                                                                  onChargeWalletCallback:
                                                                      () {
                                                                    Navigator
                                                                        .pop(c);
                                                                    walletProvider
                                                                        .setMainIndex(
                                                                            1);
                                                                    walletProvider.setDepositAmount(num.parse(widget
                                                                            .bulkShipment
                                                                            .amount!)
                                                                        .toInt());
                                                                    walletProvider
                                                                        .setDepositIndex(
                                                                            1);
                                                                    walletProvider
                                                                            .fromOfferPage =
                                                                        true;
                                                                    Navigator.pushReplacementNamed(
                                                                        c,
                                                                        Wallet
                                                                            .id);

                                                                    // showDialog(
                                                                    //     context: Preferences
                                                                    //         .instance
                                                                    //         .navigator
                                                                    //         .currentContext,
                                                                    //     barrierDismissible:
                                                                    //     false,
                                                                    //     builder:
                                                                    //         (ctx) =>
                                                                    //         ChargeWalletDialog(
                                                                    //           shipmentAmount: num
                                                                    //               .parse(
                                                                    //               widget
                                                                    //                   .bulkShipment
                                                                    //                   .amount)
                                                                    //               .toInt(),
                                                                    //           onSubmit: (
                                                                    //               String type,
                                                                    //               String value,
                                                                    //               String cardNumber,
                                                                    //               String walletNumber,
                                                                    //               String dateMonth,
                                                                    //               String dateYear,
                                                                    //               String ccvNumber,) async {
                                                                    //             if (type ==
                                                                    //                 'meeza-card') {
                                                                    //               showDialog(
                                                                    //                   context: Preferences
                                                                    //                       .instance
                                                                    //                       .navigator
                                                                    //                       .currentContext,
                                                                    //                   barrierDismissible: false,
                                                                    //                   builder: (
                                                                    //                       context) =>
                                                                    //                       Loading());
                                                                    //               await walletProvider
                                                                    //                   .addCreditWithMeeza(
                                                                    //                 amount: num
                                                                    //                     .parse(
                                                                    //                     value)
                                                                    //                     .toDouble(),
                                                                    //                 method: 'meeza-card',
                                                                    //                 pan: cardNumber
                                                                    //                     .split(
                                                                    //                     '-')
                                                                    //                     .join(),
                                                                    //                 expirationDate: '$dateYear$dateMonth',
                                                                    //                 cvv: ccvNumber,
                                                                    //               );
                                                                    //               if (walletProvider
                                                                    //                   .state ==
                                                                    //                   NetworkState
                                                                    //                       .SUCCESS) {
                                                                    //                 if (walletProvider
                                                                    //                     .meezaCard
                                                                    //                     .upgResponse !=
                                                                    //                     null) {
                                                                    //                   Navigator
                                                                    //                       .pop(
                                                                    //                       Preferences
                                                                    //                           .instance
                                                                    //                           .navigator
                                                                    //                           .currentContext);
                                                                    //                   dynamic value = await Navigator
                                                                    //                       .pushNamed(
                                                                    //                       Preferences
                                                                    //                           .instance
                                                                    //                           .navigator
                                                                    //                           .currentContext,
                                                                    //                       TransactionWebView
                                                                    //                           .id,
                                                                    //                       arguments: TransactionWebViewModel(
                                                                    //                           url: walletProvider
                                                                    //                               .meezaCard
                                                                    //                               .upgResponse
                                                                    //                               .threeDSUrl,
                                                                    //                           selectedValue: 1));
                                                                    //                   if (value !=
                                                                    //                       null) {
                                                                    //                     if (value ==
                                                                    //                         'no funds') {
                                                                    //                       showDialog(
                                                                    //                           context: Preferences
                                                                    //                               .instance
                                                                    //                               .navigator
                                                                    //                               .currentContext,
                                                                    //                           builder: (
                                                                    //                               c) =>
                                                                    //                               NoCreditInWalletDialog(
                                                                    //                                 onPressedCallback: () {
                                                                    //                                   Navigator
                                                                    //                                       .pop(
                                                                    //                                       c);
                                                                    //                                 },
                                                                    //                               ));
                                                                    //                     } else {
                                                                    //                       showDialog(
                                                                    //                           context: Preferences
                                                                    //                               .instance
                                                                    //                               .navigator
                                                                    //                               .currentContext,
                                                                    //                           barrierDismissible: false,
                                                                    //                           builder: (
                                                                    //                               context) =>
                                                                    //                               Loading());
                                                                    //                       await getMezaStatus(
                                                                    //                           walletProvider: walletProvider,
                                                                    //                           authProvider: authProvider,
                                                                    //                           value: value);
                                                                    //                     }
                                                                    //                   }
                                                                    //                 } else {
                                                                    //                   if (walletProvider
                                                                    //                       .meezaCard
                                                                    //                       .status ==
                                                                    //                       'completed') {
                                                                    //                     log(
                                                                    //                         'status compeleted');
                                                                    //                     log(
                                                                    //                         '${walletProvider
                                                                    //                             .meezaCard
                                                                    //                             .status}');
                                                                    //                     await walletProvider
                                                                    //                         .getCurrentBalance(
                                                                    //                         authorization: authProvider
                                                                    //                             .appAuthorization,
                                                                    //                         fromRefresh: false);
                                                                    //                     Navigator
                                                                    //                         .pop(
                                                                    //                         Preferences
                                                                    //                             .instance
                                                                    //                             .navigator
                                                                    //                             .currentContext);
                                                                    //                     showDialog(
                                                                    //                         context: Preferences
                                                                    //                             .instance
                                                                    //                             .navigator
                                                                    //                             .currentContext,
                                                                    //                         barrierDismissible: false,
                                                                    //                         builder: (
                                                                    //                             context) =>
                                                                    //                             ContentDialog(
                                                                    //                               content: '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider
                                                                    //                                   .meezaCard
                                                                    //                                   .transaction
                                                                    //                                   .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
                                                                    //                               callback: () {
                                                                    //                                 Navigator
                                                                    //                                     .pop(
                                                                    //                                     Preferences
                                                                    //                                         .instance
                                                                    //                                         .navigator
                                                                    //                                         .currentContext);
                                                                    //                                 walletProvider
                                                                    //                                     .setDepositIndex(
                                                                    //                                     5);
                                                                    //                                 walletProvider
                                                                    //                                     .setAccountTypeIndex(
                                                                    //                                     null);
                                                                    //                               },
                                                                    //                             ));
                                                                    //                   }
                                                                    //                 }
                                                                    //               } else
                                                                    //               if (walletProvider
                                                                    //                   .state ==
                                                                    //                   NetworkState
                                                                    //                       .ERROR) {
                                                                    //                 Navigator
                                                                    //                     .pop(
                                                                    //                     Preferences
                                                                    //                         .instance
                                                                    //                         .navigator
                                                                    //                         .currentContext);
                                                                    //                 showDialog(
                                                                    //                   context: Preferences
                                                                    //                       .instance
                                                                    //                       .navigator
                                                                    //                       .currentContext,
                                                                    //                   builder: (
                                                                    //                       context) =>
                                                                    //                       WalletDialog(
                                                                    //                         msg: 'برجاء محاولة الأيداع مرة اخري',
                                                                    //                         onPress: () {
                                                                    //                           Navigator
                                                                    //                               .pop(
                                                                    //                               Preferences
                                                                    //                                   .instance
                                                                    //                                   .navigator
                                                                    //                                   .currentContext);
                                                                    //                         },
                                                                    //                       ),
                                                                    //                 );
                                                                    //               }
                                                                    //             } else
                                                                    //             if (type ==
                                                                    //                 'e-wallet') {
                                                                    //               showDialog(
                                                                    //                   context: Preferences
                                                                    //                       .instance
                                                                    //                       .navigator
                                                                    //                       .currentContext,
                                                                    //                   barrierDismissible: false,
                                                                    //                   builder: (
                                                                    //                       context) =>
                                                                    //                       MsgDialog(
                                                                    //                         content: 'سيصلك اشعار على رقم موبايلك المسجل على محفظتك الإلكترونية لأستكمال العملية',
                                                                    //                       ));
                                                                    //               await walletProvider
                                                                    //                   .addCreditWithEWallet(
                                                                    //                 amount: num
                                                                    //                     .parse(
                                                                    //                     value)
                                                                    //                     .toDouble(),
                                                                    //                 method: 'e-wallet',
                                                                    //                 mobileNumber: walletNumber,
                                                                    //               );
                                                                    //               if (walletProvider
                                                                    //                   .state ==
                                                                    //                   NetworkState
                                                                    //                       .SUCCESS) {
                                                                    //                 t =
                                                                    //                     Timer
                                                                    //                         .periodic(
                                                                    //                         Duration(
                                                                    //                             seconds: 5), (
                                                                    //                         timer) async {
                                                                    //                       await walletProvider
                                                                    //                           .checkPaymentStatus(
                                                                    //                           systemReferenceNumber: walletProvider
                                                                    //                               .eWallet
                                                                    //                               .transaction
                                                                    //                               .details
                                                                    //                               .upgSystemRef,
                                                                    //                           transactionId: walletProvider
                                                                    //                               .eWallet
                                                                    //                               .transaction
                                                                    //                               .details
                                                                    //                               .transactionId);
                                                                    //                       if (walletProvider
                                                                    //                           .state ==
                                                                    //                           NetworkState
                                                                    //                               .SUCCESS) {
                                                                    //                         if (walletProvider
                                                                    //                             .creditStatus
                                                                    //                             .status ==
                                                                    //                             'completed') {
                                                                    //                           if (t
                                                                    //                               .isActive) {
                                                                    //                             t
                                                                    //                                 .cancel();
                                                                    //                             t =
                                                                    //                             null;
                                                                    //                           }
                                                                    //                           Navigator
                                                                    //                               .pop(
                                                                    //                               Preferences
                                                                    //                                   .instance
                                                                    //                                   .navigator
                                                                    //                                   .currentContext);
                                                                    //                           showDialog(
                                                                    //                               context: Preferences
                                                                    //                                   .instance
                                                                    //                                   .navigator
                                                                    //                                   .currentContext,
                                                                    //                               barrierDismissible: false,
                                                                    //                               builder: (
                                                                    //                                   context) =>
                                                                    //                                   ContentDialog(
                                                                    //                                     content: '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider
                                                                    //                                         .eWallet
                                                                    //                                         .transaction
                                                                    //                                         .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
                                                                    //                                     callback: () {
                                                                    //                                       Navigator
                                                                    //                                           .pop(
                                                                    //                                           Preferences
                                                                    //                                               .instance
                                                                    //                                               .navigator
                                                                    //                                               .currentContext);
                                                                    //                                       walletProvider
                                                                    //                                           .setDepositIndex(
                                                                    //                                           5);
                                                                    //                                       walletProvider
                                                                    //                                           .setAccountTypeIndex(
                                                                    //                                           null);
                                                                    //                                     },
                                                                    //                                   ));
                                                                    //                         }
                                                                    //                       }
                                                                    //                     });
                                                                    //               } else
                                                                    //               if (walletProvider
                                                                    //                   .state ==
                                                                    //                   NetworkState
                                                                    //                       .ERROR) {
                                                                    //                 Navigator
                                                                    //                     .pop(
                                                                    //                     Preferences
                                                                    //                         .instance
                                                                    //                         .navigator
                                                                    //                         .currentContext);
                                                                    //                 showDialog(
                                                                    //                   context: Preferences
                                                                    //                       .instance
                                                                    //                       .navigator
                                                                    //                       .currentContext,
                                                                    //                   builder: (
                                                                    //                       context) =>
                                                                    //                       WalletDialog(
                                                                    //                         msg: 'حدث خطأ برحاء المحاولة مرة اخري',
                                                                    //                         onPress: () {
                                                                    //                           Navigator
                                                                    //                               .pop(
                                                                    //                               Preferences
                                                                    //                                   .instance
                                                                    //                                   .navigator
                                                                    //                                   .currentContext);
                                                                    //                         },
                                                                    //                       ),
                                                                    //                 );
                                                                    //               }
                                                                    //             }
                                                                    //             log(
                                                                    //                 'type -> $type');
                                                                    //             log(
                                                                    //                 'value -> $value');
                                                                    //             log(
                                                                    //                 'cardNumber -> $cardNumber');
                                                                    //             log(
                                                                    //                 'walletNumber -> $walletNumber');
                                                                    //             log(
                                                                    //                 'dateYear -> $dateYear');
                                                                    //             log(
                                                                    //                 'dateMonth -> $dateMonth');
                                                                    //             log(
                                                                    //                 'ccvNumber -> $ccvNumber');
                                                                    //           },
                                                                    //         ));
                                                                  },
                                                                ));
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (c) =>
                                                            OfferConfirmationDialog(
                                                              onOkPressed: () {
                                                                Navigator.pop(
                                                                    c);
                                                              },
                                                              isOffer: true,
                                                              isDone: false,
                                                            ));
                                                  }
                                                }
                                              },
                                              shipmentNotification: ShipmentNotification(
                                                  shipmentId:
                                                      widget.bulkShipment.id,
                                                  shippingCost: widget
                                                      .bulkShipment
                                                      .expectedShippingCost
                                                      .toString(),
                                                  merchantName: widget
                                                      .bulkShipment
                                                      .merchant!
                                                      .name,
                                                  childrenShipment: widget
                                                      .bulkShipment
                                                      .children!
                                                      .length,
                                                  flags:
                                                      widget.bulkShipment.flags,
                                                  totalShipmentCost: widget
                                                      .bulkShipment.amount),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                            weevoPrimaryOrangeColor,
                                          ),
                                          padding: WidgetStateProperty.all<
                                                  EdgeInsets>(
                                              const EdgeInsets.symmetric(
                                                  vertical: 6.0,
                                                  horizontal: 20.0)),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'توصيل الأوردر',
                                          style: TextStyle(fontSize: 16.0.sp),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.bulkShipment.children![i]
                                          .products![0].productInfo!.name!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      widget
                                          .bulkShipment
                                          .children![i]
                                          .products![0]
                                          .productInfo!
                                          .description!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: weevoPrimaryOrangeColor,
                                      ),
                                      height: 8.h,
                                      width: 8.w,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${authProvider.getStateNameById(int.parse(widget.bulkShipment.children![i].receivingState!))} - ${authProvider.getCityNameById(int.parse(widget.bulkShipment.children![i].receivingState!), int.parse(widget.bulkShipment.children![i].receivingCity!))}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 16.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 2.5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: List.generate(
                                      3,
                                      (index) => Container(
                                        margin: const EdgeInsets.only(top: 1),
                                        height: 3,
                                        width: 3,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(1.5),
                                          color: index < 3
                                              ? weevoPrimaryOrangeColor
                                              : weevoPrimaryBlueColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: weevoPrimaryBlueColor,
                                      ),
                                      height: 8.h,
                                      width: 8.w,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${authProvider.getStateNameById(int.parse(widget.bulkShipment.children![i].deliveringState!))} - ${authProvider.getCityNameById(int.parse(widget.bulkShipment.children![i].deliveringState!), int.parse(widget.bulkShipment.children![i].deliveringCity!))}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 16.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                if (widget.bulkShipment.children![i]
                                        .distanceFromLocationToPickup !=
                                    null)
                                  Row(
                                    children: [
                                      Text(
                                        'تبعد عنك',
                                        style: TextStyle(
                                            fontSize: 13.0.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${widget.bulkShipment.children![i].distanceFromLocationToPickup} KM',
                                          style: TextStyle(
                                              fontSize: 13.0.sp,
                                              color: weevoPrimaryOrangeColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (widget.bulkShipment.children![i]
                                        .distanceFromLocationToPickup !=
                                    null)
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: const Color(0xffD8F3FF),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/money_icon.png',
                                              fit: BoxFit.contain,
                                              color: const Color(0xff091147),
                                              height: 20.h,
                                              width: 20.w,
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${double.parse(widget.bulkShipment.children![i].amount!).toInt()}',
                                                  style: TextStyle(
                                                    fontSize: 12.0.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                  'جنية',
                                                  style: TextStyle(
                                                    fontSize: 10.0.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (Preferences
                                                    .instance.getUserFlags ==
                                                'freelance') ...[
                                              Image.asset(
                                                'assets/images/van_icon.png',
                                                fit: BoxFit.contain,
                                                color: const Color(0xff091147),
                                                height: 20.h,
                                                width: 20.w,
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${double.parse(widget.bulkShipment.children![i].agreedShippingCostAfterDiscount ?? widget.bulkShipment.children![i].agreedShippingCost ?? widget.bulkShipment.children![i].shippingCost ?? '0').toInt()}',
                                                      style: TextStyle(
                                                        fontSize: 12.0.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text(
                                                      'جنية',
                                                      style: TextStyle(
                                                        fontSize: 10.0.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    widget.bulkShipment.children!.length > 1
                        ? Positioned(
                            top: size.height * 0.21,
                            right: size.width * 0.42,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  widget.bulkShipment.children!.length,
                                  (index) => _currentIndex == index
                                      ? const CategoryDotes(
                                          isActive: true,
                                          isPlus: true,
                                        )
                                      : const CategoryDotes(
                                          isActive: false,
                                          isPlus: false,
                                        ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            )
          : Container(
              margin: const EdgeInsets.only(bottom: 6.0),
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(alignment: Alignment.bottomCenter, children: [
                        CustomImage(
                          image: widget
                              .bulkShipment.products!.first.productInfo!.image!,
                          height: 150.0.h,
                          width: 150.0.h,
                          radius: 30,
                        ),
                        widget.bulkShipment.status == 'available'
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => InsideOfferDialog(
                                        onShippingCostPressed: (String v,
                                            String shippingCost,
                                            String shippingAmount) {
                                          walletProvider.agreedAmount =
                                              double.parse(shippingCost)
                                                  .toInt();
                                          if (v == 'DONE') {
                                            showDialog(
                                                context: context,
                                                builder: (c) =>
                                                    OfferConfirmationDialog(
                                                      onOkPressed: () async {
                                                        Navigator.pop(c);
                                                        await shipmentProvider
                                                            .getOfferBasedShipment(
                                                                isPagination:
                                                                    false,
                                                                isRefreshing:
                                                                    false,
                                                                isFirstTime:
                                                                    false);
                                                        await WeevoCaptain
                                                            .facebookAppEvents
                                                            .logInitiatedCheckout(
                                                                totalPrice: num.parse(widget
                                                                        .bulkShipment
                                                                        .amount!)
                                                                    .toDouble(),
                                                                currency:
                                                                    'EGP');
                                                        DocumentSnapshot
                                                            userToken =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'merchant_users')
                                                                .doc(widget
                                                                    .bulkShipment
                                                                    .merchantId
                                                                    .toString())
                                                                .get();
                                                        String token =
                                                            userToken[
                                                                'fcmToken'];
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'merchant_notifications')
                                                            .doc(widget
                                                                .bulkShipment
                                                                .merchantId
                                                                .toString())
                                                            .collection(widget
                                                                .bulkShipment
                                                                .merchantId
                                                                .toString())
                                                            .add({
                                                          'read': false,
                                                          'date_time': DateTime
                                                                  .now()
                                                              .toIso8601String(),
                                                          'type':
                                                              'cancel_shipment',
                                                          'title':
                                                              'ويفو وفرلك كابتن',
                                                          'body':
                                                              'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالشحنة',
                                                          'user_icon': authProvider
                                                                  .photo!
                                                                  .isNotEmpty
                                                              ? authProvider
                                                                      .photo!
                                                                      .contains(
                                                                          ApiConstants
                                                                              .baseUrl)
                                                                  ? authProvider
                                                                      .photo
                                                                  : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                              : '',
                                                          'screen_to':
                                                              'shipment_screen',
                                                          'data': ShipmentTrackingModel(
                                                                  shipmentId: widget
                                                                      .bulkShipment
                                                                      .id,
                                                                  hasChildren:
                                                                      1)
                                                              .toJson(),
                                                        });
                                                        await authProvider
                                                            .sendNotification(
                                                                title:
                                                                    'ويفو وفرلك كابتن',
                                                                body:
                                                                    'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالشحنة',
                                                                toToken: token,
                                                                image: authProvider
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
                                                                data: ShipmentTrackingModel(
                                                                        shipmentId: widget
                                                                            .bulkShipment
                                                                            .id,
                                                                        hasChildren:
                                                                            1)
                                                                    .toJson(),
                                                                screenTo:
                                                                    'shipment_screen',
                                                                type:
                                                                    'cancel_shipment');
                                                      },
                                                      isDone: true,
                                                      isOffer: false,
                                                    ));
                                          } else {
                                            if (shipmentProvider.noCredit!) {
                                              showDialog(
                                                  context:
                                                      navigator.currentContext!,
                                                  barrierDismissible: false,
                                                  builder: (c) =>
                                                      NoCreditDialog(
                                                        onOkCancelCallback: () {
                                                          Navigator.pop(c);
                                                        },
                                                        onChargeWalletCallback:
                                                            () {
                                                          Navigator.pop(c);
                                                          walletProvider
                                                              .setMainIndex(1);
                                                          walletProvider
                                                              .setDepositAmount(
                                                                  num.parse(widget
                                                                          .bulkShipment
                                                                          .amount!)
                                                                      .toInt());
                                                          walletProvider
                                                              .setDepositIndex(
                                                                  1);
                                                          walletProvider
                                                                  .fromOfferPage =
                                                              true;
                                                          Navigator
                                                              .pushReplacementNamed(
                                                                  c, Wallet.id);

                                                          // showDialog(
                                                          //     context: Preferences
                                                          //         .instance
                                                          //         .navigator
                                                          //         .currentContext,
                                                          //     barrierDismissible:
                                                          //     false,
                                                          //     builder: (ctx) =>
                                                          //         ChargeWalletDialog(
                                                          //           shipmentAmount:
                                                          //           num.parse(widget
                                                          //               .bulkShipment
                                                          //               .amount)
                                                          //               .toInt(),
                                                          //           onSubmit: (String type,
                                                          //               String value,
                                                          //               String
                                                          //               cardNumber,
                                                          //               String
                                                          //               walletNumber,
                                                          //               String
                                                          //               dateMonth,
                                                          //               String
                                                          //               dateYear,
                                                          //               String
                                                          //               ccvNumber,) async {
                                                          //             if (type ==
                                                          //                 'meeza-card') {
                                                          //               showDialog(
                                                          //                   context: Preferences
                                                          //                       .instance
                                                          //                       .navigator
                                                          //                       .currentContext,
                                                          //                   barrierDismissible:
                                                          //                   false,
                                                          //                   builder:
                                                          //                       (context) =>
                                                          //                       Loading());
                                                          //               await walletProvider
                                                          //                   .addCreditWithMeeza(
                                                          //                 amount: num.parse(
                                                          //                     value)
                                                          //                     .toDouble(),
                                                          //                 method:
                                                          //                 'meeza-card',
                                                          //                 pan: cardNumber
                                                          //                     .split(
                                                          //                     '-')
                                                          //                     .join(),
                                                          //                 expirationDate:
                                                          //                 '$dateYear$dateMonth',
                                                          //                 cvv:
                                                          //                 ccvNumber,
                                                          //               );
                                                          //               if (walletProvider
                                                          //                   .state ==
                                                          //                   NetworkState
                                                          //                       .SUCCESS) {
                                                          //                 if (walletProvider
                                                          //                     .meezaCard
                                                          //                     .upgResponse !=
                                                          //                     null) {
                                                          //                   Navigator.pop(
                                                          //                       Preferences
                                                          //                           .instance
                                                          //                           .navigator
                                                          //                           .currentContext);
                                                          //                   dynamic value = await Navigator
                                                          //                       .pushNamed(
                                                          //                       Preferences
                                                          //                           .instance
                                                          //                           .navigator
                                                          //                           .currentContext,
                                                          //                       TransactionWebView
                                                          //                           .id,
                                                          //                       arguments:
                                                          //                       TransactionWebViewModel(
                                                          //                           url: walletProvider
                                                          //                               .meezaCard
                                                          //                               .upgResponse
                                                          //                               .threeDSUrl,
                                                          //                           selectedValue: 1));
                                                          //                   if (value !=
                                                          //                       null) {
                                                          //                     if (value ==
                                                          //                         'no funds') {
                                                          //                       showDialog(
                                                          //                           context: Preferences
                                                          //                               .instance
                                                          //                               .navigator
                                                          //                               .currentContext,
                                                          //                           builder: (
                                                          //                               c) =>
                                                          //                               NoCreditInWalletDialog(
                                                          //                                 onPressedCallback: () {
                                                          //                                   Navigator
                                                          //                                       .pop(
                                                          //                                       c);
                                                          //                                 },
                                                          //                               ));
                                                          //                     } else {
                                                          //                       showDialog(
                                                          //                           context: Preferences
                                                          //                               .instance
                                                          //                               .navigator
                                                          //                               .currentContext,
                                                          //                           barrierDismissible: false,
                                                          //                           builder: (
                                                          //                               context) =>
                                                          //                               Loading());
                                                          //                       await getMezaStatus(
                                                          //                           walletProvider: walletProvider,
                                                          //                           authProvider: authProvider,
                                                          //                           value: value);
                                                          //                     }
                                                          //                   }
                                                          //                 } else {
                                                          //                   if (walletProvider
                                                          //                       .meezaCard
                                                          //                       .status ==
                                                          //                       'completed') {
                                                          //                     log(
                                                          //                         'status compeleted');
                                                          //                     log(
                                                          //                         '${walletProvider
                                                          //                             .meezaCard
                                                          //                             .status}');
                                                          //                     await walletProvider
                                                          //                         .getCurrentBalance(
                                                          //                         authorization: authProvider
                                                          //                             .appAuthorization,
                                                          //                         fromRefresh: false);
                                                          //                     Navigator.pop(
                                                          //                         Preferences
                                                          //                             .instance
                                                          //                             .navigator
                                                          //                             .currentContext);
                                                          //                     showDialog(
                                                          //                         context: Preferences
                                                          //                             .instance
                                                          //                             .navigator
                                                          //                             .currentContext,
                                                          //                         barrierDismissible: false,
                                                          //                         builder: (
                                                          //                             context) =>
                                                          //                             ContentDialog(
                                                          //                               content: '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider
                                                          //                                   .meezaCard
                                                          //                                   .transaction
                                                          //                                   .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
                                                          //                               callback: () {
                                                          //                                 Navigator
                                                          //                                     .pop(
                                                          //                                     Preferences
                                                          //                                         .instance
                                                          //                                         .navigator
                                                          //                                         .currentContext);
                                                          //                                 walletProvider
                                                          //                                     .setDepositIndex(
                                                          //                                     5);
                                                          //                                 walletProvider
                                                          //                                     .setAccountTypeIndex(
                                                          //                                     null);
                                                          //                               },
                                                          //                             ));
                                                          //                   }
                                                          //                 }
                                                          //               } else
                                                          //               if (walletProvider
                                                          //                   .state ==
                                                          //                   NetworkState
                                                          //                       .ERROR) {
                                                          //                 Navigator.pop(
                                                          //                     Preferences
                                                          //                         .instance
                                                          //                         .navigator
                                                          //                         .currentContext);
                                                          //                 showDialog(
                                                          //                   context: Preferences
                                                          //                       .instance
                                                          //                       .navigator
                                                          //                       .currentContext,
                                                          //                   builder:
                                                          //                       (context) =>
                                                          //                       WalletDialog(
                                                          //                         msg:
                                                          //                         'برجاء محاولة الأيداع مرة اخري',
                                                          //                         onPress:
                                                          //                             () {
                                                          //                           Navigator
                                                          //                               .pop(
                                                          //                               Preferences
                                                          //                                   .instance
                                                          //                                   .navigator
                                                          //                                   .currentContext);
                                                          //                         },
                                                          //                       ),
                                                          //                 );
                                                          //               }
                                                          //             } else if (type ==
                                                          //                 'e-wallet') {
                                                          //               showDialog(
                                                          //                   context: Preferences
                                                          //                       .instance
                                                          //                       .navigator
                                                          //                       .currentContext,
                                                          //                   barrierDismissible:
                                                          //                   false,
                                                          //                   builder: (
                                                          //                       context) =>
                                                          //                       MsgDialog(
                                                          //                         content: 'سيصلك اشعار على رقم موبايلك المسجل على محفظتك الإلكترونية لأستكمال العملية',
                                                          //                       ));
                                                          //               await walletProvider
                                                          //                   .addCreditWithEWallet(
                                                          //                 amount: num.parse(
                                                          //                     value)
                                                          //                     .toDouble(),
                                                          //                 method:
                                                          //                 'e-wallet',
                                                          //                 mobileNumber:
                                                          //                 walletNumber,
                                                          //               );
                                                          //               if (walletProvider
                                                          //                   .state ==
                                                          //                   NetworkState
                                                          //                       .SUCCESS) {
                                                          //                 t = Timer
                                                          //                     .periodic(
                                                          //                     Duration(
                                                          //                         seconds: 5),
                                                          //                         (
                                                          //                         timer) async {
                                                          //                       await walletProvider
                                                          //                           .checkPaymentStatus(
                                                          //                           systemReferenceNumber:
                                                          //                           walletProvider
                                                          //                               .eWallet
                                                          //                               .transaction
                                                          //                               .details
                                                          //                               .upgSystemRef,
                                                          //                           transactionId: walletProvider
                                                          //                               .eWallet
                                                          //                               .transaction
                                                          //                               .details
                                                          //                               .transactionId);
                                                          //                       if (walletProvider
                                                          //                           .state ==
                                                          //                           NetworkState
                                                          //                               .SUCCESS) {
                                                          //                         if (walletProvider
                                                          //                             .creditStatus
                                                          //                             .status ==
                                                          //                             'completed') {
                                                          //                           if (t
                                                          //                               .isActive) {
                                                          //                             t
                                                          //                                 .cancel();
                                                          //                             t =
                                                          //                             null;
                                                          //                           }
                                                          //                           Navigator
                                                          //                               .pop(
                                                          //                               Preferences
                                                          //                                   .instance
                                                          //                                   .navigator
                                                          //                                   .currentContext);
                                                          //                           showDialog(
                                                          //                               context: Preferences
                                                          //                                   .instance
                                                          //                                   .navigator
                                                          //                                   .currentContext,
                                                          //                               barrierDismissible: false,
                                                          //                               builder: (
                                                          //                                   context) =>
                                                          //                                   ContentDialog(
                                                          //                                     content: '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider
                                                          //                                         .eWallet
                                                          //                                         .transaction
                                                          //                                         .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
                                                          //                                     callback: () {
                                                          //                                       Navigator
                                                          //                                           .pop(
                                                          //                                           Preferences
                                                          //                                               .instance
                                                          //                                               .navigator
                                                          //                                               .currentContext);
                                                          //                                       walletProvider
                                                          //                                           .setDepositIndex(
                                                          //                                           5);
                                                          //                                       walletProvider
                                                          //                                           .setAccountTypeIndex(
                                                          //                                           null);
                                                          //                                     },
                                                          //                                   ));
                                                          //                         }
                                                          //                       }
                                                          //                     });
                                                          //               } else
                                                          //               if (walletProvider
                                                          //                   .state ==
                                                          //                   NetworkState
                                                          //                       .ERROR) {
                                                          //                 Navigator.pop(
                                                          //                     Preferences
                                                          //                         .instance
                                                          //                         .navigator
                                                          //                         .currentContext);
                                                          //                 showDialog(
                                                          //                   context: Preferences
                                                          //                       .instance
                                                          //                       .navigator
                                                          //                       .currentContext,
                                                          //                   builder:
                                                          //                       (context) =>
                                                          //                       WalletDialog(
                                                          //                         msg:
                                                          //                         'حدث خطأ برحاء المحاولة مرة اخري',
                                                          //                         onPress:
                                                          //                             () {
                                                          //                           Navigator
                                                          //                               .pop(
                                                          //                               Preferences
                                                          //                                   .instance
                                                          //                                   .navigator
                                                          //                                   .currentContext);
                                                          //                         },
                                                          //                       ),
                                                          //                 );
                                                          //               }
                                                          //             }
                                                          //             log('type -> $type');
                                                          //             log(
                                                          //                 'value -> $value');
                                                          //             log(
                                                          //                 'cardNumber -> $cardNumber');
                                                          //             log(
                                                          //                 'walletNumber -> $walletNumber');
                                                          //             log(
                                                          //                 'dateYear -> $dateYear');
                                                          //             log(
                                                          //                 'dateMonth -> $dateMonth');
                                                          //             log(
                                                          //                 'ccvNumber -> $ccvNumber');
                                                          //           },
                                                          //         ));
                                                        },
                                                      ));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (c) =>
                                                      OfferConfirmationDialog(
                                                        onOkPressed: () async {
                                                          Navigator.pop(c);
                                                        },
                                                        isDone: false,
                                                        isOffer: false,
                                                      ));
                                            }
                                          }
                                        },
                                        onShippingOfferPressed: (String v,
                                            int offer, String totalShipment) {
                                          log('onShippingOfferPressed -> $v');
                                          log('onShippingOfferPressed -> $offer');
                                          walletProvider.agreedAmount = offer;

                                          if (v == 'DONE') {
                                            if (authProvider.updateOffer!) {
                                              showDialog(
                                                  context: context,
                                                  builder: (c) =>
                                                      UpdateOfferRequestDialog(
                                                        onBetterOfferCallback:
                                                            () {
                                                          Navigator.pop(c);
                                                          showDialog(
                                                              context: c,
                                                              builder: (ct) =>
                                                                  UpdateOfferDialog(
                                                                    onBetterShippingOfferPressed: (String
                                                                            v,
                                                                        int
                                                                            offer,
                                                                        String
                                                                            totalCost) {
                                                                      if (v ==
                                                                          'DONE') {
                                                                        showDialog(
                                                                            context:
                                                                                ct,
                                                                            builder: (cx) =>
                                                                                OfferConfirmationDialog(
                                                                                  isOffer: true,
                                                                                  onOkPressed: () async {
                                                                                    Navigator.pop(cx);
                                                                                    DocumentSnapshot userToken = await FirebaseFirestore.instance
                                                                                        .collection('merchant_users')
                                                                                        .doc(
                                                                                          widget.bulkShipment.merchantId.toString(),
                                                                                        )
                                                                                        .get();
                                                                                    String token = userToken['fcmToken'];
                                                                                    FirebaseFirestore.instance.collection('merchant_notifications').doc(widget.bulkShipment.merchantId.toString()).collection(widget.bulkShipment.merchantId.toString()).add({
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
                                                                                        receivingState: widget.bulkShipment.receivingState,
                                                                                        receivingCity: null,
                                                                                        deliveryState: widget.bulkShipment.deliveringState,
                                                                                        deliveryCity: null,
                                                                                        totalShipmentCost: widget.bulkShipment.amount,
                                                                                        shipmentId: widget.bulkShipment.id,
                                                                                        merchantImage: widget.bulkShipment.merchant!.photo,
                                                                                        merchantName: widget.bulkShipment.merchant!.name,
                                                                                        childrenShipment: widget.bulkShipment.children!.length,
                                                                                        shippingCost: widget.bulkShipment.expectedShippingCost,
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
                                                                                          receivingState: widget.bulkShipment.receivingState,
                                                                                          receivingCity: null,
                                                                                          deliveryState: widget.bulkShipment.deliveringState,
                                                                                          deliveryCity: null,
                                                                                          totalShipmentCost: widget.bulkShipment.amount,
                                                                                          shipmentId: widget.bulkShipment.id,
                                                                                          merchantImage: widget.bulkShipment.merchant!.photo,
                                                                                          merchantName: widget.bulkShipment.merchant!.name,
                                                                                          childrenShipment: widget.bulkShipment.children!.length,
                                                                                          shippingCost: widget.bulkShipment.expectedShippingCost,
                                                                                        ).toMap());
                                                                                  },
                                                                                  isDone: true,
                                                                                ));
                                                                      } else {
                                                                        if (authProvider
                                                                            .betterOfferIsBiggerThanLastOne) {
                                                                          showDialog(
                                                                              context: ct,
                                                                              builder: (cx) => ActionDialog(
                                                                                    content: authProvider.betterOfferMessage!,
                                                                                    onApproveClick: () {
                                                                                      Navigator.pop(cx);
                                                                                    },
                                                                                    approveAction: 'حسناً',
                                                                                  ));
                                                                        } else {
                                                                          showDialog(
                                                                              context: ct,
                                                                              builder: (cx) => OfferConfirmationDialog(
                                                                                    onOkPressed: () {
                                                                                      Navigator.pop(cx);
                                                                                    },
                                                                                    isDone: false,
                                                                                    isOffer: true,
                                                                                  ));
                                                                        }
                                                                      }
                                                                    },
                                                                    shipmentNotification:
                                                                        ShipmentNotification(
                                                                      receivingState: widget
                                                                          .bulkShipment
                                                                          .receivingState,
                                                                      receivingCity:
                                                                          null,
                                                                      deliveryState: widget
                                                                          .bulkShipment
                                                                          .deliveringState,
                                                                      deliveryCity:
                                                                          null,
                                                                      shipmentId:
                                                                          widget
                                                                              .bulkShipment
                                                                              .id,
                                                                      offerId:
                                                                          authProvider
                                                                              .offerId,
                                                                      totalShipmentCost: widget
                                                                          .bulkShipment
                                                                          .amount,
                                                                      merchantImage: widget
                                                                          .bulkShipment
                                                                          .merchant!
                                                                          .photo,
                                                                      merchantName: widget
                                                                          .bulkShipment
                                                                          .merchant!
                                                                          .name,
                                                                      childrenShipment: widget
                                                                          .bulkShipment
                                                                          .children!
                                                                          .length,
                                                                      shippingCost: widget
                                                                          .bulkShipment
                                                                          .expectedShippingCost,
                                                                    ),
                                                                  ));
                                                        },
                                                        onCancelCallback: () {
                                                          Navigator.pop(c);
                                                        },
                                                        message: authProvider
                                                            .message!,
                                                      ));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (c) =>
                                                      OfferConfirmationDialog(
                                                        isOffer: true,
                                                        onOkPressed: () async {
                                                          Navigator.pop(c);
                                                          DocumentSnapshot
                                                              userToken =
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'merchant_users')
                                                                  .doc(widget
                                                                      .bulkShipment
                                                                      .merchantId
                                                                      .toString())
                                                                  .get();
                                                          String token =
                                                              userToken[
                                                                  'fcmToken'];
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'merchant_notifications')
                                                              .doc(widget
                                                                  .bulkShipment
                                                                  .merchantId
                                                                  .toString())
                                                              .collection(widget
                                                                  .bulkShipment
                                                                  .merchantId
                                                                  .toString())
                                                              .add({
                                                            'read': false,
                                                            'date_time': DateTime
                                                                    .now()
                                                                .toIso8601String(),
                                                            'type': '',
                                                            'title': 'عرض جديد',
                                                            'body':
                                                                'تم تقديم عرض جديد من الكابتن ${authProvider.name}',
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
                                                            'data':
                                                                ShipmentNotification(
                                                              receivingState: widget
                                                                  .bulkShipment
                                                                  .receivingState,
                                                              receivingCity:
                                                                  null,
                                                              deliveryState: widget
                                                                  .bulkShipment
                                                                  .deliveringState,
                                                              deliveryCity:
                                                                  null,
                                                              totalShipmentCost:
                                                                  widget
                                                                      .bulkShipment
                                                                      .amount,
                                                              shipmentId: widget
                                                                  .bulkShipment
                                                                  .id,
                                                              merchantImage: widget
                                                                  .bulkShipment
                                                                  .merchant!
                                                                  .photo,
                                                              merchantName: widget
                                                                  .bulkShipment
                                                                  .merchant!
                                                                  .name,
                                                              childrenShipment:
                                                                  widget
                                                                      .bulkShipment
                                                                      .children!
                                                                      .length,
                                                              shippingCost: widget
                                                                  .bulkShipment
                                                                  .expectedShippingCost,
                                                            ).toMap(),
                                                          });
                                                          authProvider
                                                              .sendNotification(
                                                                  title:
                                                                      'عرض جديد',
                                                                  body:
                                                                      'تم تقديم عرض جديد من الكابتن ${authProvider.name}',
                                                                  toToken:
                                                                      token,
                                                                  image: authProvider
                                                                          .photo!
                                                                          .isNotEmpty
                                                                      ? authProvider.photo!.contains(ApiConstants
                                                                              .baseUrl)
                                                                          ? authProvider
                                                                              .photo
                                                                          : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                      : '',
                                                                  type: '',
                                                                  screenTo:
                                                                      'shipment_offers',
                                                                  data: ShipmentNotification(
                                                                          receivingState: widget
                                                                              .bulkShipment
                                                                              .receivingState,
                                                                          receivingCity:
                                                                              null,
                                                                          deliveryState: widget
                                                                              .bulkShipment
                                                                              .deliveringState,
                                                                          deliveryCity:
                                                                              null,
                                                                          shipmentId: widget
                                                                              .bulkShipment
                                                                              .id,
                                                                          merchantImage: widget
                                                                              .bulkShipment
                                                                              .merchant!
                                                                              .photo,
                                                                          merchantName: widget
                                                                              .bulkShipment
                                                                              .merchant!
                                                                              .name,
                                                                          childrenShipment: widget
                                                                              .bulkShipment
                                                                              .children!
                                                                              .length,
                                                                          shippingCost: widget
                                                                              .bulkShipment
                                                                              .expectedShippingCost,
                                                                          totalShipmentCost: widget
                                                                              .bulkShipment
                                                                              .amount)
                                                                      .toMap());
                                                        },
                                                        isDone: true,
                                                      ));
                                            }
                                          } else {
                                            if (authProvider.noCredit) {
                                              showDialog(
                                                  context:
                                                      navigator.currentContext!,
                                                  barrierDismissible: false,
                                                  builder: (c) =>
                                                      NoCreditDialog(
                                                        onOkCancelCallback: () {
                                                          Navigator.pop(c);
                                                        },
                                                        onChargeWalletCallback:
                                                            () {
                                                          Navigator.pop(c);
                                                          walletProvider
                                                              .setMainIndex(1);

                                                          walletProvider
                                                              .setDepositAmount(
                                                                  num.parse(widget
                                                                          .bulkShipment
                                                                          .amount!)
                                                                      .toInt());
                                                          walletProvider
                                                              .setDepositIndex(
                                                                  1);
                                                          walletProvider
                                                                  .fromOfferPage =
                                                              true;
                                                          Navigator
                                                              .pushReplacementNamed(
                                                                  c, Wallet.id);

                                                          // showDialog(
                                                          //     context: Preferences
                                                          //         .instance
                                                          //         .navigator
                                                          //         .currentContext,
                                                          //     barrierDismissible:
                                                          //     false,
                                                          //     builder: (ctx) =>
                                                          //         ChargeWalletDialog(
                                                          //           shipmentAmount:
                                                          //           num.parse(widget
                                                          //               .bulkShipment
                                                          //               .amount)
                                                          //               .toInt(),
                                                          //           onSubmit: (String type,
                                                          //               String value,
                                                          //               String
                                                          //               cardNumber,
                                                          //               String
                                                          //               walletNumber,
                                                          //               String
                                                          //               dateMonth,
                                                          //               String
                                                          //               dateYear,
                                                          //               String
                                                          //               ccvNumber,) async {
                                                          //             if (type ==
                                                          //                 'meeza-card') {
                                                          //               showDialog(
                                                          //                   context: Preferences
                                                          //                       .instance
                                                          //                       .navigator
                                                          //                       .currentContext,
                                                          //                   barrierDismissible:
                                                          //                   false,
                                                          //                   builder:
                                                          //                       (context) =>
                                                          //                       Loading());
                                                          //               await walletProvider
                                                          //                   .addCreditWithMeeza(
                                                          //                 amount: num.parse(
                                                          //                     value)
                                                          //                     .toDouble(),
                                                          //                 method:
                                                          //                 'meeza-card',
                                                          //                 pan: cardNumber
                                                          //                     .split(
                                                          //                     '-')
                                                          //                     .join(),
                                                          //                 expirationDate:
                                                          //                 '$dateYear$dateMonth',
                                                          //                 cvv:
                                                          //                 ccvNumber,
                                                          //               );
                                                          //               if (walletProvider
                                                          //                   .state ==
                                                          //                   NetworkState
                                                          //                       .SUCCESS) {
                                                          //                 if (walletProvider
                                                          //                     .meezaCard
                                                          //                     .upgResponse !=
                                                          //                     null) {
                                                          //                   Navigator.pop(
                                                          //                       Preferences
                                                          //                           .instance
                                                          //                           .navigator
                                                          //                           .currentContext);
                                                          //                   dynamic value = await Navigator
                                                          //                       .pushNamed(
                                                          //                       Preferences
                                                          //                           .instance
                                                          //                           .navigator
                                                          //                           .currentContext,
                                                          //                       TransactionWebView
                                                          //                           .id,
                                                          //                       arguments:
                                                          //                       TransactionWebViewModel(
                                                          //                           url: walletProvider
                                                          //                               .meezaCard
                                                          //                               .upgResponse
                                                          //                               .threeDSUrl,
                                                          //                           selectedValue: 1));
                                                          //                   if (value !=
                                                          //                       null) {
                                                          //                     if (value ==
                                                          //                         'no funds') {
                                                          //                       showDialog(
                                                          //                           context: Preferences
                                                          //                               .instance
                                                          //                               .navigator
                                                          //                               .currentContext,
                                                          //                           builder: (
                                                          //                               c) =>
                                                          //                               NoCreditInWalletDialog(
                                                          //                                 onPressedCallback: () {
                                                          //                                   Navigator
                                                          //                                       .pop(
                                                          //                                       c);
                                                          //                                 },
                                                          //                               ));
                                                          //                     }
                                                          //                     else {
                                                          //                       showDialog(
                                                          //                           context: Preferences
                                                          //                               .instance
                                                          //                               .navigator
                                                          //                               .currentContext,
                                                          //                           barrierDismissible: false,
                                                          //                           builder: (
                                                          //                               context) =>
                                                          //                               Loading());
                                                          //                       await getMezaStatus(
                                                          //                           walletProvider: walletProvider,
                                                          //                           authProvider: authProvider,
                                                          //                           value: value);
                                                          //                     }
                                                          //                   }
                                                          //                 }
                                                          //                 else {
                                                          //                   if (walletProvider
                                                          //                       .meezaCard
                                                          //                       .status ==
                                                          //                       'completed') {
                                                          //                     log(
                                                          //                         'status compeleted');
                                                          //                     log(
                                                          //                         '${walletProvider
                                                          //                             .meezaCard
                                                          //                             .status}');
                                                          //                     Navigator.pop(
                                                          //                         Preferences
                                                          //                             .instance
                                                          //                             .navigator
                                                          //                             .currentContext);
                                                          //                     showDialog(
                                                          //                         context: Preferences
                                                          //                             .instance
                                                          //                             .navigator
                                                          //                             .currentContext,
                                                          //                         barrierDismissible: false,
                                                          //                         builder: (
                                                          //                             context) =>
                                                          //                             ContentDialog(
                                                          //                               content: '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider
                                                          //                                   .meezaCard
                                                          //                                   .transaction
                                                          //                                   .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
                                                          //                               callback: () {
                                                          //                                 Navigator
                                                          //                                     .pop(
                                                          //                                     Preferences
                                                          //                                         .instance
                                                          //                                         .navigator
                                                          //                                         .currentContext);
                                                          //                                 walletProvider
                                                          //                                     .setDepositIndex(
                                                          //                                     5);
                                                          //                                 walletProvider
                                                          //                                     .setAccountTypeIndex(
                                                          //                                     null);
                                                          //                               },
                                                          //                             ));
                                                          //                   }
                                                          //                 }
                                                          //               }
                                                          //               else
                                                          //               if (walletProvider
                                                          //                   .state ==
                                                          //                   NetworkState
                                                          //                       .ERROR) {
                                                          //                 Navigator.pop(
                                                          //                     Preferences
                                                          //                         .instance
                                                          //                         .navigator
                                                          //                         .currentContext);
                                                          //                 showDialog(
                                                          //                   context: Preferences
                                                          //                       .instance
                                                          //                       .navigator
                                                          //                       .currentContext,
                                                          //                   builder:
                                                          //                       (context) =>
                                                          //                       WalletDialog(
                                                          //                         msg:
                                                          //                         'برجاء محاولة الأيداع مرة اخري',
                                                          //                         onPress:
                                                          //                             () {
                                                          //                           Navigator
                                                          //                               .pop(
                                                          //                               Preferences
                                                          //                                   .instance
                                                          //                                   .navigator
                                                          //                                   .currentContext);
                                                          //                         },
                                                          //                       ),
                                                          //                 );
                                                          //               }
                                                          //             }
                                                          //             else if (type ==
                                                          //                 'e-wallet') {
                                                          //               showDialog(
                                                          //                   context: Preferences
                                                          //                       .instance
                                                          //                       .navigator
                                                          //                       .currentContext,
                                                          //                   barrierDismissible:
                                                          //                   false,
                                                          //                   builder: (
                                                          //                       context) =>
                                                          //                       MsgDialog(
                                                          //                         content: 'سيصلك اشعار على رقم موبايلك المسجل على محفظتك الإلكترونية لأستكمال العملية',
                                                          //                       ));
                                                          //               await walletProvider
                                                          //                   .addCreditWithEWallet(
                                                          //                 amount: num.parse(
                                                          //                     value)
                                                          //                     .toDouble(),
                                                          //                 method:
                                                          //                 'e-wallet',
                                                          //                 mobileNumber:
                                                          //                 walletNumber,
                                                          //               );
                                                          //               if (walletProvider
                                                          //                   .state ==
                                                          //                   NetworkState
                                                          //                       .SUCCESS) {
                                                          //                 t = Timer
                                                          //                     .periodic(
                                                          //                     Duration(
                                                          //                         seconds: 5),
                                                          //                         (
                                                          //                         timer) async {
                                                          //                       await walletProvider
                                                          //                           .checkPaymentStatus(
                                                          //                           systemReferenceNumber:
                                                          //                           walletProvider
                                                          //                               .eWallet
                                                          //                               .transaction
                                                          //                               .details
                                                          //                               .upgSystemRef,
                                                          //                           transactionId: walletProvider
                                                          //                               .eWallet
                                                          //                               .transaction
                                                          //                               .details
                                                          //                               .transactionId);
                                                          //                       if (walletProvider
                                                          //                           .state ==
                                                          //                           NetworkState
                                                          //                               .SUCCESS) {
                                                          //                         if (walletProvider
                                                          //                             .creditStatus
                                                          //                             .status ==
                                                          //                             'completed') {
                                                          //                           if (t
                                                          //                               .isActive) {
                                                          //                             t
                                                          //                                 .cancel();
                                                          //                             t =
                                                          //                             null;
                                                          //                           }
                                                          //                           Navigator
                                                          //                               .pop(
                                                          //                               Preferences
                                                          //                                   .instance
                                                          //                                   .navigator
                                                          //                                   .currentContext);
                                                          //                           showDialog(
                                                          //                               context: Preferences
                                                          //                                   .instance
                                                          //                                   .navigator
                                                          //                                   .currentContext,
                                                          //                               barrierDismissible: false,
                                                          //                               builder: (
                                                          //                                   context) =>
                                                          //                                   ContentDialog(
                                                          //                                     content: '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider
                                                          //                                         .eWallet
                                                          //                                         .transaction
                                                          //                                         .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
                                                          //                                     callback: () {
                                                          //                                       Navigator
                                                          //                                           .pop(
                                                          //                                           Preferences
                                                          //                                               .instance
                                                          //                                               .navigator
                                                          //                                               .currentContext);
                                                          //                                       walletProvider
                                                          //                                           .setDepositIndex(
                                                          //                                           5);
                                                          //                                       walletProvider
                                                          //                                           .setAccountTypeIndex(
                                                          //                                           null);
                                                          //                                     },
                                                          //                                   ));
                                                          //                         }
                                                          //                       }
                                                          //                     });
                                                          //               } else
                                                          //               if (walletProvider
                                                          //                   .state ==
                                                          //                   NetworkState
                                                          //                       .ERROR) {
                                                          //                 Navigator.pop(
                                                          //                     Preferences
                                                          //                         .instance
                                                          //                         .navigator
                                                          //                         .currentContext);
                                                          //                 showDialog(
                                                          //                   context: Preferences
                                                          //                       .instance
                                                          //                       .navigator
                                                          //                       .currentContext,
                                                          //                   builder:
                                                          //                       (context) =>
                                                          //                       WalletDialog(
                                                          //                         msg:
                                                          //                         'حدث خطأ برحاء المحاولة مرة اخري',
                                                          //                         onPress:
                                                          //                             () {
                                                          //                           Navigator
                                                          //                               .pop(
                                                          //                               Preferences
                                                          //                                   .instance
                                                          //                                   .navigator
                                                          //                                   .currentContext);
                                                          //                         },
                                                          //                       ),
                                                          //                 );
                                                          //               }
                                                          //             }
                                                          //             log('type -> $type');
                                                          //             log(
                                                          //                 'value -> $value');
                                                          //             log(
                                                          //                 'cardNumber -> $cardNumber');
                                                          //             log(
                                                          //                 'walletNumber -> $walletNumber');
                                                          //             log(
                                                          //                 'dateYear -> $dateYear');
                                                          //             log(
                                                          //                 'dateMonth -> $dateMonth');
                                                          //             log(
                                                          //                 'ccvNumber -> $ccvNumber');
                                                          //           },
                                                          //         ));
                                                        },
                                                      ));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (c) =>
                                                      OfferConfirmationDialog(
                                                        isOffer: true,
                                                        onOkPressed: () {
                                                          Navigator.pop(c);
                                                        },
                                                        isDone: false,
                                                      ));
                                            }
                                          }
                                        },
                                        shipmentNotification:
                                            ShipmentNotification(
                                          shipmentId: widget.bulkShipment.id,
                                          shippingCost: widget
                                              .bulkShipment.expectedShippingCost
                                              .toString(),
                                          totalShipmentCost:
                                              widget.bulkShipment.amount,
                                          merchantImage: widget
                                              .bulkShipment.merchant!.photo,
                                          merchantName: widget
                                              .bulkShipment.merchant!.name,
                                          flags: widget.bulkShipment.flags,
                                          childrenShipment: widget
                                              .bulkShipment.children!.length,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      weevoPrimaryOrangeColor,
                                    ),
                                    padding:
                                        WidgetStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.symmetric(
                                        vertical: 6.0,
                                        horizontal: 20.0,
                                      ),
                                    ),
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'توصيل الأوردر',
                                    style: TextStyle(
                                      fontSize: 16.0.sp,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ]),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.bulkShipment.products![0]
                                              .productInfo!.name!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          widget.bulkShipment.products![0]
                                                  .productInfo!.description ??
                                              '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.bulkShipment.paymentMethod == 'cod'
                                      ? Image.asset(
                                          'assets/images/shipment_cod_icon.png',
                                          height: 35.0.h,
                                          width: 35.0.h)
                                      : Image.asset(
                                          'assets/images/shipment_online_icon.png',
                                          height: 35.0.h,
                                          width: 35.0.h)
                                ],
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: weevoPrimaryOrangeColor,
                                    ),
                                    height: 8.h,
                                    width: 8.w,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${widget.bulkShipment.receivingStateModel!.name} - ${widget.bulkShipment.receivingCityModel!.name}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.0.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2.5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: List.generate(
                                    3,
                                    (index) => Container(
                                      margin: const EdgeInsets.only(top: 1),
                                      height: 3,
                                      width: 3,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(1.5),
                                        color: index < 3
                                            ? weevoPrimaryOrangeColor
                                            : weevoPrimaryBlueColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: weevoPrimaryBlueColor,
                                    ),
                                    height: 8.h,
                                    width: 8.w,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${widget.bulkShipment.deliveringStateModel!.name} - ${widget.bulkShipment.deliveringCityModel!.name}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.0.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              if (widget.bulkShipment
                                      .distanceFromLocationPickup !=
                                  null)
                                Row(
                                  children: [
                                    Text(
                                      'تبعد عنك',
                                      style: TextStyle(
                                          fontSize: 13.0.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${widget.bulkShipment.distanceFromLocationPickup} KM',
                                        style: TextStyle(
                                            fontSize: 13.0.sp,
                                            color: weevoPrimaryOrangeColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              if (widget.bulkShipment
                                      .distanceFromLocationPickup !=
                                  null)
                                SizedBox(
                                  height: 6.h,
                                ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xffD8F3FF),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/money_icon.png',
                                            fit: BoxFit.contain,
                                            color: const Color(0xff091147),
                                            height: 20.h,
                                            width: 20.w,
                                          ),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Text(
                                            '${double.parse(widget.bulkShipment.amount!).toInt()}',
                                            style: TextStyle(
                                              fontSize: 11.0.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Text(
                                            'جنية',
                                            style: TextStyle(
                                              fontSize: 10.0.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          if (Preferences
                                                  .instance.getUserFlags ==
                                              'freelance') ...[
                                            Image.asset(
                                              'assets/images/van_icon.png',
                                              fit: BoxFit.contain,
                                              color: const Color(0xff091147),
                                              height: 20.h,
                                              width: 20.w,
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Text(
                                              '${double.parse(widget.bulkShipment.agreedShippingCostAfterDiscount ?? widget.bulkShipment.agreedShippingCost ?? widget.bulkShipment.expectedShippingCost ?? '0').toInt()}',
                                              style: TextStyle(
                                                fontSize: 11.0.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                              'جنية',
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
    log('${walletProvider.meezaCard!.transaction!.id!}');
    Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      log('t');
      await walletProvider.checkPaymentStatus(
          systemReferenceNumber: value,
          transactionId: walletProvider.meezaCard!.transaction!.id!);
      if (walletProvider.state == NetworkState.success) {
        log('success');
        if (walletProvider.creditStatus?.status == 'completed') {
          log('status compeleted');
          if (t.isActive) {
            t.cancel();
            log('timer cancelled');
          }
          log('${walletProvider.creditStatus?.status}');
          Navigator.pop(navigator.currentContext!);
          showDialog(
              context: navigator.currentContext!,
              barrierDismissible: false,
              builder: (context) => ContentDialog(
                    content:
                        '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider.meezaCard?.transaction?.amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
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
