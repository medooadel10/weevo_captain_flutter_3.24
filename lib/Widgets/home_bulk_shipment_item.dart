// import 'dart:async';
// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// import '../Dialogs/apply_confirmation_dialog.dart';
// import '../Dialogs/content_dialog.dart';
// import '../Dialogs/deliver_shipment_dialog.dart';
// import '../Dialogs/no_credit_dialog.dart';
// import '../Models/bulk_shipment.dart';
// import '../Models/shipment_tracking_model.dart';
// import '../Providers/auth_provider.dart';
// import '../Providers/shipment_provider.dart';
// import '../Providers/wallet_provider.dart';
// import '../Screens/wallet.dart';
// import '../Utilits/colors.dart';
// import '../Utilits/constants.dart';
// // import '../core/widgets/custom_image.dart';
// import 'slide_dotes.dart';

// class HomeBulkShipmentItem extends StatefulWidget {
//   final BulkShipment bulkShipment;
//   final VoidCallback onItemPressed;

//   const HomeBulkShipmentItem({
//     super.key,
//     required this.bulkShipment,
//     required this.onItemPressed,
//   });

//   @override
//   State<HomeBulkShipmentItem> createState() => _HomeBulkShipmentItemState();
// }

// class _HomeBulkShipmentItemState extends State<HomeBulkShipmentItem> {
//   int _currentIndex = 0;
//   late PageController _pageController;
//   Timer? t;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(
//       initialPage: 0,
//     );
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final shipmentProvider = Provider.of<ShipmentProvider>(context);
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final walletProvider = Provider.of<WalletProvider>(context);
//     final size = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: widget.onItemPressed,
//       child: widget.bulkShipment.children!.isNotEmpty
//           ? Container(
//               margin: const EdgeInsets.all(6.0),
//               height: 170.h,
//               child: PageView.builder(
//                 onPageChanged: (int i) {
//                   setState(() {
//                     _currentIndex = i;
//                   });
//                 },
//                 scrollDirection: Axis.horizontal,
//                 controller: _pageController,
//                 itemCount: widget.bulkShipment.children!.length,
//                 itemBuilder: (context, i) => Stack(
//                   children: [
//                     Row(
//                       children: [
//                         SizedBox(
//                           height: 150.0.h,
//                           width: 150.0.h,
//                           child: Stack(
//                             alignment: Alignment.bottomCenter,
//                             children: [
//                               Stack(
//                                 alignment: Alignment.topRight,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 5.5),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(12),
//                                       child: CustomImage(
//                                         image: widget.bulkShipment.children![i]
//                                             .products![0].productInfo!.image!,
//                                         height: 150.0.h,
//                                         width: 150.0.h,
//                                         radius: 0,
//                                       ),
//                                     ),
//                                   ),
//                                   widget.bulkShipment.children!.length > 1
//                                       ? Container(
//                                           padding: const EdgeInsets.all(6.0),
//                                           height: 40.h,
//                                           margin:
//                                               const EdgeInsets.only(top: 20.0),
//                                           decoration: const BoxDecoration(
//                                             image: DecorationImage(
//                                                 image: AssetImage(
//                                                   'assets/images/clip_path_background.png',
//                                                 ),
//                                                 fit: BoxFit.fill),
//                                           ),
//                                           child: Text(
//                                             '${widget.bulkShipment.children!.length} طلب',
//                                             textDirection: TextDirection.rtl,
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14.0.sp,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         )
//                                       : Container(),
//                                 ],
//                               ),
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   // if (DateTime.now().hour >= 10 &&
//                                   //     DateTime.now().hour <= 22) {
//                                   showDialog(
//                                       context: context,
//                                       barrierDismissible: false,
//                                       builder:
//                                           (context) => DeliverShipmentDialog(
//                                                 onOkPressed: (String v) {
//                                                   if (v == 'DONE') {
//                                                     showDialog(
//                                                         context: context,
//                                                         builder: (c) =>
//                                                             ApplyConfirmationDialog(
//                                                               onOkPressed:
//                                                                   () async {
//                                                                 Navigator.pop(
//                                                                     c);
//                                                                 await shipmentProvider.getAvailableShipment(
//                                                                     isPagination:
//                                                                         false,
//                                                                     isRefreshing:
//                                                                         false,
//                                                                     isFirstTime:
//                                                                         false);
//                                                                 DocumentSnapshot
//                                                                     userToken =
//                                                                     await FirebaseFirestore
//                                                                         .instance
//                                                                         .collection(
//                                                                             'merchant_users')
//                                                                         .doc(widget
//                                                                             .bulkShipment
//                                                                             .merchantId
//                                                                             .toString())
//                                                                         .get();
//                                                                 String token =
//                                                                     userToken[
//                                                                         'fcmToken'];
//                                                                 FirebaseFirestore
//                                                                     .instance
//                                                                     .collection(
//                                                                         'merchant_notifications')
//                                                                     .doc(widget
//                                                                         .bulkShipment
//                                                                         .merchantId
//                                                                         .toString())
//                                                                     .collection(widget
//                                                                         .bulkShipment
//                                                                         .merchantId
//                                                                         .toString())
//                                                                     .add({
//                                                                   'read': false,
//                                                                   'date_time': DateTime
//                                                                           .now()
//                                                                       .toIso8601String(),
//                                                                   'type':
//                                                                       'cancel_shipment',
//                                                                   'title':
//                                                                       'ويفو وفرلك كابتن',
//                                                                   'body':
//                                                                       'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالطلب',
//                                                                   'user_icon': authProvider
//                                                                           .photo
//                                                                           .isNotEmpty
//                                                                       ? authProvider
//                                                                               .photo
//                                                                               .contains(base_url)
//                                                                           ? authProvider.photo
//                                                                           : '$base_url${authProvider.photo}'
//                                                                       : '',
//                                                                   'screen_to':
//                                                                       'shipment_screen',
//                                                                   'data': ShipmentTrackingModel(
//                                                                           shipmentId: widget
//                                                                               .bulkShipment
//                                                                               .id,
//                                                                           hasChildren:
//                                                                               1)
//                                                                       .toJson(),
//                                                                 });
//                                                                 await authProvider.sendNotification(
//                                                                     title: 'ويفو وفرلك كابتن',
//                                                                     body: 'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالطلب',
//                                                                     toToken: token,
//                                                                     image: authProvider.photo.isNotEmpty
//                                                                         ? authProvider.photo.contains(base_url)
//                                                                             ? authProvider.photo
//                                                                             : '$base_url${authProvider.photo}'
//                                                                         : '',
//                                                                     data: ShipmentTrackingModel(shipmentId: widget.bulkShipment.id, hasChildren: 1).toJson(),
//                                                                     screenTo: 'shipment_screen',
//                                                                     type: 'cancel_shipment');
//                                                               },
//                                                               isDone: true,
//                                                             ));
//                                                   } else {
//                                                     if (shipmentProvider
//                                                         .noCredit) {
//                                                       showDialog(
//                                                           context: context,
//                                                           builder: (c) =>
//                                                               NoCreditDialog(
//                                                                 onOkCancelCallback:
//                                                                     () {
//                                                                   Navigator.pop(
//                                                                       c);
//                                                                 },
//                                                                 onChargeWalletCallback:
//                                                                     () {
//                                                                   Navigator.pop(
//                                                                       c);
//                                                                   walletProvider
//                                                                       .setMainIndex(
//                                                                           1);
//                                                                   walletProvider.setDepositAmount(num.parse(widget
//                                                                           .bulkShipment
//                                                                           .amount)
//                                                                       .toInt());
//                                                                   walletProvider
//                                                                       .setDepositIndex(
//                                                                           1);
//                                                                   walletProvider
//                                                                           .fromOfferPage =
//                                                                       true;
//                                                                   Navigator
//                                                                       .pushReplacementNamed(
//                                                                           c,
//                                                                           Wallet
//                                                                               .id);

//                                                                   // Navigator.pop(
//                                                                   //     c);
//                                                                   // showDialog(
//                                                                   //     context: Preferences
//                                                                   //         .instance
//                                                                   //         .navigator
//                                                                   //         .currentContext,
//                                                                   //     barrierDismissible: false,
//                                                                   //
//                                                                   //     builder:
//                                                                   //         (ctx) =>
//                                                                   //             ChargeWalletDialog(
//                                                                   //               shipmentAmount: num.parse(widget.bulkShipment.amount).toInt(),
//                                                                   //               onSubmit: (
//                                                                   //                 String type,
//                                                                   //                 String value,
//                                                                   //                 String cardNumber,
//                                                                   //                 String walletNumber,
//                                                                   //                 String dateYear,
//                                                                   //                 String dateMonth,
//                                                                   //                 String ccvNumber,
//                                                                   //               ) async {
//                                                                   //                 if (type == 'meeza-card') {
//                                                                   //                   Navigator.pop(ctx);
//                                                                   //                   showDialog(context: Preferences.instance.navigator.currentContext, barrierDismissible: false, builder: (context) => Loading());
//                                                                   //                   await walletProvider.addCreditWithMeeza(
//                                                                   //                     amount: num.parse(value).toDouble(),
//                                                                   //                     method: 'meeza-card',
//                                                                   //                     pan: cardNumber.split('-').join(),
//                                                                   //                     expirationDate: '$dateYear$dateMonth',
//                                                                   //                     cvv: ccvNumber,
//                                                                   //                   );
//                                                                   //                   if (walletProvider.state == NetworkState.SUCCESS) {
//                                                                   //                     if (walletProvider.meezaCard.upgResponse != null) {
//                                                                   //                       Navigator.pop(Preferences.instance.navigator.currentContext);
//                                                                   //                       dynamic value = await Navigator.pushNamed(Preferences.instance.navigator.currentContext, TransactionWebView.id,
//                                                                   //                           arguments: TransactionWebViewModel(
//                                                                   //                               url: walletProvider.meezaCard.upgResponse.threeDSUrl,
//                                                                   //                               selectedValue: walletProvider.item.gateway == 'credit-card'
//                                                                   //                                   ? 0
//                                                                   //                                   : walletProvider.item.gateway == 'meeza-card'
//                                                                   //                                       ? 1
//                                                                   //                                       : 2));
//                                                                   //                       if (value != null) {
//                                                                   //                         if (value == 'no funds') {
//                                                                   //                           showDialog(
//                                                                   //                               context: Preferences
//                                                                   //                                   .instance
//                                                                   //                                   .navigator
//                                                                   //                                   .currentContext,
//                                                                   //                               builder:
//                                                                   //                                   (c) =>
//                                                                   //                                   NoCreditInWalletDialog(
//                                                                   //                                     onPressedCallback: () {
//                                                                   //                                       Navigator.pop(c);
//                                                                   //                                     },
//                                                                   //                                   ));
//                                                                   //                         } else {
//                                                                   //                           showDialog(context: Preferences.instance.navigator.currentContext, barrierDismissible: false, builder: (context) => Loading());
//                                                                   //                           await getMezaStatus(walletProvider: walletProvider, authProvider: authProvider, value: value);
//                                                                   //                         }
//                                                                   //                       }
//                                                                   //                     } else {
//                                                                   //                       if (walletProvider.meezaCard.status == 'completed') {
//                                                                   //                         log('status compeleted');
//                                                                   //                         log('${walletProvider.meezaCard.status}');
//                                                                   //                         await walletProvider.getCurrentBalance(authorization: authProvider.appAuthorization, fromRefresh: false);
//                                                                   //                         Navigator.pop(Preferences.instance.navigator.currentContext);
//                                                                   //                         showDialog(
//                                                                   //                             context: Preferences.instance.navigator.currentContext,
//                                                                   //                             barrierDismissible: false,
//                                                                   //                             builder: (context) => ContentDialog(
//                                                                   //                                   content: 'تم إيداع المبلغ بنجاح',
//                                                                   //                                   callback: () {
//                                                                   //                                     Navigator.pop(Preferences.instance.navigator.currentContext);
//                                                                   //                                     walletProvider.setDepositIndex(5);
//                                                                   //                                     walletProvider.setAccountTypeIndex(null);
//                                                                   //                                   },
//                                                                   //                                 ));
//                                                                   //                       }
//                                                                   //                     }
//                                                                   //                   } else if (walletProvider.state == NetworkState.ERROR) {
//                                                                   //                     Navigator.pop(Preferences.instance.navigator.currentContext);
//                                                                   //                     showDialog(
//                                                                   //                       context: Preferences.instance.navigator.currentContext,
//                                                                   //                       builder: (context) => WalletDialog(
//                                                                   //                         msg: 'برجاء محاولة الأيداع مرة اخري',
//                                                                   //                         onPress: () {
//                                                                   //                           Navigator.pop(Preferences.instance.navigator.currentContext);
//                                                                   //                         },
//                                                                   //                       ),
//                                                                   //                     );
//                                                                   //                   }
//                                                                   //                 } else {
//                                                                   //                   showDialog(
//                                                                   //                       context: Preferences.instance.navigator.currentContext,
//                                                                   //                       barrierDismissible: false,
//                                                                   //                       builder: (context) => MsgDialog(
//                                                                   //                             content: 'سيصلك اشعار على رقم موبايلك المسجل على محفظتك الإلكترونية لأستكمال العملية',
//                                                                   //                           ));
//                                                                   //                   await walletProvider.addCreditWithEWallet(
//                                                                   //                     amount: num.parse(value).toDouble(),
//                                                                   //                     method: 'e-wallet',
//                                                                   //                     mobileNumber: walletNumber,
//                                                                   //                   );
//                                                                   //                   if (walletProvider.state == NetworkState.SUCCESS) {
//                                                                   //                     t = Timer.periodic(Duration(seconds: 5), (timer) async {
//                                                                   //                       await walletProvider.checkPaymentStatus(systemReferenceNumber: walletProvider.eWallet.transaction.details.upgSystemRef, transactionId: walletProvider.eWallet.transaction.details.transactionId);
//                                                                   //                       if (walletProvider.state == NetworkState.SUCCESS) {
//                                                                   //                         if (walletProvider.creditStatus.status == 'completed') {
//                                                                   //                           if (t.isActive) {
//                                                                   //                             t.cancel();
//                                                                   //                             t = null;
//                                                                   //                           }
//                                                                   //                           await walletProvider.getCurrentBalance(authorization: authProvider.appAuthorization, fromRefresh: false);
//                                                                   //                           Navigator.pop(Preferences.instance.navigator.currentContext);
//                                                                   //                           walletProvider.setDepositIndex(5);
//                                                                   //                           walletProvider.setAccountTypeIndex(null);
//                                                                   //                         }
//                                                                   //                       }
//                                                                   //                     });
//                                                                   //                   } else if (walletProvider.state == NetworkState.ERROR) {
//                                                                   //                     Navigator.pop(Preferences.instance.navigator.currentContext);
//                                                                   //                     showDialog(
//                                                                   //                       context: Preferences.instance.navigator.currentContext,
//                                                                   //                       builder: (context) => WalletDialog(
//                                                                   //                         msg: 'حدث خطأ برحاء المحاولة مرة اخري',
//                                                                   //                         onPress: () {
//                                                                   //                           Navigator.pop(Preferences.instance.navigator.currentContext);
//                                                                   //                         },
//                                                                   //                       ),
//                                                                   //                     );
//                                                                   //                   }
//                                                                   //                 }
//                                                                   //                 log('type -> $type');
//                                                                   //                 log('value -> $value');
//                                                                   //                 log('cardNumber -> $cardNumber');
//                                                                   //                 log('walletNumber -> $walletNumber');
//                                                                   //                 log('dateYear -> $dateYear');
//                                                                   //                 log('dateMonth -> $dateMonth');
//                                                                   //                 log('ccvNumber -> $ccvNumber');
//                                                                   //               },
//                                                                   //             ));
//                                                                 },
//                                                               ));
//                                                     } else {
//                                                       showDialog(
//                                                           context: context,
//                                                           builder: (c) =>
//                                                               ApplyConfirmationDialog(
//                                                                 onOkPressed:
//                                                                     () async {
//                                                                   Navigator.pop(
//                                                                       c);
//                                                                 },
//                                                                 isDone: false,
//                                                               ));
//                                                     }
//                                                   }
//                                                 },
//                                                 shipmentId:
//                                                     widget.bulkShipment.id,
//                                                 amount: widget
//                                                     .bulkShipment.amount
//                                                     .toString(),
//                                                 shippingCost: widget
//                                                     .bulkShipment
//                                                     .expectedShippingCost
//                                                     .toString(),
//                                               ));
//                                   // } else {
//                                   //   showDialog(
//                                   //       context: context,
//                                   //       builder: (cx) => ActionDialog(
//                                   //             content:
//                                   //                 'يمكنك التقديم علي الطلبات من ١٠ صباحاً حتي ١٠ مساءاً',
//                                   //             onApproveClick: () {
//                                   //               Navigator.pop(cx);
//                                   //             },
//                                   //             approveAction: 'حسناً',
//                                   //           ));
//                                   // }
//                                 },
//                                 style: ButtonStyle(
//                                   shape: WidgetStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(
//                                         20.0,
//                                       ),
//                                     ),
//                                   ),
//                                   padding: WidgetStateProperty.all<EdgeInsets>(
//                                     const EdgeInsets.symmetric(
//                                       vertical: 6.0,
//                                       horizontal: 20.0,
//                                     ),
//                                   ),
//                                   backgroundColor:
//                                       WidgetStateProperty.all<Color>(
//                                           weevoPrimaryOrangeColor),
//                                 ),
//                                 child: const Text(
//                                   'وصل الأوردر',
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       widget.bulkShipment.children[i]
//                                           .products[0].productInfo.name,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       textDirection: TextDirection.rtl,
//                                       style: TextStyle(
//                                         fontSize: 17.sp,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     Text(
//                                       widget.bulkShipment.children[i]
//                                           .products[0].productInfo.description,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       textDirection: TextDirection.rtl,
//                                       style: TextStyle(
//                                         fontSize: 12.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 6.h,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Container(
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: weevoPrimaryOrangeColor,
//                                       ),
//                                       height: 8.h,
//                                       width: 8.w,
//                                     ),
//                                     SizedBox(
//                                       width: 5.w,
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         '${authProvider.getStateNameById(int.parse(widget.bulkShipment.children[i].deliveringState))} - ${authProvider.getCityNameById(int.parse(widget.bulkShipment.children[i].deliveringState), int.parse(widget.bulkShipment.children[i].deliveringCity))}',
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                         style: TextStyle(
//                                           fontSize: 16.0.sp,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 2.5),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: List.generate(
//                                       3,
//                                       (index) => Container(
//                                         margin: const EdgeInsets.only(top: 1),
//                                         height: 3,
//                                         width: 3,
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(1.5),
//                                           color: index < 3
//                                               ? weevoPrimaryOrangeColor
//                                               : weevoPrimaryBlueColor,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Container(
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: weevoPrimaryBlueColor,
//                                       ),
//                                       height: 8.h,
//                                       width: 8.w,
//                                     ),
//                                     SizedBox(
//                                       width: 5.w,
//                                     ),
//                                     Expanded(
//                                       child: Text(
//                                         '${authProvider.getStateNameById(int.parse(widget.bulkShipment.children[i].receivingState))} - ${authProvider.getCityNameById(int.parse(widget.bulkShipment.children[i].receivingState), int.parse(widget.bulkShipment.children[i].receivingCity))}',
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                         style: TextStyle(
//                                           fontSize: 16.0.sp,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 6.h,
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.all(8.0),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                     color: const Color(0xffD8F3FF),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Expanded(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Image.asset(
//                                               'assets/images/money_icon.png',
//                                               fit: BoxFit.contain,
//                                               color: const Color(0xff091147),
//                                               height: 20.h,
//                                               width: 20.w,
//                                             ),
//                                             SizedBox(
//                                               width: 5.w,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   '${double.parse(widget.bulkShipment.children[i].amount).toInt()}',
//                                                   style: TextStyle(
//                                                     fontSize: 12.0.sp,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 2.w,
//                                                 ),
//                                                 Text(
//                                                   'جنية',
//                                                   style: TextStyle(
//                                                     fontSize: 10.0.sp,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Image.asset(
//                                               'assets/images/van_icon.png',
//                                               fit: BoxFit.contain,
//                                               color: const Color(0xff091147),
//                                               height: 20.h,
//                                               width: 20.w,
//                                             ),
//                                             SizedBox(
//                                               width: 5.w,
//                                             ),
//                                             Expanded(
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     '${double.parse(widget.bulkShipment.children[i].agreedShippingCost ?? widget.bulkShipment.children[i].shippingCost).toInt()}',
//                                                     style: TextStyle(
//                                                       fontSize: 12.0.sp,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 5.w,
//                                                   ),
//                                                   Text(
//                                                     'جنية',
//                                                     style: TextStyle(
//                                                       fontSize: 10.0.sp,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     widget.bulkShipment.children.length > 1
//                         ? Positioned(
//                             top: size.height * 0.21,
//                             right: size.width * 0.42,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: Colors.white,
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8.0,
//                                 vertical: 4.0,
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: List.generate(
//                                   widget.bulkShipment.children.length,
//                                   (index) => _currentIndex == index
//                                       ? CategoryDotes(
//                                           isActive: true,
//                                           isPlus: true,
//                                         )
//                                       : CategoryDotes(
//                                           isActive: false,
//                                           isPlus: true,
//                                         ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         : Container(),
//                   ],
//                 ),
//               ),
//             )
//           : Container(
//               margin: const EdgeInsets.only(bottom: 6.0),
//               padding: const EdgeInsets.all(6.0),
//               child: Row(
//                 children: [
//                   Stack(alignment: Alignment.bottomCenter, children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(30),
//                       child: FancyShimmerImage(
//                         imageUrl:
//                             widget.bulkShipment.products[0].productInfo.image,
//                         boxFit: BoxFit.cover,
//                         errorWidget:
//                             Image.asset('assets/images/profile_picture.png'),
//                         height: 150.0.h,
//                         width: 150.0.h,
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         // if (DateTime.now().hour >= 10 &&
//                         //     DateTime.now().hour <= 22) {
//                         showDialog(
//                             context: context,
//                             barrierDismissible: false,
//                             builder: (context) => DeliverShipmentDialog(
//                                   onOkPressed: (String v) {
//                                     if (v == 'DONE') {
//                                       showDialog(
//                                           context: context,
//                                           builder: (c) =>
//                                               ApplyConfirmationDialog(
//                                                 onOkPressed: () async {
//                                                   Navigator.pop(c);
//                                                   await shipmentProvider
//                                                       .getAvailableShipment(
//                                                           isPagination: false,
//                                                           isRefreshing: false,
//                                                           isFirstTime: false);
//                                                   DocumentSnapshot userToken =
//                                                       await FirebaseFirestore
//                                                           .instance
//                                                           .collection(
//                                                               'merchant_users')
//                                                           .doc(widget
//                                                               .bulkShipment
//                                                               .merchantId
//                                                               .toString())
//                                                           .get();
//                                                   String token =
//                                                       userToken['fcmToken'];
//                                                   FirebaseFirestore.instance
//                                                       .collection(
//                                                           'merchant_notifications')
//                                                       .doc(widget.bulkShipment
//                                                           .merchantId
//                                                           .toString())
//                                                       .collection(widget
//                                                           .bulkShipment
//                                                           .merchantId
//                                                           .toString())
//                                                       .add({
//                                                     'read': false,
//                                                     'date_time': DateTime.now()
//                                                         .toIso8601String(),
//                                                     'type': 'cancel_shipment',
//                                                     'title': 'ويفو وفرلك كابتن',
//                                                     'body':
//                                                         'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالطلب',
//                                                     'user_icon': authProvider
//                                                             .photo.isNotEmpty
//                                                         ? authProvider.photo
//                                                                 .contains(
//                                                                     base_url)
//                                                             ? authProvider.photo
//                                                             : '$base_url${authProvider.photo}'
//                                                         : '',
//                                                     'screen_to':
//                                                         'shipment_screen',
//                                                     'data': ShipmentTrackingModel(
//                                                             shipmentId: widget
//                                                                 .bulkShipment
//                                                                 .id,
//                                                             hasChildren: 0)
//                                                         .toJson(),
//                                                   });
//                                                   await authProvider
//                                                       .sendNotification(
//                                                           title:
//                                                               'ويفو وفرلك كابتن',
//                                                           body:
//                                                               'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدمالطلب',
//                                                           toToken: token,
//                                                           image: authProvider
//                                                                   .photo
//                                                                   .isNotEmpty
//                                                               ? authProvider
//                                                                       .photo
//                                                                       .contains(
//                                                                           base_url)
//                                                                   ? authProvider
//                                                                       .photo
//                                                                   : '$base_url${authProvider.photo}'
//                                                               : '',
//                                                           data: ShipmentTrackingModel(
//                                                                   shipmentId: widget
//                                                                       .bulkShipment
//                                                                       .id,
//                                                                   hasChildren:
//                                                                       0)
//                                                               .toJson(),
//                                                           screenTo:
//                                                               'shipment_screen',
//                                                           type:
//                                                               'cancel_shipment');
//                                                 },
//                                                 isDone: true,
//                                               ));
//                                     } else {
//                                       if (shipmentProvider.noCredit) {
//                                         showDialog(
//                                             context: context,
//                                             builder: (c) => NoCreditDialog(
//                                                   onOkCancelCallback: () {
//                                                     Navigator.pop(c);
//                                                   },
//                                                   onChargeWalletCallback: () {
//                                                     Navigator.pop(c);
//                                                     walletProvider
//                                                         .setMainIndex(1);
//                                                     walletProvider
//                                                         .setDepositAmount(
//                                                             num.parse(widget
//                                                                     .bulkShipment
//                                                                     .amount)
//                                                                 .toInt());
//                                                     walletProvider
//                                                         .setDepositIndex(1);
//                                                     walletProvider
//                                                         .fromOfferPage = true;
//                                                     Navigator
//                                                         .pushReplacementNamed(
//                                                             c, Wallet.id);

//                                                     // Navigator.pop(c);
//                                                     // showDialog(
//                                                     //     context: Preferences
//                                                     //         .instance
//                                                     //         .navigator
//                                                     //         .currentContext,
//                                                     //     barrierDismissible: false,
//                                                     //
//                                                     //     builder: (ctx) =>
//                                                     //         ChargeWalletDialog(
//                                                     //           shipmentAmount:
//                                                     //               num.parse(widget
//                                                     //                       .bulkShipment
//                                                     //                       .amount)
//                                                     //                   .toInt(),
//                                                     //           onSubmit: (
//                                                     //             String type,
//                                                     //             String value,
//                                                     //             String
//                                                     //                 cardNumber,
//                                                     //             String
//                                                     //                 walletNumber,
//                                                     //             String dateYear,
//                                                     //             String
//                                                     //                 dateMonth,
//                                                     //             String
//                                                     //                 ccvNumber,
//                                                     //           ) async {
//                                                     //             if (type ==
//                                                     //                 'meeza-card') {
//                                                     //               Navigator.pop(
//                                                     //                   Preferences.instance.navigator.currentContext);
//                                                     //               showDialog(
//                                                     //                   context: Preferences
//                                                     //                       .instance
//                                                     //                       .navigator
//                                                     //                       .currentContext,
//                                                     //                   barrierDismissible:
//                                                     //                       false,
//                                                     //                   builder:
//                                                     //                       (context) =>
//                                                     //                           Loading());
//                                                     //               await walletProvider
//                                                     //                   .addCreditWithMeeza(
//                                                     //                 amount: num.parse(
//                                                     //                         value)
//                                                     //                     .toDouble(),
//                                                     //                 method:
//                                                     //                     'meeza-card',
//                                                     //                 pan: cardNumber
//                                                     //                     .split(
//                                                     //                         '-')
//                                                     //                     .join(),
//                                                     //                 expirationDate:
//                                                     //                     '$dateYear$dateMonth',
//                                                     //                 cvv:
//                                                     //                     ccvNumber,
//                                                     //               );
//                                                     //               if (walletProvider
//                                                     //                       .state ==
//                                                     //                   NetworkState
//                                                     //                       .SUCCESS) {
//                                                     //                 if (walletProvider
//                                                     //                         .meezaCard
//                                                     //                         .upgResponse !=
//                                                     //                     null) {
//                                                     //                   Navigator.pop(
//                                                     //                       Preferences.instance.navigator.currentContext);
//                                                     //                   dynamic value = await Navigator.pushNamed(
//                                                     //                       Preferences.instance.navigator.currentContext,
//                                                     //                       TransactionWebView
//                                                     //                           .id,
//                                                     //                       arguments: TransactionWebViewModel(
//                                                     //                           url: walletProvider.meezaCard.upgResponse.threeDSUrl,
//                                                     //                           selectedValue: walletProvider.item.gateway == 'credit-card'
//                                                     //                               ? 0
//                                                     //                               : walletProvider.item.gateway == 'meeza-card'
//                                                     //                                   ? 1
//                                                     //                                   : 2));
//                                                     //                   if (value !=
//                                                     //                       null) {
//                                                     //                     if (value ==
//                                                     //                         'no funds') {
//                                                     //                       showDialog(
//                                                     //                           context: Preferences
//                                                     //                               .instance
//                                                     //                               .navigator
//                                                     //                               .currentContext,
//                                                     //                           builder:
//                                                     //                               (c) =>
//                                                     //                               NoCreditInWalletDialog(
//                                                     //                                 onPressedCallback: () {
//                                                     //                                   Navigator.pop(c);
//                                                     //                                 },
//                                                     //                               ));
//                                                     //                     } else {
//                                                     //                       showDialog(
//                                                     //                           context: Preferences.instance.navigator.currentContext,
//                                                     //                           barrierDismissible: false,
//                                                     //                           builder: (context) => Loading());
//                                                     //                       await getMezaStatus(
//                                                     //                           walletProvider: walletProvider,
//                                                     //                           authProvider: authProvider,
//                                                     //                           value: value);
//                                                     //                     }
//                                                     //                   }
//                                                     //                 } else {
//                                                     //                   if (walletProvider
//                                                     //                           .meezaCard
//                                                     //                           .status ==
//                                                     //                       'completed') {
//                                                     //                     log('status compeleted');
//                                                     //                     log('${walletProvider.meezaCard.status}');
//                                                     //                     await walletProvider.getCurrentBalance(
//                                                     //                         authorization:
//                                                     //                             authProvider.appAuthorization,
//                                                     //                         fromRefresh: false);
//                                                     //                     Navigator.pop(
//                                                     //                         Preferences.instance.navigator.currentContext);
//                                                     //                     showDialog(
//                                                     //                         context:
//                                                     //                         Preferences.instance.navigator.currentContext,
//                                                     //                         barrierDismissible:
//                                                     //                             false,
//                                                     //                         builder: (context) =>
//                                                     //                             ContentDialog(
//                                                     //                               content: 'تم إيداع المبلغ بنجاح',
//                                                     //                               callback: () {
//                                                     //                                 Navigator.pop(Preferences.instance.navigator.currentContext);
//                                                     //                                 walletProvider.setDepositIndex(5);
//                                                     //                                 walletProvider.setAccountTypeIndex(null);
//                                                     //                               },
//                                                     //                             ));
//                                                     //                   }
//                                                     //                 }
//                                                     //               } else if (walletProvider
//                                                     //                       .state ==
//                                                     //                   NetworkState
//                                                     //                       .ERROR) {
//                                                     //                 Navigator.pop(
//                                                     //                     Preferences.instance.navigator.currentContext);
//                                                     //                 showDialog(
//                                                     //                   context:
//                                                     //                   Preferences.instance.navigator.currentContext,
//                                                     //                   builder:
//                                                     //                       (context) =>
//                                                     //                           WalletDialog(
//                                                     //                     msg:
//                                                     //                         'برجاء محاولة الأيداع مرة اخري',
//                                                     //                     onPress:
//                                                     //                         () {
//                                                     //                       Navigator.pop(
//                                                     //                           Preferences.instance.navigator.currentContext);
//                                                     //                     },
//                                                     //                   ),
//                                                     //                 );
//                                                     //               }
//                                                     //             } else {
//                                                     //               showDialog(
//                                                     //                   context: Preferences
//                                                     //                       .instance
//                                                     //                       .navigator
//                                                     //                       .currentContext,
//                                                     //                   barrierDismissible:
//                                                     //                       false,
//                                                     //                   builder:
//                                                     //                       (context) =>
//                                                     //                           MsgDialog(
//                                                     //                             content: 'سيصلك اشعار على رقم موبايلك المسجل على محفظتك الإلكترونية لأستكمال العملية',
//                                                     //                           ));
//                                                     //               await walletProvider
//                                                     //                   .addCreditWithEWallet(
//                                                     //                 amount: num.parse(
//                                                     //                         value)
//                                                     //                     .toDouble(),
//                                                     //                 method:
//                                                     //                     'e-wallet',
//                                                     //                 mobileNumber:
//                                                     //                     walletNumber,
//                                                     //               );
//                                                     //               if (walletProvider
//                                                     //                       .state ==
//                                                     //                   NetworkState
//                                                     //                       .SUCCESS) {
//                                                     //                 t = Timer.periodic(
//                                                     //                     Duration(
//                                                     //                         seconds:
//                                                     //                             5),
//                                                     //                     (timer) async {
//                                                     //                   await walletProvider.checkPaymentStatus(
//                                                     //                       systemReferenceNumber: walletProvider
//                                                     //                           .eWallet
//                                                     //                           .transaction
//                                                     //                           .details
//                                                     //                           .upgSystemRef,
//                                                     //                       transactionId: walletProvider
//                                                     //                           .eWallet
//                                                     //                           .transaction
//                                                     //                           .details
//                                                     //                           .transactionId);
//                                                     //                   if (walletProvider
//                                                     //                           .state ==
//                                                     //                       NetworkState
//                                                     //                           .SUCCESS) {
//                                                     //                     if (walletProvider.creditStatus.status ==
//                                                     //                         'completed') {
//                                                     //                       if (t
//                                                     //                           .isActive) {
//                                                     //                         t.cancel();
//                                                     //                         t = null;
//                                                     //                       }
//                                                     //                       await walletProvider.getCurrentBalance(
//                                                     //                           authorization: authProvider.appAuthorization,
//                                                     //                           fromRefresh: false);
//                                                     //                       Navigator.pop(
//                                                     //                           context);
//                                                     //                       walletProvider
//                                                     //                           .setDepositIndex(5);
//                                                     //                       walletProvider
//                                                     //                           .setAccountTypeIndex(null);
//                                                     //                     }
//                                                     //                   }
//                                                     //                 });
//                                                     //               } else if (walletProvider
//                                                     //                       .state ==
//                                                     //                   NetworkState
//                                                     //                       .ERROR) {
//                                                     //                 Navigator.pop(
//                                                     //                     Preferences.instance.navigator.currentContext);
//                                                     //                 showDialog(
//                                                     //                   context:
//                                                     //                   Preferences.instance.navigator.currentContext,
//                                                     //                   builder:
//                                                     //                       (context) =>
//                                                     //                           WalletDialog(
//                                                     //                     msg:
//                                                     //                         'حدث خطأ برحاء المحاولة مرة اخري',
//                                                     //                     onPress:
//                                                     //                         () {
//                                                     //                       Navigator.pop(
//                                                     //                           Preferences.instance.navigator.currentContext);
//                                                     //                     },
//                                                     //                   ),
//                                                     //                 );
//                                                     //               }
//                                                     //             }
//                                                     //             log('type -> $type');
//                                                     //             log('value -> $value');
//                                                     //             log('cardNumber -> $cardNumber');
//                                                     //             log('walletNumber -> $walletNumber');
//                                                     //             log('dateYear -> $dateYear');
//                                                     //             log('dateMonth -> $dateMonth');
//                                                     //             log('ccvNumber -> $ccvNumber');
//                                                     //           },
//                                                     //         ));
//                                                   },
//                                                 ));
//                                       } else {
//                                         showDialog(
//                                             context: context,
//                                             builder: (c) =>
//                                                 ApplyConfirmationDialog(
//                                                   onOkPressed: () async {
//                                                     Navigator.pop(c);
//                                                   },
//                                                   isDone: false,
//                                                 ));
//                                       }
//                                     }
//                                   },
//                                   shipmentId: widget.bulkShipment.id,
//                                   amount: widget.bulkShipment.amount.toString(),
//                                   shippingCost: widget
//                                       .bulkShipment.expectedShippingCost
//                                       .toString(),
//                                 ));
//                         // }
//                         // else {
//                         //   showDialog(
//                         //       context: context,
//                         //       builder: (cx) => ActionDialog(
//                         //             content:
//                         //                 'يمكنك التقديم علي الطلبات من ١٠ صباحاً حتي ١٠ مساءاً',
//                         //             onApproveClick: () {
//                         //               Navigator.pop(cx);
//                         //             },
//                         //             approveAction: 'حسناً',
//                         //           ));
//                         // }
//                       },
//                       style: ButtonStyle(
//                         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(
//                               20.0,
//                             ),
//                           ),
//                         ),
//                         padding: WidgetStateProperty.all<EdgeInsets>(
//                           const EdgeInsets.symmetric(
//                             vertical: 6.0,
//                             horizontal: 20.0,
//                           ),
//                         ),
//                         backgroundColor: WidgetStateProperty.all<Color>(
//                             weevoPrimaryOrangeColor),
//                       ),
//                       child: const Text(
//                         'وصل الأوردر',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                         ),
//                       ),
//                     ),
//                   ]),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       widget.bulkShipment.products[0]
//                                           .productInfo.name,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       textDirection: TextDirection.rtl,
//                                       style: TextStyle(
//                                         fontSize: 17.sp,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     Text(
//                                       widget.bulkShipment.products[0]
//                                           .productInfo.description,
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       textDirection: TextDirection.rtl,
//                                       style: TextStyle(
//                                         fontSize: 12.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               widget.bulkShipment.paymentMethod == 'cod'
//                                   ? Image.asset(
//                                       'assets/images/shipment_cod_icon.png',
//                                       height: 35.0.h,
//                                       width: 35.0.h)
//                                   : Image.asset(
//                                       'assets/images/shipment_online_icon.png',
//                                       height: 35.0.h,
//                                       width: 35.0.h)
//                             ],
//                           ),
//                           SizedBox(
//                             height: 6.h,
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: weevoPrimaryOrangeColor,
//                                 ),
//                                 height: 8.h,
//                                 width: 8.w,
//                               ),
//                               SizedBox(
//                                 width: 5.w,
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   '${widget.bulkShipment.deliveringStateModel.name} - ${widget.bulkShipment.deliveringCityModel.name}',
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     fontSize: 16.0.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 2.5),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: List.generate(
//                                 3,
//                                 (index) => Container(
//                                   margin: const EdgeInsets.only(top: 1),
//                                   height: 3,
//                                   width: 3,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(1.5),
//                                     color: index < 3
//                                         ? weevoPrimaryOrangeColor
//                                         : weevoPrimaryBlueColor,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: weevoPrimaryBlueColor,
//                                 ),
//                                 height: 8.h,
//                                 width: 8.w,
//                               ),
//                               SizedBox(
//                                 width: 5.w,
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   '${widget.bulkShipment.receivingStateModel.name} - ${widget.bulkShipment.receivingCityModel.name}',
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     fontSize: 16.0.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 6.h,
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(8.0),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.0),
//                               color: const Color(0xffD8F3FF),
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Row(
//                                     children: [
//                                       Image.asset(
//                                         'assets/images/money_icon.png',
//                                         fit: BoxFit.contain,
//                                         color: const Color(0xff091147),
//                                         height: 20.h,
//                                         width: 20.w,
//                                       ),
//                                       SizedBox(
//                                         width: 5.w,
//                                       ),
//                                       Text(
//                                         '${double.parse(widget.bulkShipment.amount).toInt()}',
//                                         style: TextStyle(
//                                           fontSize: 12.0.sp,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 2.w,
//                                       ),
//                                       Text(
//                                         'جنية',
//                                         style: TextStyle(
//                                           fontSize: 10.0.sp,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Row(
//                                     children: [
//                                       Image.asset(
//                                         'assets/images/van_icon.png',
//                                         fit: BoxFit.contain,
//                                         color: const Color(0xff091147),
//                                         height: 20.h,
//                                         width: 20.w,
//                                       ),
//                                       SizedBox(
//                                         width: 5.w,
//                                       ),
//                                       Text(
//                                         '${double.parse(widget.bulkShipment.agreedShippingCost ?? widget.bulkShipment.expectedShippingCost).toInt()}',
//                                         style: TextStyle(
//                                           fontSize: 12.0.sp,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 2.w,
//                                       ),
//                                       Text(
//                                         'جنية',
//                                         style: TextStyle(
//                                           fontSize: 10.0.sp,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Future<void> getMezaStatus(
//       {required WalletProvider walletProvider,
//       required AuthProvider authProvider,
//       required String value}) async {
//     log(value);
//     log('${walletProvider.meezaCard.transaction.id}');
//     _t = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
//       log('t');
//       await walletProvider.checkPaymentStatus(
//           systemReferenceNumber: value,
//           transactionId: walletProvider.meezaCard.transaction.id);
//       if (walletProvider.state == NetworkState.SUCCESS) {
//         log('success');
//         if (walletProvider.creditStatus.status == 'completed') {
//           log('status compeleted');
//           if (t.isActive) {
//             t.cancel();
//             log('timer cancelled');
//           }
//           log('${walletProvider.creditStatus.status}');
//           await walletProvider.getCurrentBalance(
//               authorization: authProvider.appAuthorization, fromRefresh: false);
//           Navigator.pop(context);
//           showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (context) => ContentDialog(
//                     content: 'تم إيداع المبلغ بنجاح',
//                     callback: () {
//                       Navigator.pop(context);
//                       walletProvider.setDepositIndex(5);
//                       walletProvider.setAccountTypeIndex(null);
//                     },
//                   ));
//         } else {
//           log('not compeleted');
//         }
//       } else {
//         log('else');
//         if (t.isActive) {
//           t.cancel();
//           log('timer cancelled');
//         }
//         Navigator.pop(context);
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => ContentDialog(
//             content: 'برجاء التأكد من وجود رصيد كافي',
//             callback: () {
//               Navigator.pop(context);
//             },
//           ),
//         );
//       }
//     });
//   }
// }
