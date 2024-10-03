// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';

// import '../Providers/auth_provider.dart';
// import '../Providers/shipment_provider.dart';
// import '../Utilits/colors.dart';
// import '../Utilits/constants.dart';
// import '../Widgets/home_bulk_shipment_item.dart';
// import '../Widgets/network_error_widget.dart';
// import 'child_shipment_details.dart';
// import 'shipment_details_display.dart';

// class NewAvailableShipments extends StatefulWidget {
//   @override
//   _NewAvailableShipmentsState createState() => _NewAvailableShipmentsState();
// }

// class _NewAvailableShipmentsState extends State<NewAvailableShipments> {
//   TextEditingController _edittextController;
//   ShipmentProvider _shipmentProvider;
//   AuthProvider _authProvider;
//   Timer _t;
//   ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _edittextController = TextEditingController();
//     _shipmentProvider = Provider.of<ShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//     getShipment(true);
//     _t = Timer.periodic(Duration(seconds: 120), (timer) {
//       getShipment(false);
//     });
//     _scrollController = ScrollController();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         if (!_shipmentProvider.availableNextPageLoading) {
//           _shipmentProvider.availableNextPage();
//         }
//       }
//     });
//   }

//   void getShipment(bool v) async {
//     await _shipmentProvider.getAvailableShipment(
//         isPagination: false, isRefreshing: false, isFirstTime: v);
//     check(
//         ctx: context,
//         auth: _authProvider,
//         state: _shipmentProvider.availableState);
//   }

//   @override
//   void dispose() {
//     _edittextController.dispose();
//     if (_t.isActive) {
//       _t.cancel();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Consumer<ShipmentProvider>(
//       builder: (context, data, child) => RefreshIndicator(
//         onRefresh: () => data.clearAvailableShipmentList(),
//         child: data.availableState == NetworkState.WAITING
//             ? Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     weevoPrimaryOrangeColor,
//                   ),
//                 ),
//               )
//             : data.availableState == NetworkState.SUCCESS
//                 ? data.availableShipmentIsEmpty
//                     ? Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'لا يوجد لديك شحنات متاحة للتوصيل',
//                               strutStyle: StrutStyle(
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
//                             padding: EdgeInsets.only(top: size.height * 0.03),
//                             itemBuilder: (BuildContext ctx, int i) =>
//                                 HomeBulkShipmentItem(
//                               bulkShipment: data.availableShipments[i],
//                               onItemPressed: () => data
//                                       .availableShipments[i].children.isNotEmpty
//                                   ? Navigator.pushReplacementNamed(
//                                       context,
//                                       ChildShipmentDetails.id,
//                                       arguments: data.availableShipments[i].id,
//                                     )
//                                   : Navigator.pushReplacementNamed(
//                                       context,
//                                       ShipmentDetailsDisplay.id,
//                                       arguments: data.availableShipments[i].id,
//                                     ),
//                             ),
//                             itemCount: data.availableShipments.length,
//                           ),
//                           data.availableNextPageLoading
//                               ? Container(
//                                   height: 50.0,
//                                   color: Colors.white.withOpacity(0.2),
//                                   child: Center(
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
//                       await _shipmentProvider.getAvailableShipment(
//                           isPagination: false,
//                           isFirstTime: false,
//                           isRefreshing: false);
//                     },
//                   ),
//       ),
//     );
//   }
// }
