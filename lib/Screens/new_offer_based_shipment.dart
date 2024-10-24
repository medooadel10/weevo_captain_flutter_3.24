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
// import '../Widgets/network_error_widget.dart';
// import 'child_shipment_details.dart';
// import 'shipment_details_display.dart';

// class NewOfferBasedShipments extends StatefulWidget {
//   const NewOfferBasedShipments({super.key});

//   @override
//   State<NewOfferBasedShipments> createState() => _NewOfferBasedShipmentsState();
// }

// class _NewOfferBasedShipmentsState extends State<NewOfferBasedShipments> {
//   late ShipmentProvider _shipmentProvider;
//   late AuthProvider _authProvider;
//   Timer? _t;
//   late ScrollController _scrollController;

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
//     if (_t!.isActive) {
//       _t!.cancel();
//     }
//     super.dispose();
//   }

//   void getShipment(bool v) async {
//     _shipmentProvider.getOfferBasedShipment(
//         isPagination: false, isRefreshing: false, isFirstTime: v);
//     check(
//         ctx: context,
//         auth: _authProvider,
//         state: _shipmentProvider.offerBasedState!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ShipmentProvider>(
//       builder: (context, data, child) => RefreshIndicator(
//         onRefresh: () => data.clearOfferBasedShipmentList(),
//         child: data.offerBasedState == NetworkState.waiting
//             ? const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     weevoPrimaryOrangeColor,
//                   ),
//                 ),
//               )
//             : data.offerBasedState == NetworkState.success
//                 ? data.offerBasedShipmentIsEmpty
//                     ? Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'لا يوجد لديك طلبات متاحة للتوصيل',
//                               strutStyle: const StrutStyle(
//                                 forceStrutHeight: true,
//                               ),
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16.0.sp,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 6.w,
//                             ),
//                             Image.asset(
//                               'assets/images/shipment_details_icon.png',
//                               width: 30.0,
//                               height: 30.0,
//                             ),
//                           ],
//                         ),
//                       )
//                     : Stack(
//                         alignment: Alignment.bottomCenter,
//                         children: [
//                           ListView.builder(
//                             controller: _scrollController,
//                             padding: EdgeInsets.only(top: 10.h),
//                             itemBuilder: (BuildContext ctx, int i) =>
//                                 BulkShipmentItem(
//                               onItemPressed: () => data.offerBasedShipments[i]
//                                       .children!.isNotEmpty
//                                   ? Navigator.pushReplacementNamed(
//                                       context,
//                                       ChildShipmentDetails.id,
//                                       arguments: data.offerBasedShipments[i].id,
//                                     )
//                                   : Navigator.pushReplacementNamed(
//                                       context, ShipmentDetailsDisplay.id,
//                                       arguments:
//                                           data.offerBasedShipments[i].id),
//                               bulkShipment: data.offerBasedShipments[i],
//                             ),
//                             itemCount: data.offerBasedShipments.length,
//                           ),
//                           data.offerBasedNextPageLoading
//                               ? Container(
//                                   height: 50.0,
//                                   color: Colors.white.withOpacity(0.2),
//                                   child: const Center(
//                                       child: SpinKitThreeBounce(
//                                     color: weevoPrimaryOrangeColor,
//                                     size: 30.0,
//                                   )),
//                                 )
//                               : Container()
//                         ],
//                       )
//                 : NetworkErrorWidget(
//                     onRetryCallback: () async {
//                       await _shipmentProvider.getOfferBasedShipment(
//                           isPagination: false,
//                           isFirstTime: false,
//                           isRefreshing: false);
//                     },
//                   ),
//       ),
//     );
//   }
// }
