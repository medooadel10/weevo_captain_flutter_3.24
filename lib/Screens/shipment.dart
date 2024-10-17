// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import '../Providers/auth_provider.dart';
// import '../Providers/shipment_provider.dart';
// import '../Utilits/constants.dart';
// import '../Utilits/colors.dart';
// import '../Widgets/connectivity_widget.dart';
// import '../Widgets/shipment_status_item.dart';

// class Shipment extends StatefulWidget {
//   static const String id = 'Shipment';

//   @override
//   _ShipmentState createState() => _ShipmentState();
// }

// class _ShipmentState extends State<Shipment> {
//   ShipmentProvider _shipmentProvider;
//   AuthProvider _authProvider;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _shipmentProvider = Provider.of<ShipmentProvider>(context, listen: false);
//     _authProvider = Provider.of<AuthProvider>(context, listen: false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final AuthProvider authProvider = Provider.of<AuthProvider>(context);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Consumer<ShipmentProvider>(
//         builder: (context, data, child) => Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 Icons.arrow_back_ios_outlined,
//               ),
//             ),
//             title: Text(
//               'حالة الطلبات',
//             ),
//           ),
//           body: ConnectivityWidget(
//             callback: () {},
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 Wrap(
//                   alignment: WrapAlignment.center,
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   spacing: 10.0,
//                   runSpacing: 10.0,
//                   children: List.generate(
//                     tabs.length,
//                     (i) => ShipmentStatusItem(
//                       data: tabs[i],
//                       index: i,
//                       selectedItem: _selectedIndex,
//                       onItemClick: (int i) {
//                         setState(() {
//                           _selectedIndex = i;
//                         });
//                         data.changePortion(i, false);
//                       },
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: data.shipmentStatusState == NetworkState.WAITING ||
//                           authProvider.countryState == NetworkState.WAITING
//                       ? Center(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                                 weevoPrimaryOrangeColor),
//                           ),
//                         )
//                       : data.currentShipmentWidget,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
