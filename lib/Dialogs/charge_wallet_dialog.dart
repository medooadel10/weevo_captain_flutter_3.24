// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:weevo_captain/Storage/shared_preference.dart';
//
// import '../Providers/wallet_provider.dart';
// import '../Utilits/colors.dart';
// import '../Utilits/constants.dart';
//
// class ChargeWalletDialog extends StatefulWidget {
//   final int shipmentAmount;
//   final Function onSubmit;
//
//   const ChargeWalletDialog({
//     required this.shipmentAmount,
//     required this.onSubmit,
//     Key key,
//   }) : super(key: key);
//
//   @override
//   State<ChargeWalletDialog> createState() => _ChargeWalletDialogState();
// }
//
// class _ChargeWalletDialogState extends State<ChargeWalletDialog> {
//   final GlobalKey<FormState> _key = GlobalKey<FormState>();
//   TextEditingController _depositTypeController,
//       _depositValueController,
//       _dateMonthController,
//       _dateYearController;
//   int _valuePicker;
//   WalletProvider _walletProvider;
//   String _depositType,
//       _depositValue,
//       _depositCardNumber,
//       _depositMonth,
//       _depositYear,
//       _depositCVVNumber,
//       _depositWalletNumber;
//
//   @override
//   void initState() {
//     super.initState();
//     _walletProvider = Provider.of<WalletProvider>(context, listen: false);
//     _depositTypeController = TextEditingController();
//     _depositValueController = TextEditingController();
//     _dateMonthController = TextEditingController();
//     _dateYearController = TextEditingController();
//     getData();
//   }
//
//   void getData() async {
//     await _walletProvider.weevoListOfAvailablePaymentGateways();
//     _depositTypeController.text =
//         _walletProvider.listOfAvailablePaymentGateways[0].gateway == 'e-wallet'
//             ? 'محفظة الكترونية'
//             : 'كارت ميزة';
//     _valuePicker =
//         _walletProvider.listOfAvailablePaymentGateways[0].gateway == 'e-wallet'
//             ? 0
//             : 1;
//     _depositValueController.text = (((widget.shipmentAmount.toDouble() *
//                 double.parse(_walletProvider.listOfAvailablePaymentGateways[0]
//                     .depositionBankChargeValue) /
//                 100) +
//             double.parse(_walletProvider.listOfAvailablePaymentGateways[0]
//                 .depositionAlwaysAppliedFixedBankChargeAmount) +
//             widget.shipmentAmount.toDouble())
//         .toStringAsFixed(2));
//   }
//
//   @override
//   void dispose() {
//     _depositValueController.dispose();
//     _depositTypeController.dispose();
//     _dateMonthController.dispose();
//     _dateYearController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Dialog(
//         insetPadding: EdgeInsets.symmetric(
//           horizontal: 10.0.w,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         child: walletProvider.listOfAvailablePaymentGatewaysState ==
//                 NetworkState.WAITING
//             ? Container(
//                 height: 80.0,
//                 padding: EdgeInsets.all(20.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text('برجاء الأنتظار',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 18.0,
//                         )),
//                     SpinKitDoubleBounce(
//                       size: 30,
//                       color: weevoPrimaryOrangeColor,
//                     ),
//                   ],
//                 ),
//               )
//             : Padding(
//                 padding: const EdgeInsets.all(
//                   12.0,
//                 ),
//                 child: Form(
//                   key: _key,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'طريقة الإيداع',
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 4.h,
//                                 ),
//                                 TextFormField(
//                                   readOnly: true,
//                                   controller: _depositTypeController,
//                                   key: const ValueKey('deposit type'),
//                                   style: TextStyle(
//                                     fontSize: 11.sp,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   onTap: () {
//                                     showDialog(
//                                         context: context,
//                                         builder: (ctx) => Dialog(
//                                               shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           12.r)),
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           12.r),
//                                                 ),
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: 20.w,
//                                                   vertical: 10.h,
//                                                 ),
//                                                 child: SingleChildScrollView(
//                                                   child: Column(
//                                                     mainAxisSize:
//                                                         MainAxisSize.min,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       walletProvider
//                                                                   .listOfAvailablePaymentGatewaysState ==
//                                                               NetworkState
//                                                                   .WAITING
//                                                           ? Container(
//                                                               height: 100,
//                                                               alignment:
//                                                                   Alignment
//                                                                       .center,
//                                                               child: const Text(
//                                                                   'برجاء الأنتظار'),
//                                                             )
//                                                           : ListView.builder(
//                                                               shrinkWrap: true,
//                                                               primary: false,
//                                                               itemCount:
//                                                                   walletProvider
//                                                                       .listOfAvailablePaymentGateways
//                                                                       .length,
//                                                               itemBuilder:
//                                                                   (context, i) {
//                                                                 return InkWell(
//                                                                     onTap: () {
//                                                                       _valuePicker =
//                                                                           i;
//                                                                       log('i -> $i');
//                                                                       log('_valuePicker -> $_valuePicker');
//                                                                       setState(
//                                                                           () {
//                                                                         _depositTypeController
//                                                                             .text = walletProvider.listOfAvailablePaymentGateways[i].gateway ==
//                                                                                 'e-wallet'
//                                                                             ? 'محفظة الكترونية'
//                                                                             : 'كارت ميزة';
//                                                                         _depositValueController
//                                                                             .text = (((widget.shipmentAmount.toDouble() * double.parse(walletProvider.listOfAvailablePaymentGateways[i].depositionBankChargeValue) / 100) +
//                                                                                 double.parse(walletProvider.listOfAvailablePaymentGateways[i].depositionAlwaysAppliedFixedBankChargeAmount) +
//                                                                                 widget.shipmentAmount.toDouble())
//                                                                             .toStringAsFixed(2));
//                                                                       });
//                                                                       Navigator
//                                                                           .pop(
//                                                                               ctx);
//                                                                     },
//                                                                     child:
//                                                                         Column(
//                                                                       children: [
//                                                                         Container(
//                                                                             margin:
//                                                                                 EdgeInsets.only(bottom: 5.h, top: 5.h),
//                                                                             padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
//                                                                             decoration: BoxDecoration(
//                                                                               borderRadius: BorderRadius.all(Radius.circular(5.r)),
//                                                                               //color: Color(h.mainColor)
//                                                                             ),
//                                                                             alignment: Alignment.center,
//                                                                             child: Text(
//                                                                               walletProvider.listOfAvailablePaymentGateways[i].gateway == 'e-wallet' ? 'محفظة الكترونية' : 'كارت ميزة',
//                                                                               style: TextStyle(
//                                                                                 fontSize: 12.sp,
//                                                                                 fontWeight: FontWeight.bold,
//                                                                               ),
//                                                                             )),
//                                                                       ],
//                                                                     ));
//                                                               },
//                                                             ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ));
//                                   },
//                                   validator: (String v) =>
//                                       v.isEmpty ? 'أدخل طريقة الأيداع' : null,
//                                   onSaved: (String v) {
//                                     _depositType = v == 'كارت ميزة'
//                                         ? 'meeza-card'
//                                         : 'e-wallet';
//                                   },
//                                   decoration: InputDecoration(
//                                     suffixIcon: const Icon(
//                                       Icons.arrow_drop_down,
//                                       color: Colors.black,
//                                     ),
//                                     prefixIcon: Padding(
//                                       padding: const EdgeInsets.all(12.0),
//                                       child: Image.asset(
//                                         'assets/images/mizapay.png',
//                                         height: 15.h,
//                                         width: 15.h,
//                                       ),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 2.0, color: Colors.black),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                     disabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             width: 8.w,
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'مبلغ الإيداع',
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 4.h,
//                                 ),
//                                 TextFormField(
//                                   readOnly: true,
//                                   controller: _depositValueController,
//                                   key: const ValueKey('deposit value'),
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   validator: (String v) =>
//                                       v.isEmpty ? 'أدخل مبلغ الأيداع' : null,
//                                   onSaved: (String v) {
//                                     _depositValue = v;
//                                   },
//                                   decoration: InputDecoration(
//                                     suffixIcon: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           'جنية',
//                                           style: TextStyle(
//                                               fontSize: 10.sp,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.grey),
//                                         ),
//                                       ],
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                     disabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 6.h,
//                       ),
//                       _depositTypeController.text == 'محفظة الكترونية'
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'رقم المحفظة',
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 4.h,
//                                 ),
//                                 TextFormField(
//                                   key: const ValueKey(
//                                       'deposit meza wallet number'),
//                                   keyboardType: TextInputType.number,
//                                   maxLength: 11,
//                                   validator: (String v) =>
//                                       (v.isEmpty || v.length < 11)
//                                           ? 'أدخل رقم المحفظة'
//                                           : null,
//                                   onSaved: (String v) {
//                                     _depositWalletNumber = v;
//                                   },
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12.sp,
//                                   ),
//                                   decoration: InputDecoration(
//                                     hintText: '01XXXXXXXXX',
//                                     counterText: '',
//                                     hintStyle: TextStyle(
//                                       color: Colors.grey[400],
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12.sp,
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'رقم البطاقة',
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 4.h,
//                                 ),
//                                 TextFormField(
//                                   key: const ValueKey(
//                                       'deposit meza card number'),
//                                   keyboardType: TextInputType.number,
//                                   validator: (String v) =>
//                                       (v.isEmpty || v.length < 19)
//                                           ? 'أدخل رقم البطاقة'
//                                           : null,
//                                   onSaved: (String v) {
//                                     _depositCardNumber = v;
//                                   },
//                                   textAlign: TextAlign.center,
//                                   inputFormatters: [
//                                     FilteringTextInputFormatter.digitsOnly,
//                                     LengthLimitingTextInputFormatter(16),
//                                     CreditCardInputFormatter(),
//                                   ],
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12.sp,
//                                   ),
//                                   decoration: InputDecoration(
//                                     counterText: '',
//                                     hintText: 'XXXX-XXXX-XXXX-XXXX',
//                                     hintStyle: TextStyle(
//                                       color: Colors.grey[400],
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12.sp,
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: const BorderSide(
//                                           width: 1.0, color: Colors.grey),
//                                       borderRadius:
//                                           BorderRadius.circular(20.0.r),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                       _depositTypeController.text == 'محفظة الكترونية'
//                           ? Container()
//                           : SizedBox(
//                               height: 6.h,
//                             ),
//                       _depositTypeController.text == 'محفظة الكترونية'
//                           ? Container()
//                           : Row(
//                               children: [
//                                 Expanded(
//                                   flex: 5,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'تاريخ الإنتهاء',
//                                         style: TextStyle(
//                                           fontSize: 12.sp,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 4.h,
//                                       ),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             flex: 2,
//                                             child: TextFormField(
//                                               readOnly: true,
//                                               controller: _dateMonthController,
//                                               style: TextStyle(
//                                                 color: const Color(0xff29234f),
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 12.sp,
//                                               ),
//                                               validator: (String v) => v.isEmpty
//                                                   ? 'من فضلك أدخل شهر الانتهاء'
//                                                   : null,
//                                               onSaved: (String v) {
//                                                 _depositMonth = v;
//                                               },
//                                               onTap: () {
//                                                 showDialog(
//                                                     context: context,
//                                                     builder: (ctx) => Dialog(
//                                                           shape: RoundedRectangleBorder(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           12.r)),
//                                                           child: Container(
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               color:
//                                                                   Colors.white,
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           12.r),
//                                                             ),
//                                                             padding: EdgeInsets
//                                                                 .symmetric(
//                                                               horizontal: 20.w,
//                                                               vertical: 10.h,
//                                                             ),
//                                                             child:
//                                                                 SingleChildScrollView(
//                                                               child: Column(
//                                                                 mainAxisSize:
//                                                                     MainAxisSize
//                                                                         .min,
//                                                                 crossAxisAlignment:
//                                                                     CrossAxisAlignment
//                                                                         .start,
//                                                                 children: [
//                                                                   ListView
//                                                                       .builder(
//                                                                     shrinkWrap:
//                                                                         true,
//                                                                     primary:
//                                                                         false,
//                                                                     itemCount:
//                                                                         months
//                                                                             .length,
//                                                                     itemBuilder:
//                                                                         (context,
//                                                                             i) {
//                                                                       return InkWell(
//                                                                           onTap:
//                                                                               () {
//                                                                             setState(() {
//                                                                               _dateMonthController.text = months[i];
//                                                                             });
//                                                                             Navigator.pop(ctx);
//                                                                           },
//                                                                           child:
//                                                                               Column(
//                                                                             children: [
//                                                                               Container(
//                                                                                   margin: EdgeInsets.only(bottom: 5.h, top: 5.h),
//                                                                                   padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
//                                                                                   decoration: BoxDecoration(
//                                                                                     borderRadius: BorderRadius.all(Radius.circular(5.r)),
//                                                                                     //color: Color(h.mainColor)
//                                                                                   ),
//                                                                                   alignment: Alignment.center,
//                                                                                   child: Text(
//                                                                                     months[i],
//                                                                                     style: TextStyle(
//                                                                                       fontSize: 12.sp,
//                                                                                       fontWeight: FontWeight.bold,
//                                                                                     ),
//                                                                                   )),
//                                                                             ],
//                                                                           ));
//                                                                     },
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ));
//                                               },
//                                               key: const ValueKey(
//                                                   'expiry date month'),
//                                               textAlign: TextAlign.center,
//                                               decoration: InputDecoration(
//                                                 hintText: '04',
//                                                 hintStyle: TextStyle(
//                                                     color: Colors.grey[400]),
//                                                 filled: true,
//                                                 fillColor:
//                                                     const Color(0xfff4f3f8),
//                                                 border: OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       width: 1.0,
//                                                       color:
//                                                           Colors.transparent),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0.r),
//                                                 ),
//                                                 focusedBorder:
//                                                     OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       width: 1.0,
//                                                       color:
//                                                           Colors.transparent),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0.r),
//                                                 ),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       width: 1.0,
//                                                       color:
//                                                           Colors.transparent),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0.r),
//                                                 ),
//                                                 disabledBorder:
//                                                     OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       width: 1.0,
//                                                       color:
//                                                           Colors.transparent),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0.r),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 4.w,
//                                           ),
//                                           Expanded(
//                                             flex: 3,
//                                             child: TextFormField(
//                                               controller: _dateYearController,
//                                               readOnly: true,
//                                               key: const ValueKey(
//                                                   'expiry date year'),
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 color: const Color(0xff29234f),
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 12.sp,
//                                               ),
//                                               onTap: () {
//                                                 showDialog(
//                                                     context: context,
//                                                     builder: (ctx) => Dialog(
//                                                           shape: RoundedRectangleBorder(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           12.r)),
//                                                           child: Container(
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               color:
//                                                                   Colors.white,
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           12.r),
//                                                             ),
//                                                             padding: EdgeInsets
//                                                                 .symmetric(
//                                                               horizontal: 20.w,
//                                                               vertical: 10.h,
//                                                             ),
//                                                             child:
//                                                                 SingleChildScrollView(
//                                                               child: Column(
//                                                                 mainAxisSize:
//                                                                     MainAxisSize
//                                                                         .min,
//                                                                 crossAxisAlignment:
//                                                                     CrossAxisAlignment
//                                                                         .start,
//                                                                 children: [
//                                                                   ListView
//                                                                       .builder(
//                                                                     shrinkWrap:
//                                                                         true,
//                                                                     primary:
//                                                                         false,
//                                                                     itemCount: years
//                                                                         .length,
//                                                                     itemBuilder:
//                                                                         (context,
//                                                                             i) {
//                                                                       return InkWell(
//                                                                           onTap:
//                                                                               () {
//                                                                             setState(() {
//                                                                               _dateYearController.text = years[i];
//                                                                             });
//                                                                             Navigator.pop(ctx);
//                                                                           },
//                                                                           child:
//                                                                               Column(
//                                                                             children: [
//                                                                               Container(
//                                                                                   margin: EdgeInsets.only(bottom: 5.h, top: 5.h),
//                                                                                   padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
//                                                                                   decoration: BoxDecoration(
//                                                                                     borderRadius: BorderRadius.all(Radius.circular(5.r)),
//                                                                                     //color: Color(h.mainColor)
//                                                                                   ),
//                                                                                   alignment: Alignment.center,
//                                                                                   child: Text(
//                                                                                     years[i],
//                                                                                     style: TextStyle(
//                                                                                       fontSize: 12.sp,
//                                                                                       fontWeight: FontWeight.bold,
//                                                                                     ),
//                                                                                   )),
//                                                                             ],
//                                                                           ));
//                                                                     },
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ));
//                                               },
//                                               validator: (String v) => v.isEmpty
//                                                   ? 'من فضلك أدخل سنة الانتهاء'
//                                                   : null,
//                                               onSaved: (String v) {
//                                                 _depositYear = v;
//                                               },
//                                               decoration: InputDecoration(
//                                                 hintText: '22',
//                                                 hintStyle: TextStyle(
//                                                     color: Colors.grey[400]),
//                                                 fillColor:
//                                                     const Color(0xfff4f3f8),
//                                                 filled: true,
//                                                 border: OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       width: 1.0,
//                                                       color:
//                                                           Colors.transparent),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0.r),
//                                                 ),
//                                                 focusedBorder:
//                                                     OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       width: 1.0,
//                                                       color:
//                                                           Colors.transparent),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0.r),
//                                                 ),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       width: 1.0,
//                                                       color:
//                                                           Colors.transparent),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0.r),
//                                                 ),
//                                                 disabledBorder:
//                                                     OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       width: 1.0,
//                                                       color:
//                                                           Colors.transparent),
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0.r),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 4.w,
//                                 ),
//                                 Expanded(
//                                   flex: 4,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'الرقم السري ccv',
//                                         style: TextStyle(
//                                           fontSize: 12.sp,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 4.h,
//                                       ),
//                                       TextFormField(
//                                         key: const ValueKey('card ccv number'),
//                                         keyboardType: TextInputType.number,
//                                         maxLength: 3,
//                                         validator: (String v) =>
//                                             (v.isEmpty || v.length < 3)
//                                                 ? 'من فضلك أدخل الرمز السري cvv'
//                                                 : null,
//                                         onSaved: (String v) {
//                                           _depositCVVNumber = v;
//                                         },
//                                         textAlign: TextAlign.center,
//                                         obscureText: true,
//                                         style: TextStyle(
//                                           color: const Color(0xff29234f),
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 12.sp,
//                                         ),
//                                         decoration: InputDecoration(
//                                           hintStyle: TextStyle(
//                                               color: Colors.grey[400]),
//                                           fillColor: const Color(0xfff4f3f8),
//                                           counterText: '',
//                                           hintText: 'cvv',
//                                           filled: true,
//                                           border: OutlineInputBorder(
//                                             borderSide: const BorderSide(
//                                                 width: 1.0,
//                                                 color: Colors.transparent),
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0.r),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderSide: const BorderSide(
//                                                 width: 1.0,
//                                                 color: Colors.transparent),
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0.r),
//                                           ),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: const BorderSide(
//                                                 width: 1.0,
//                                                 color: Colors.transparent),
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0.r),
//                                           ),
//                                           disabledBorder: OutlineInputBorder(
//                                             borderSide: const BorderSide(
//                                                 width: 1.0,
//                                                 color: Colors.transparent),
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0.r),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                       SizedBox(
//                         height: 12.h,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           TextButton(
//                             onPressed: () {
//                               if (_key.currentState.validate()) {
//                                 _key.currentState.save();
//                                 Navigator.pop(Preferences
//                                     .instance.navigator.currentContext);
//                                 widget.onSubmit(
//                                     _depositType,
//                                     _depositValue,
//                                     _depositCardNumber,
//                                     _depositWalletNumber,
//                                     _depositMonth,
//                                     _depositYear,
//                                     _depositCVVNumber);
//                               }
//                             },
//                             style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                 const Color(0xFFfef4eb),
//                               ),
//                               shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(20.r))),
//                               padding: MaterialStateProperty.all<EdgeInsets>(
//                                   EdgeInsets.all(16.0)),
//                             ),
//                             child: Text(
//                               'اشحن محفظتك',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: const Color(0xFFFC8449),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
//
// class CreditCardInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     var text = newValue.text;
//
//     if (newValue.selection.baseOffset == 0) {
//       return newValue;
//     }
//
//     var buffer = StringBuffer();
//     for (int i = 0; i < text.length; i++) {
//       buffer.write(text[i]);
//       var nonZeroIndex = i + 1;
//       if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
//         buffer.write('-'); // Add double spaces.
//       }
//     }
//
//     var string = buffer.toString();
//     return newValue.copyWith(
//         text: string,
//         selection: TextSelection.collapsed(offset: string.length));
//   }
// }
//
// class CardMonthInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     var newText = newValue.text;
//
//     if (newValue.selection.baseOffset == 0) {
//       return newValue;
//     }
//
//     var buffer = new StringBuffer();
//     for (int i = 0; i < newText.length; i++) {
//       buffer.write(newText[i]);
//       var nonZeroIndex = i + 1;
//       if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
//         buffer.write('/');
//       }
//     }
//
//     var string = buffer.toString();
//     return newValue.copyWith(
//         text: string,
//         selection: new TextSelection.collapsed(offset: string.length));
//   }
// }
//
// const List<String> months = [
//   '01',
//   '02',
//   '03',
//   '04',
//   '05',
//   '06',
//   '07',
//   '08',
//   '09',
//   '10',
//   '11',
//   '12',
// ];
//
// const List<String> years = [
//   '15',
//   '16',
//   '17',
//   '18',
//   '19',
//   '20',
//   '21',
//   '22',
//   '23',
//   '24',
//   '25',
//   '26',
//   '27',
//   '28',
//   '29',
//   '30',
// ];
