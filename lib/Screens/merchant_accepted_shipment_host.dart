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

// class MerchantAcceptedShipmentHost extends StatefulWidget {
//   static const String id = 'Merchant_Accepted_Shipment_Host';
//   final String? value;

//   const MerchantAcceptedShipmentHost({
//     super.key,
//     this.value,
//   });

//   @override
//   State<MerchantAcceptedShipmentHost> createState() =>
//       _MerchantAcceptedShipmentHostState();
// }

// class _MerchantAcceptedShipmentHostState
//     extends State<MerchantAcceptedShipmentHost> {
//   late TextEditingController _editTextController;
//   late ShipmentProvider _shipmentProvider;
//   late AuthProvider _authProvider;
//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _editTextController = TextEditingController();
//     _shipmentProvider = Provider.of(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     getData();
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (!_shipmentProvider.merchantAcceptedNextPageLoading) {
//           _shipmentProvider.merchantAcceptedNextPage();
//         }
//       }
//     });
//   }

//   void getData() async {
//     await _shipmentProvider.getMerchantAcceptedShipment(
//         isPagination: false, isFirstTime: true, isRefreshing: false);
//     check(
//         ctx: context,
//         auth: _authProvider,
//         state: _shipmentProvider.merchantAcceptedShipmentState);
//   }

//   @override
//   void dispose() {
//     _editTextController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Consumer<ShipmentProvider>(
//         builder: (context, data, child) => RefreshIndicator(
//           onRefresh: () => data.clearMerchantAcceptedShipmentList(),
//           child: data.merchantAcceptedShipmentState == NetworkState.WAITING
//               ? const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       weevoPrimaryOrangeColor,
//                     ),
//                   ),
//                 )
//               : data.merchantAcceptedShipmentState == NetworkState.SUCCESS
//                   ? data.merchantAcceptedShipmentIsEmpty
//                       ? Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 'لا يوجد لديك طلبات في انتظار التوصيل',
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
//                                   BulkShipmentItem(
//                                 onItemPressed: () => data
//                                         .merchantAcceptedShipments[i]
//                                         .children
//                                         .isNotEmpty
//                                     ? Navigator.pushNamed(
//                                         context,
//                                         ChildShipmentDetails.id,
//                                         arguments: data
//                                             .merchantAcceptedShipments[i].id,
//                                       )
//                                     : Navigator.pushNamed(
//                                         context, ShipmentDetailsDisplay.id,
//                                         arguments: data
//                                             .merchantAcceptedShipments[i].id),
//                                 bulkShipment: data.merchantAcceptedShipments[i],
//                               ),
//                               itemCount: data.merchantAcceptedShipments.length,
//                             ),
//                             data.merchantAcceptedNextPageLoading
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
//                         await _shipmentProvider.getMerchantAcceptedShipment(
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
