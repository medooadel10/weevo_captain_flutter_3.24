// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import '../Providers/auth_provider.dart';
// import 'shipment_details_display.dart';
// import '../Utilits/constants.dart';
// import '../Widgets/bulk_shipment_item.dart';
// import '../Utilits/colors.dart';
// import '../Providers/shipment_provider.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../Widgets/network_error_widget.dart';
// import 'child_shipment_details.dart';

// class DeliveredShipmentHost extends StatefulWidget {
//   static const String id = 'Delivered_Shipment_Host';
//   final String value;

//   DeliveredShipmentHost({
//     this.value,
//     Key key,
//   }) : super(key: key);

//   @override
//   _DeliveredShipmentHostState createState() => _DeliveredShipmentHostState();
// }

// class _DeliveredShipmentHostState extends State<DeliveredShipmentHost> {
//   TextEditingController _editTextController;
//   ShipmentProvider _shipmentProvider;
//   AuthProvider _authProvider;
//   ScrollController _scrollController;

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
//         if (!_shipmentProvider.deliveredNextPageLoading) {
//           _shipmentProvider.deliveredNextPage();
//         }
//       }
//     });
//   }

//   void getData() async {
//     await _shipmentProvider.getDeliveryShipment(
//         isPagination: false, isFirstTime: true, isRefreshing: false);
//     check(
//         ctx: context,
//         auth: _authProvider,
//         state: _shipmentProvider.deliveredState);
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
//           onRefresh: () => data.clearDeliveredShipmentList(),
//           child: data.deliveredState == NetworkState.WAITING
//               ? Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       weevoPrimaryOrangeColor,
//                     ),
//                   ),
//                 )
//               : data.deliveredState == NetworkState.SUCCESS
//                   ? data.deliveredShipmentIsEmpty
//                       ? Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'لا يوجد لديك شحنات مكتملة',
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
//                               itemBuilder: (BuildContext ctx, int i) => data
//                                       .deliveredShipments[i].children.isNotEmpty
//                                   ? data.deliveredShipments[i].children
//                                           .any((e) => e.status == 'delivered')
//                                       ? BulkShipmentItem(
//                                           onItemPressed: () => data
//                                                   .deliveredShipments[i]
//                                                   .children
//                                                   .isNotEmpty
//                                               ? Navigator.pushNamed(
//                                                   context,
//                                                   ChildShipmentDetails.id,
//                                                   arguments: data
//                                                       .deliveredShipments[i].id,
//                                                 )
//                                               : Navigator.pushNamed(
//                                                   context,
//                                                   ShipmentDetailsDisplay.id,
//                                                   arguments: data
//                                                       .deliveredShipments[i].id,
//                                                 ),
//                                           bulkShipment:
//                                               data.deliveredShipments[i],
//                                         )
//                                       : Container()
//                                   : BulkShipmentItem(
//                                       onItemPressed: () => data
//                                               .deliveredShipments[i]
//                                               .children
//                                               .isNotEmpty
//                                           ? Navigator.pushNamed(
//                                               context,
//                                               ChildShipmentDetails.id,
//                                               arguments:
//                                                   data.deliveredShipments[i].id,
//                                             )
//                                           : Navigator.pushNamed(
//                                               context,
//                                               ShipmentDetailsDisplay.id,
//                                               arguments:
//                                                   data.deliveredShipments[i].id,
//                                             ),
//                                       bulkShipment: data.deliveredShipments[i],
//                                     ),
//                               itemCount: data.deliveredShipments.length,
//                             ),
//                             data.deliveredNextPageLoading
//                                 ? Container(
//                                     height: 50.0,
//                                     color: Colors.white.withOpacity(0.2),
//                                     child: Center(
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
//                         await _shipmentProvider.getDeliveryShipment(
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