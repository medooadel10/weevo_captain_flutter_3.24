// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';

// import '../Dialogs/action_dialog.dart';
// import '../Dialogs/loading.dart';
// import '../Models/shipment_notification.dart';
// import '../Providers/auth_provider.dart';
// import '../Providers/shipment_provider.dart';
// import '../Utilits/colors.dart';
// import '../Utilits/constants.dart';
// // import '../Widgets/network_error_widget.dart';
// import '../Widgets/shipment_offer_item.dart';
// import 'child_shipment_details.dart';
// import 'shipment_details_display.dart';

// class CourierAppliedShipmentHost extends StatefulWidget {
//   const CourierAppliedShipmentHost({
//     super.key,
//   });

//   @override
//   State<CourierAppliedShipmentHost> createState() =>
//       _CourierAppliedShipmentHostState();
// }

// class _CourierAppliedShipmentHostState
//     extends State<CourierAppliedShipmentHost> {
//   late TextEditingController _editTextController;
//   late ShipmentProvider _shipmentProvider;
//   late AuthProvider _authProvider;
//   late ScrollController _scrollController;
//   Timer? _t;

//   @override
//   void initState() {
//     super.initState();
//     _editTextController = TextEditingController();
//     _shipmentProvider = Provider.of<ShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     getData();
//     _t = Timer.periodic(const Duration(seconds: 60), (timer) {
//       _shipmentProvider.getCourierAppliedShipment(
//           isPagination: false, isFirstTime: false, isRefreshing: false);
//     });
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (!_shipmentProvider.courierAppliedNextPageLoading) {
//           _shipmentProvider.courierAppliedNextPage();
//         }
//       }
//     });
//   }

//   void getData() async {
//     await _shipmentProvider.getCourierAppliedShipment(
//         isPagination: false, isFirstTime: true, isRefreshing: false);
//     check(
//         ctx: context,
//         auth: _authProvider,
//         state: _shipmentProvider.courierAppliedState);
//   }

//   @override
//   void dispose() {
//     _editTextController.dispose();
//     if (_t.isActive) {
//       _t.cancel();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final shipmentProvider = Provider.of<ShipmentProvider>(context);
//     final authProvider = Provider.of<AuthProvider>(context);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Consumer<ShipmentProvider>(
//         builder: (context, data, child) => RefreshIndicator(
//           onRefresh: () => data.clearCourierAppliedShipmentList(),
//           child: data.courierAppliedState == NetworkState.WAITING
//               ? const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       weevoPrimaryOrangeColor,
//                     ),
//                   ),
//                 )
//               : data.courierAppliedState == NetworkState.SUCCESS
//                   ? data.courierAppliedShipmentIsEmpty
//                       ? Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 'لا يوجد لديك شحنات مقدم عليها',
//                                 strutStyle: StrutStyle(
//                                   forceStrutHeight: true,
//                                 ),
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 6.w,
//                               ),
//                               Image.asset(
//                                 'assets/images/shipment_details_icon.png',
//                                 width: 30.0,
//                                 height: 30.0,
//                               ),
//                             ],
//                           ),
//                         )
//                       : Stack(
//                           alignment: Alignment.bottomCenter,
//                           children: [
//                             ListView.builder(
//                               controller: _scrollController,
//                               padding: EdgeInsets.only(top: size.height * 0.03),
//                               itemBuilder: (BuildContext ctx, int i) =>
//                                   ShipmentOfferItem(
//                                 onDeclineOfferCallback: () {
//                                   showDialog(
//                                       context: context,
//                                       builder: (ctx) => ActionDialog(
//                                             content:
//                                                 'هل تود الانسحاب من العرض؟',
//                                             title: 'الأنسحاب من العرض',
//                                             onApproveClick: () async {
//                                               Navigator.pop(ctx);
//                                               showDialog(
//                                                   context: context,
//                                                   builder: (c) => Loading());
//                                               DocumentSnapshot userToken =
//                                                   await FirebaseFirestore
//                                                       .instance
//                                                       .collection(
//                                                           'merchant_users')
//                                                       .doc(data
//                                                           .courierAppliedShipments[
//                                                               i]
//                                                           .shipment
//                                                           .merchantId
//                                                           .toString())
//                                                       .get();
//                                               String token =
//                                                   userToken['fcmToken'];
//                                               await shipmentProvider
//                                                   .declineFromShipment(
//                                                       offerId: data
//                                                           .courierAppliedShipments[
//                                                               i]
//                                                           .id);
//                                               if (shipmentProvider
//                                                       .declineFromShipmentState ==
//                                                   NetworkState.SUCCESS) {
//                                                 authProvider.sendNotification(
//                                                     body:
//                                                         'قام الكابتن ${authProvider.name}بسحب العرض المقدم علي شحنتك',
//                                                     toToken: token,
//                                                     image: authProvider
//                                                             .photo.isNotEmpty
//                                                         ? authProvider.photo
//                                                                 .contains(
//                                                                     base_url)
//                                                             ? authProvider.photo
//                                                             : '$base_url${authProvider.photo}'
//                                                         : '',
//                                                     type: 'decline_offer',
//                                                     title: 'تم سحب العرض',
//                                                     screenTo:
//                                                         'shipment_decline',
//                                                     data: ShipmentNotification(
//                                                       receivingState: data
//                                                           .courierAppliedShipments[
//                                                               i]
//                                                           .shipment
//                                                           .receivingState,
//                                                       receivingCity: data
//                                                           .courierAppliedShipments[
//                                                               i]
//                                                           .shipment
//                                                           .receivingCity,
//                                                       deliveryState: data
//                                                           .courierAppliedShipments[
//                                                               i]
//                                                           .shipment
//                                                           .deliveringState,
//                                                       deliveryCity: data
//                                                           .courierAppliedShipments[
//                                                               i]
//                                                           .shipment
//                                                           .deliveringCity,
//                                                       shipmentId: data
//                                                           .courierAppliedShipments[
//                                                               i]
//                                                           .shipment
//                                                           .id,
//                                                       totalShipmentCost: data
//                                                           .courierAppliedShipments[
//                                                               i]
//                                                           .shipment
//                                                           .amount,
//                                                       merchantImage: null,
//                                                       merchantName: null,
//                                                       childrenShipment: data
//                                                                   .courierAppliedShipments[
//                                                                       i]
//                                                                   .shipment
//                                                                   .parentId ==
//                                                               0
//                                                           ? 0
//                                                           : 1,
//                                                       shippingCost: data
//                                                           .courierAppliedShipments[
//                                                               i]
//                                                           .shipment
//                                                           .expectedShippingCost,
//                                                     ).toMap());
//                                                 FirebaseFirestore.instance
//                                                     .collection(
//                                                         'merchant_notifications')
//                                                     .doc(data
//                                                         .courierAppliedShipments[
//                                                             i]
//                                                         .shipment
//                                                         .merchantId
//                                                         .toString())
//                                                     .collection(data
//                                                         .courierAppliedShipments[
//                                                             i]
//                                                         .shipment
//                                                         .merchantId
//                                                         .toString())
//                                                     .add({
//                                                   'read': false,
//                                                   'date_time': DateTime.now()
//                                                       .toIso8601String(),
//                                                   'type': 'decline_offer',
//                                                   'title': 'تم سحب العرض',
//                                                   'body':
//                                                       'قام الكابتن ${authProvider.name}بسحب العرض المقدم علي شحنتك',
//                                                   'user_icon': authProvider
//                                                           .photo.isNotEmpty
//                                                       ? authProvider.photo
//                                                               .contains(
//                                                                   base_url)
//                                                           ? authProvider.photo
//                                                           : '$base_url${authProvider.photo}'
//                                                       : '',
//                                                   'screen_to':
//                                                       'shipment_decline',
//                                                   'data': ShipmentNotification(
//                                                     receivingState: data
//                                                         .courierAppliedShipments[
//                                                             i]
//                                                         .shipment
//                                                         .receivingState,
//                                                     receivingCity: data
//                                                         .courierAppliedShipments[
//                                                             i]
//                                                         .shipment
//                                                         .receivingCity,
//                                                     deliveryState: data
//                                                         .courierAppliedShipments[
//                                                             i]
//                                                         .shipment
//                                                         .deliveringState,
//                                                     deliveryCity: data
//                                                         .courierAppliedShipments[
//                                                             i]
//                                                         .shipment
//                                                         .deliveringCity,
//                                                     shipmentId: data
//                                                         .courierAppliedShipments[
//                                                             i]
//                                                         .shipment
//                                                         .id,
//                                                     totalShipmentCost: data
//                                                         .courierAppliedShipments[
//                                                             i]
//                                                         .shipment
//                                                         .amount,
//                                                     merchantImage: null,
//                                                     merchantName: null,
//                                                     childrenShipment: data
//                                                                 .courierAppliedShipments[
//                                                                     i]
//                                                                 .shipment
//                                                                 .parentId ==
//                                                             0
//                                                         ? 0
//                                                         : 1,
//                                                     shippingCost: data
//                                                         .courierAppliedShipments[
//                                                             i]
//                                                         .shipment
//                                                         .expectedShippingCost,
//                                                   ).toMap(),
//                                                 });
//                                                 Navigator.pop(context);
//                                                 showDialog(
//                                                     context: context,
//                                                     builder: (c) =>
//                                                         ActionDialog(
//                                                           content:
//                                                               'تم الأنسحاب من العرض بنجاح',
//                                                           onApproveClick: () {
//                                                             Navigator.pop(c);
//                                                             shipmentProvider.getCourierAppliedShipment(
//                                                                 isPagination:
//                                                                     false,
//                                                                 isFirstTime:
//                                                                     false,
//                                                                 isRefreshing:
//                                                                     false);
//                                                           },
//                                                           approveAction:
//                                                               'حسناً',
//                                                         ));
//                                               } else if (shipmentProvider
//                                                       .declineFromShipmentState ==
//                                                   NetworkState.LOGOUT) {
//                                                 check(
//                                                     ctx: context,
//                                                     auth: authProvider,
//                                                     state: shipmentProvider
//                                                         .declineFromShipmentState);
//                                               } else if (shipmentProvider
//                                                       .declineFromShipmentState ==
//                                                   NetworkState.ERROR) {
//                                                 Navigator.pop(context);
//                                               }
//                                             },
//                                             onCancelClick: () {
//                                               Navigator.pop(context);
//                                             },
//                                             approveAction: 'نعم',
//                                             cancelAction: 'لا',
//                                           ));
//                                 },
//                                 onItemPressed: () => data
//                                             .courierAppliedShipments[i]
//                                             .shipment
//                                             .childrenCount >
//                                         0
//                                     ? Navigator.pushNamed(
//                                         context,
//                                         ChildShipmentDetails.id,
//                                         arguments: data
//                                             .courierAppliedShipments[i]
//                                             .shipmentId,
//                                       )
//                                     : Navigator.pushNamed(
//                                         context, ShipmentDetailsDisplay.id,
//                                         arguments: data
//                                             .courierAppliedShipments[i]
//                                             .shipmentId),
//                                 shipmentOfferData:
//                                     data.courierAppliedShipments[i],
//                               ),
//                               itemCount: data.courierAppliedShipments.length,
//                             ),
//                             data.courierAppliedNextPageLoading
//                                 ? Container(
//                                     height: 50.0,
//                                     color: Colors.white.withOpacity(0.2),
//                                     child: const Center(
//                                       child: SpinKitThreeBounce(
//                                         color: weevoPrimaryOrangeColor,
//                                         size: 30.0,
//                                       ),
//                                     ),
//                                   )
//                                 : Container()
//                           ],
//                         )
//                   : NetworkErrorWidget(
//                       onRetryCallback: () async {
//                         await _shipmentProvider.getCourierAppliedShipment(
//                             isPagination: false,
//                             isFirstTime: false,
//                             isRefreshing: false);
//                       },
//                     ),
//         ),
//       ),
//     );
//   }
// }
