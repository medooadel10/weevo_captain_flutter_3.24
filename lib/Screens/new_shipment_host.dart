// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';

// import '../Providers/auth_provider.dart';
// import '../Providers/shipment_provider.dart';
// import '../Utilits/colors.dart';
// import '../Utilits/constants.dart';
// import '../Widgets/bulk_shipment_item.dart';
// import '../Widgets/connectivity_widget.dart';
// import '../Widgets/network_error_widget.dart';
// import 'child_shipment_details.dart';
// import 'home.dart';
// import 'shipment_details_display.dart';

// class AvailableShipmentContainer extends StatefulWidget {
//   static const String id = 'Available_Shipments';

//   const AvailableShipmentContainer({super.key});

//   @override
//   State<AvailableShipmentContainer> createState() =>
//       _AvailableShipmentContainerState();
// }

// class _AvailableShipmentContainerState
//     extends State<AvailableShipmentContainer> {
//   ShipmentProvider _shipmentProvider;
//   AuthProvider _authProvider;
//   Timer _t;
//   ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _shipmentProvider = Provider.of<ShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     getShipment(true);
//     _t = Timer.periodic(const Duration(seconds: 120), (timer) {
//       getShipment(false);
//     });
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (!_shipmentProvider.offerBasedNextPageLoading) {
//           _shipmentProvider.offerBasedNextPage();
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     if (_t.isActive) {
//       _t.cancel();
//     }
//     super.dispose();
//   }

//   void getShipment(bool v) async {
//     _shipmentProvider.getOfferBasedShipment(
//         isPagination: false, isRefreshing: false, isFirstTime: v);
//     check(
//         ctx: context,
//         auth: _authProvider,
//         state: _shipmentProvider.offerBasedState);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final shipmentProvider = Provider.of<ShipmentProvider>(context);
//     return WillPopScope(
//       onWillPop: () async {
//         if (shipmentProvider.shipmentFromHome) {
//           shipmentProvider.setShipmentFromHome(false);
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             Home.id,
//             (route) => false,
//           );
//         } else {
//           Navigator.pop(context);
//         }
//         return false;
//       },
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           body: ConnectivityWidget(
//             callback: () {},
//             child: SafeArea(
//               child: Consumer<ShipmentProvider>(
//                 builder: (context, data, child) => RefreshIndicator(
//                   onRefresh: () => data.clearOfferBasedShipmentList(),
//                   child: data.offerBasedState == NetworkState.WAITING
//                       ? const Center(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               weevoPrimaryOrangeColor,
//                             ),
//                           ),
//                         )
//                       : data.offerBasedState == NetworkState.SUCCESS
//                           ? data.offerBasedShipmentIsEmpty
//                               ? Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         'لا يوجد لديك طلبات متاحة للتوصيل',
//                                         strutStyle: const StrutStyle(
//                                           forceStrutHeight: true,
//                                         ),
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 16.0.sp,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 6.w,
//                                       ),
//                                       Image.asset(
//                                         'assets/images/shipment_details_icon.png',
//                                         width: 30.0,
//                                         height: 30.0,
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : Stack(
//                                   alignment: Alignment.bottomCenter,
//                                   children: [
//                                     ListView.builder(
//                                       controller: _scrollController,
//                                       padding: EdgeInsets.only(top: 10.h),
//                                       itemBuilder: (BuildContext ctx, int i) =>
//                                           BulkShipmentItem(
//                                         onItemPressed: () => data
//                                                 .offerBasedShipments[i]
//                                                 .children
//                                                 .isNotEmpty
//                                             ? Navigator.pushReplacementNamed(
//                                                 context,
//                                                 ChildShipmentDetails.id,
//                                                 arguments: data
//                                                     .offerBasedShipments[i].id,
//                                               )
//                                             : Navigator.pushReplacementNamed(
//                                                 context,
//                                                 ShipmentDetailsDisplay.id,
//                                                 arguments: data
//                                                     .offerBasedShipments[i].id),
//                                         bulkShipment:
//                                             data.offerBasedShipments[i],
//                                       ),
//                                       itemCount:
//                                           data.offerBasedShipments.length,
//                                     ),
//                                     data.offerBasedNextPageLoading
//                                         ? Container(
//                                             height: 50.0,
//                                             color:
//                                                 Colors.white.withOpacity(0.2),
//                                             child: const Center(
//                                                 child: SpinKitThreeBounce(
//                                               color: weevoPrimaryOrangeColor,
//                                               size: 30.0,
//                                             )),
//                                           )
//                                         : Container()
//                                   ],
//                                 )
//                           : NetworkErrorWidget(
//                               onRetryCallback: () async {
//                                 await _shipmentProvider.getOfferBasedShipment(
//                                     isPagination: false,
//                                     isFirstTime: false,
//                                     isRefreshing: false);
//                               },
//                             ),
//                 ),
//               ),
//             ),
//             // SafeArea(
//             //   child: Consumer<ShipmentProvider>(
//             //     builder: (context, data, child) => Column(
//             //       children: [
//             //         Row(
//             //           children: [
//             //             AvailableShipmentTabItem(
//             //                 title: 'طلبات التوصيل',
//             //                 smallTitle: 'تقديم عروض',
//             //                 index: 1,
//             //                 selectedIndex: data.availableShipmentIndex,
//             //                 onTap: () {
//             //                   data.setAvailableShipmentIndex(1);
//             //                 }),
//             //             AvailableShipmentTabItem(
//             //                 title: 'المتاحة للتوصيل',
//             //                 smallTitle: 'قبول الشحنة',
//             //                 index: 0,
//             //                 selectedIndex: data.availableShipmentIndex,
//             //                 onTap: () {
//             //                   data.setAvailableShipmentIndex(0);
//             //                 }),
//             //           ],
//             //         ),
//             //         Expanded(
//             //           child: data.availableShipment,
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//           ),
//         ),
//       ),
//     );
//   }
// }
