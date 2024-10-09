import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weevo_captain_app/core/router/router.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';
import 'package:weevo_captain_app/features/available_shipments/ui/screens/available_shipments_screen.dart';

import '../Dialogs/action_dialog.dart';
import '../Dialogs/apply_confirmation_dialog.dart';
import '../Dialogs/cancel_shipment_dialog.dart';
import '../Dialogs/content_dialog.dart';
import '../Dialogs/deliver_shipment_dialog.dart';
import '../Dialogs/inside_offer_dialog.dart';
import '../Dialogs/loading.dart';
import '../Dialogs/no_credit_dialog.dart';
import '../Dialogs/offer_confirmation_dialog.dart';
import '../Dialogs/update_offer_dialog.dart';
import '../Dialogs/update_offer_request_dialog.dart';
import '../Models/chat_data.dart';
import '../Models/feedback_data_arg.dart';
import '../Models/shipment_notification.dart';
import '../Models/shipment_tracking_model.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Providers/wallet_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../core/networking/api_constants.dart';
import '../main.dart';
import 'chat_screen.dart';
import 'handle_shipment.dart';
import 'home.dart';
import 'merchant_feedback.dart';
import 'wallet.dart';

class ShipmentDetailsWithOneProduct extends StatefulWidget {
  final int shipmentId;

  const ShipmentDetailsWithOneProduct({super.key, required this.shipmentId});

  @override
  State<ShipmentDetailsWithOneProduct> createState() =>
      _ShipmentDetailsWithOneProductState();
}

class _ShipmentDetailsWithOneProductState
    extends State<ShipmentDetailsWithOneProduct> {
  Timer? t;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);
    final shipmentProvider = Provider.of<ShipmentProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<ShipmentProvider>(
        builder: (context, data, child) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: Text('شحنة رقم ${data.shipmentById!.id}'),
              leading: IconButton(
                onPressed: () {
                  if (data.fromNewShipment &&
                      data.shipmentById!.parentId == 0) {
                    data.setFromNewShipment(false);
                    data.setAvailableShipmentIndex(data.availableShipmentIndex);
                    MagicRouter.navigateAndPop(
                        const AvailableShipmentsScreen());
                  } else if (authProvider.fromOutsideNotification) {
                    authProvider.setFromOutsideNotification(false);
                    Navigator.pushReplacementNamed(context, Home.id);
                  } else {
                    if ((shipmentProvider.shipmentById!.parentId ?? 0) > 0) {
                      shipmentProvider.getBulkShipmentById(
                          id: shipmentProvider.shipmentById!.parentId!,
                          isFirstTime: false);
                    }
                    Navigator.pop(context);
                  }
                },
                icon: Container(
                    height: 35.h,
                    width: 35.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
                    )),
              )),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Column(
              children: [
                (data.shipmentById!.status ==
                                'merchant-accepted-shipping-offer' ||
                            data.shipmentById!.status ==
                                'courier-applied-to-shipment' ||
                            data.shipmentById!.status ==
                                'on-the-way-to-get-shipment-from-merchant' ||
                            data.shipmentById!.status == 'on-delivery') &&
                        data.shipmentById!.courierId ==
                            int.parse(Preferences.instance.getUserId)
                    ? Container(
                        height: 81.h,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10.0,
                              spreadRadius: 1.0,
                              color: Colors.black.withOpacity(0.1),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: SizedBox(
                                height: 60.h,
                                width: 60.w,
                                child: data.shipmentById!.merchant?.photo !=
                                            null &&
                                        data.shipmentById!.merchant!.photo!
                                            .isNotEmpty
                                    ? CustomImage(
                                        image: data
                                                .shipmentById!.merchant!.photo!
                                                .contains(ApiConstants.baseUrl)
                                            ? data
                                                .shipmentById!.merchant!.photo!
                                            : '${ApiConstants.baseUrl}${data.shipmentById!.merchant!.photo}',
                                      )
                                    : Image.asset(
                                        'assets/images/profile_picture.png',
                                      ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${data.shipmentById!.merchant!.firstName} ${data.shipmentById!.merchant!.lastName}',
                                    style: TextStyle(
                                      fontSize: 15.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (data.shipmentById!.merchant!
                                          .cachedAverageRating !=
                                      null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        RatingBar.builder(
                                          initialRating: double.parse(data
                                              .shipmentById!
                                              .merchant!
                                              .cachedAverageRating!),
                                          minRating: 1,
                                          ignoreGestures: true,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 18.0,
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: weevoLightYellow,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          data.shipmentById!.merchant!
                                              .cachedAverageRating!
                                              .substring(0, 3),
                                          style: TextStyle(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pushNamed(
                                    context, MerchantFeedback.id,
                                    arguments: FeedbackDataArg(
                                        username:
                                            data.shipmentById!.merchant!.name!,
                                        userId:
                                            data.shipmentById!.merchant!.id!));
                              },
                              child: Container(
                                  height: 32.h,
                                  width: 32.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffFFE9DF),
                                  ),
                                  child: const Icon(
                                    Icons.star,
                                    size: 20.0,
                                    color: weevoPrimaryOrangeColor,
                                  )),
                            ),
                            SizedBox(width: 4.w),
                            GestureDetector(
                              onTap: () async {
                                DocumentSnapshot userToken =
                                    await FirebaseFirestore
                                        .instance
                                        .collection('merchant_users')
                                        .doc(data.shipmentById!.merchantId
                                            .toString())
                                        .get();
                                String merchantNationalId =
                                    userToken['national_id'];
                                Navigator.pushNamed(
                                    navigator.currentContext!, ChatScreen.id,
                                    arguments: ChatData(
                                        currentUserImageUrl: authProvider.photo,
                                        peerNationalId: merchantNationalId,
                                        currentUserNationalId:
                                            authProvider.getNationalId,
                                        currentUserId: authProvider.id,
                                        currentUserName: authProvider.name,
                                        shipmentId: data.shipmentById!.id,
                                        peerId: data.shipmentById!.merchant!.id
                                            .toString(),
                                        peerUserName:
                                            '${data.shipmentById!.merchant!.firstName} ${data.shipmentById!.merchant!.lastName}',
                                        peerImageUrl: data
                                            .shipmentById!.merchant!.photo));
                              },
                              child: Container(
                                height: 32.h,
                                width: 32.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffFFE9DF),
                                ),
                                child: Image.asset(
                                  'assets/images/new_chat_icon.png',
                                  color: weevoPrimaryOrangeColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            GestureDetector(
                              onTap: () async {
                                await launchUrlString(
                                  'tel:${data.shipmentById!.merchant!.phone}',
                                );
                              },
                              child: Container(
                                height: 32.h,
                                width: 32.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffFFE9DF),
                                ),
                                child: Image.asset(
                                  'assets/images/new_call_icon.png',
                                  color: weevoPrimaryOrangeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                (data.shipmentById!.status ==
                                'merchant-accepted-shipping-offer' ||
                            data.shipmentById!.status ==
                                'courier-applied-to-shipment' ||
                            data.shipmentById!.status ==
                                'on-the-way-to-get-shipment-from-merchant' ||
                            data.shipmentById!.status == 'on-delivery') &&
                        data.shipmentById!.courierId ==
                            int.parse(Preferences.instance.getUserId)
                    ? SizedBox(
                        height: 10.h,
                      )
                    : Container(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                        color: Colors.black.withOpacity(0.1),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: CustomImage(
                      image:
                          data.shipmentById!.products![0].productInfo!.image ??
                              '',
                      height: 196.h,
                      width: size.width,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                            color: Colors.black.withOpacity(0.1),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.shipmentById!.products![0]
                                          .productInfo!.name!,
                                      style: TextStyle(
                                        fontSize: 19.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    Text(
                                      data.shipmentById!.products![0]
                                          .productInfo!.description!,
                                      style: TextStyle(
                                        fontSize: 11.0.sp,
                                        color: const Color(0xff858585),
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Row(children: [
                                authProvider.getCatById(data
                                            .shipmentById!
                                            .products![0]
                                            .productInfo!
                                            .categoryId!) !=
                                        null
                                    ? Row(
                                        children: [
                                          CustomImage(
                                            image:
                                                '${ApiConstants.baseUrl}${data.shipmentById!.products![0].productInfo!.productCategory!.image}',
                                            height: 25.h,
                                            width: 25.w,
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          Text(
                                            data
                                                .shipmentById!
                                                .products![0]
                                                .productInfo!
                                                .productCategory!
                                                .name!,
                                            style: TextStyle(
                                              fontSize: 12.0.sp,
                                            ),
                                          )
                                        ],
                                      )
                                    : Container(),
                              ]),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/weevo_weight.png',
                                height: 20.h,
                                width: 20.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                '${double.parse(data.shipmentById!.products![0].productInfo!.weight!).toInt()}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'كيلو',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 7.0.sp,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              SizedBox(
                                height: 15.h,
                                child: VerticalDivider(
                                  width: 1.w,
                                  thickness: 1.0,
                                  color: Colors.grey[400],
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Image.asset(
                                'assets/images/weevo_money.png',
                                height: 20.h,
                                width: 20.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                '${double.parse(data.shipmentById!.amount!).toInt()}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'جنية',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 7.0.sp,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              SizedBox(
                                height: 15.h,
                                child: VerticalDivider(
                                  width: 1.w,
                                  thickness: 1.0,
                                  color: Colors.grey[400],
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              
                              if (Preferences.instance.getUserFlags ==
                                  'freelance') ...[
                                    Image.asset(
                                'assets/images/van_icon.png',
                                height: 20.h,
                                width: 20.w,
                                fit: BoxFit.contain,
                              ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  '${double.parse(data.shipmentById!.agreedShippingCostAfterDiscount ?? data.shipmentById!.agreedShippingCost ?? data.shipmentById!.expectedShippingCost ?? '0').toInt()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  strutStyle: const StrutStyle(
                                    forceStrutHeight: true,
                                  ),
                                ),
                              ],
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                'جنية',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 7.0.sp,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              SizedBox(
                                height: 15.h,
                                child: VerticalDivider(
                                  width: 1.w,
                                  thickness: 1.0,
                                  color: Colors.grey[400],
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              data.shipmentById!.paymentMethod == 'cod'
                                  ? Image.asset(
                                      'assets/images/shipment_inside_cod_icon.png',
                                      height: 20.0.h,
                                      width: 20.0.h)
                                  : Image.asset(
                                      'assets/images/shipment_inside_online_icon.png',
                                      height: 20.0.h,
                                      width: 20.0.h),
                              SizedBox(
                                width: 5.w,
                              ),
                              data.shipmentById!.paymentMethod == 'cod'
                                  ? Text(
                                      'دفع مقدم',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    )
                                  : Text(
                                      'مدفوع أونلاين',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    ((data.shipmentById!.status == 'available' ||
                                data.shipmentById!.status == 'new') ||
                            data.shipmentById!.coupon == null)
                        ? Container()
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10.0,
                                  spreadRadius: 1.0,
                                  color: Colors.black.withOpacity(0.1),
                                )
                              ],
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text(
                                  'الاوردر ده عليه خصم علي سعر التوصيل\nهتحصل من العميل ${num.parse(data.shipmentById!.agreedShippingCostAfterDiscount ?? '0').toInt()} ج وهتستلم في محفظتك ${(num.parse(data.shipmentById!.agreedShippingCost ?? '0').toInt() - num.parse(data.shipmentById!.agreedShippingCostAfterDiscount ?? '0').toInt())} ج',
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: weevoPrimaryBlueColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ((data.shipmentById!.status == 'available' ||
                                data.shipmentById!.status == 'new') ||
                            data.shipmentById!.coupon == null)
                        ? Container()
                        : SizedBox(
                            height: 8.h,
                          ),
                    Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 20.0,
                              spreadRadius: 0.0,
                              color: Colors.black.withOpacity(0.1),
                            )
                          ]),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Image.asset(
                                    asset('weevo_my_address_icon'),
                                    height: 24.h,
                                    width: 24.w,
                                    color: weevoPrimaryBlueColor,
                                  ),
                                  hSpace(10),
                                  Text(
                                    'البداية',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '${data.shipmentById!.distanceFromLocationToPickup}',
                                      style: TextStyle(
                                        fontSize: 16.0.sp,
                                        color: weevoPrimaryBlueColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                    hSpace(6),
                                    Text(
                                      'KM',
                                      style: TextStyle(
                                        fontSize: 16.0.sp,
                                        color: weevoWhiteGrey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    asset('shipment_box_gray'),
                                    height: 24.h,
                                    width: 24.w,
                                    color: weevoPrimaryBlueColor,
                                  ),
                                  hSpace(10),
                                  Text(
                                    'الإستلام',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '${data.shipmentById!.distanceFromPickupToDeliver}',
                                      style: TextStyle(
                                        fontSize: 16.0.sp,
                                        color: weevoPrimaryBlueColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                    hSpace(6),
                                    Text(
                                      'KM',
                                      style: TextStyle(
                                        fontSize: 16.0.sp,
                                        color: weevoWhiteGrey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      strutStyle: const StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    asset('shipment_delivery_icon'),
                                    height: 24.h,
                                    width: 24.w,
                                    color: weevoPrimaryBlueColor,
                                  ),
                                  hSpace(10),
                                  Text(
                                    'التسليم',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    strutStyle: const StrutStyle(
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          const Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: Color(0xffE2E2E2),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 10.h,
                                    width: 10.w,
                                    decoration: BoxDecoration(
                                        color: weevoPrimaryOrangeColor,
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                  ),
                                  SizedBox(width: 10.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.shipmentById!.merchant!.name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        strutStyle: const StrutStyle(
                                          forceStrutHeight: true,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Text(
                                            'من - ',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12.0.sp,
                                            ),
                                            strutStyle: const StrutStyle(
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                          Text(
                                            '${data.shipmentById!.receivingStateModel!.name} - ${data.shipmentById!.receivingCityModel!.name}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12.0.sp,
                                            ),
                                            strutStyle: const StrutStyle(
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                  height: 31.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF6F6F6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).day ==
                                                    DateTime.now().day) &&
                                                (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).month ==
                                                    DateTime.now().month) &&
                                                (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).year ==
                                                    DateTime.now().year)
                                            ? 'اليوم'
                                            : (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).day ==
                                                        DateTime.now().day +
                                                            1) &&
                                                    (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).month ==
                                                        DateTime.now().month) &&
                                                    (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).year ==
                                                        DateTime.now().year)
                                                ? 'غداً'
                                                : (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).day ==
                                                            DateTime.now().day -
                                                                1) &&
                                                        (DateTime.parse(data.shipmentById!.dateToReceiveShipment!)
                                                                .month ==
                                                            DateTime.now()
                                                                .month) &&
                                                        (DateTime.parse(data.shipmentById!.dateToReceiveShipment!).year ==
                                                            DateTime.now().year)
                                                    ? 'أمس'
                                                    : intl.DateFormat('dd MMM yyyy', 'ar-EG').format(DateTime.parse(data.shipmentById!.dateToReceiveShipment!)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        strutStyle: const StrutStyle(
                                          forceStrutHeight: true,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        intl.DateFormat('hh:mm a', 'ar-EG')
                                            .format(DateTime.parse(data
                                                .shipmentById!
                                                .dateToReceiveShipment!)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                        ),
                                        strutStyle: const StrutStyle(
                                          forceStrutHeight: true,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          const Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: Color(0xffE2E2E2),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 10.h,
                                      width: 10.w,
                                      decoration: BoxDecoration(
                                          color: weevoPrimaryBlueColor,
                                          borderRadius:
                                              BorderRadius.circular(5.r)),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.shipmentById!.clientName!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15.0.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            strutStyle: const StrutStyle(
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              Text(
                                                'إلي - ',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12.0.sp,
                                                ),
                                                strutStyle: const StrutStyle(
                                                  forceStrutHeight: true,
                                                ),
                                              ),
                                              Text(
                                                '${data.shipmentById!.deliveringStateModel!.name} - ${data.shipmentById!.deliveringCityModel!.name}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12.0.sp,
                                                ),
                                                strutStyle: const StrutStyle(
                                                  forceStrutHeight: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            data.shipmentById!
                                                .deliveringStreet!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12.0.sp,
                                              color: const Color(0xffA1A1A1),
                                            ),
                                            strutStyle: const StrutStyle(
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                      width: 100.w,
                                      height: 31.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffF6F6F6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).day ==
                                                        DateTime.now().day) &&
                                                    (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).month ==
                                                        DateTime.now().month) &&
                                                    (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).year ==
                                                        DateTime.now().year)
                                                ? 'اليوم'
                                                : (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).day ==
                                                            DateTime.now().day +
                                                                1) &&
                                                        (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).month ==
                                                            DateTime.now()
                                                                .month) &&
                                                        (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).year ==
                                                            DateTime.now().year)
                                                    ? 'غداً'
                                                    : (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).day ==
                                                                DateTime.now().day -
                                                                    1) &&
                                                            (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).month ==
                                                                DateTime.now()
                                                                    .month) &&
                                                            (DateTime.parse(data.shipmentById!.dateToDeliverShipment!).year ==
                                                                DateTime.now().year)
                                                        ? 'أمس'
                                                        : intl.DateFormat('dd MMM yyyy', 'ar-EG').format(DateTime.parse(data.shipmentById!.dateToDeliverShipment!)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            strutStyle: const StrutStyle(
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          Text(
                                            intl.DateFormat('hh:mm a', 'ar-EG')
                                                .format(DateTime.parse(data
                                                    .shipmentById!
                                                    .dateToDeliverShipment!)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 10.0.sp,
                                            ),
                                            strutStyle: const StrutStyle(
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(height: 4.h),
                                  (data.shipmentById!.status ==
                                                  'merchant-accepted-shipping-offer' ||
                                              data.shipmentById!.status ==
                                                  'on-the-way-to-get-shipment-from-merchant' ||
                                              data.shipmentById!.status ==
                                                  'courier-applied-to-shipment' ||
                                              data.shipmentById!.status ==
                                                  'on-delivery') &&
                                          data.shipmentById!.courierId ==
                                              int.parse(Preferences
                                                  .instance.getUserId)
                                      ? GestureDetector(
                                          onTap: () async {
                                            await canLaunchUrlString(
                                              'tel:${data.shipmentById!.clientPhone}',
                                            );
                                          },
                                          child: Container(
                                            height: 30.h,
                                            width: 100.w,
                                            padding: const EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              color: const Color(0xffFFE9DF),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Image.asset(
                                                'assets/images/big_phone_icon.png',
                                                height: 25.0.h,
                                                width: 25.0.w),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          data.shipmentById!.status == 'available' &&
                                  data.shipmentById!.isOfferBased == 0 &&
                                  data.shipmentById!.parentId == 0
                              ? Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // if (DateTime
                                      //     .now()
                                      //     .hour >= 10 &&
                                      //     DateTime
                                      //         .now()
                                      //         .hour <= 22){
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) =>
                                              DeliverShipmentDialog(
                                                onOkPressed: (String v) {
                                                  if (v == 'DONE') {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (c) =>
                                                            ApplyConfirmationDialog(
                                                              onOkPressed:
                                                                  () async {
                                                                Navigator.pop(
                                                                    c);
                                                                await data.getShipmentById(
                                                                    id: data
                                                                        .shipmentById!
                                                                        .id!,
                                                                    isFirstTime:
                                                                        false);
                                                                DocumentSnapshot
                                                                    userToken =
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'merchant_users')
                                                                        .doc(data
                                                                            .shipmentById!
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
                                                                    .doc(data
                                                                        .shipmentById!
                                                                        .merchantId
                                                                        .toString())
                                                                    .collection(data
                                                                        .shipmentById!
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
                                                                              .contains(ApiConstants.baseUrl)
                                                                          ? authProvider.photo
                                                                          : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                      : '',
                                                                  'screen_to':
                                                                      'shipment_screen',
                                                                  'data': ShipmentTrackingModel(
                                                                          shipmentId: data
                                                                              .shipmentById!
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
                                                                    data: ShipmentTrackingModel(shipmentId: data.shipmentById!.id, hasChildren: 1).toJson(),
                                                                    screenTo: 'shipment_screen',
                                                                    type: 'cancel_shipment');
                                                              },
                                                              isDone: true,
                                                            ));
                                                  } else {
                                                    if (data.noCredit ??
                                                        false) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (c) =>
                                                              NoCreditDialog(
                                                                onOkCancelCallback:
                                                                    () {
                                                                  Navigator.pop(
                                                                      c);
                                                                },
                                                                onChargeWalletCallback:
                                                                    () {
                                                                  Navigator.pop(
                                                                      c);
                                                                  walletProvider
                                                                      .setMainIndex(
                                                                          1);
                                                                  walletProvider.setDepositAmount(num.parse(data
                                                                          .bulkShipmentById!
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
                                                                          c,
                                                                          Wallet
                                                                              .id);

                                                                  // Navigator.pop(
                                                                  //     c);
                                                                  // showDialog(
                                                                  //     context: Preferences
                                                                  //         .instance
                                                                  //         .navigator
                                                                  //         .currentContext,
                                                                  //     barrierDismissible: false,
                                                                  //
                                                                  //     builder: (
                                                                  //         ctx) =>
                                                                  //         ChargeWalletDialog(
                                                                  //           shipmentAmount: num
                                                                  //               .parse(
                                                                  //               data
                                                                  //                   .shipmentById
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
                                                                  //                   barrierDismissible:
                                                                  //                   false,
                                                                  //                   builder:
                                                                  //                       (
                                                                  //                       context) =>
                                                                  //                       Loading());
                                                                  //               await walletProvider
                                                                  //                   .addCreditWithMeeza(
                                                                  //                 amount:
                                                                  //                 num
                                                                  //                     .parse(
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
                                                                  //                           builder:
                                                                  //                               (
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
                                                                  //                           context:
                                                                  //                           Preferences
                                                                  //                               .instance
                                                                  //                               .navigator
                                                                  //                               .currentContext,
                                                                  //                           barrierDismissible:
                                                                  //                           false,
                                                                  //                           builder:
                                                                  //                               (
                                                                  //                               context) =>
                                                                  //                               Loading());
                                                                  //                       await getMezaStatus(
                                                                  //                           walletProvider:
                                                                  //                           walletProvider,
                                                                  //                           authProvider:
                                                                  //                           authProvider,
                                                                  //                           value:
                                                                  //                           value);
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
                                                                  //                     await walletProvider
                                                                  //                         .getCurrentBalance(
                                                                  //                         authorization:
                                                                  //                         authProvider
                                                                  //                             .appAuthorization,
                                                                  //                         fromRefresh:
                                                                  //                         false);
                                                                  //                     Navigator
                                                                  //                         .pop(
                                                                  //                         Preferences
                                                                  //                             .instance
                                                                  //                             .navigator
                                                                  //                             .currentContext);
                                                                  //                     showDialog(
                                                                  //                         context:
                                                                  //                         Preferences
                                                                  //                             .instance
                                                                  //                             .navigator
                                                                  //                             .currentContext,
                                                                  //                         barrierDismissible:
                                                                  //                         false,
                                                                  //                         builder:
                                                                  //                             (
                                                                  //                             context) =>
                                                                  //                             ContentDialog(
                                                                  //                               content: '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider
                                                                  //                                   .meezaCard
                                                                  //                                   .transaction
                                                                  //                                   .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',                                                                                              callback: () {
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
                                                                  //                         msg:
                                                                  //                         'برجاء محاولة الأيداع مرة اخري',
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
                                                                  //                   barrierDismissible:
                                                                  //                   false,
                                                                  //                   builder:
                                                                  //                       (
                                                                  //                       context) =>
                                                                  //                       MsgDialog(
                                                                  //                         content:
                                                                  //                         'سيصلك اشعار على رقم موبايلك المسجل على محفظتك الإلكترونية لأستكمال العملية',
                                                                  //                       ));
                                                                  //               await walletProvider
                                                                  //                   .addCreditWithEWallet(
                                                                  //                 amount:
                                                                  //                 num
                                                                  //                     .parse(
                                                                  //                     value)
                                                                  //                     .toDouble(),
                                                                  //                 method: 'e-wallet',
                                                                  //                 mobileNumber:
                                                                  //                 walletNumber,
                                                                  //               );
                                                                  //               if (walletProvider
                                                                  //                   .state ==
                                                                  //                   NetworkState
                                                                  //                       .SUCCESS) {
                                                                  //                 t =
                                                                  //                     Timer
                                                                  //                         .periodic(
                                                                  //                         Duration(
                                                                  //                             seconds: 5),
                                                                  //                             (
                                                                  //                             timer) async {
                                                                  //                           await walletProvider
                                                                  //                               .checkPaymentStatus(
                                                                  //                               systemReferenceNumber: walletProvider
                                                                  //                                   .eWallet
                                                                  //                                   .transaction
                                                                  //                                   .details
                                                                  //                                   .upgSystemRef,
                                                                  //                               transactionId: walletProvider
                                                                  //                                   .eWallet
                                                                  //                                   .transaction
                                                                  //                                   .details
                                                                  //                                   .transactionId);
                                                                  //                           if (walletProvider
                                                                  //                               .state ==
                                                                  //                               NetworkState
                                                                  //                                   .SUCCESS) {
                                                                  //                             if (walletProvider
                                                                  //                                 .creditStatus
                                                                  //                                 .status ==
                                                                  //                                 'completed') {
                                                                  //                               if (t
                                                                  //                                   .isActive) {
                                                                  //                                 t
                                                                  //                                     .cancel();
                                                                  //                                 t =
                                                                  //                                 null;
                                                                  //                               }
                                                                  //                               Navigator
                                                                  //                                   .pop(
                                                                  //                                   Preferences
                                                                  //                                       .instance
                                                                  //                                       .navigator
                                                                  //                                       .currentContext);
                                                                  //                               showDialog(
                                                                  //                                   context: Preferences
                                                                  //                                       .instance
                                                                  //                                       .navigator
                                                                  //                                       .currentContext,
                                                                  //                                   barrierDismissible: false,
                                                                  //                                   builder: (
                                                                  //                                       context) =>
                                                                  //                                       ContentDialog(
                                                                  //                                         content: '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider
                                                                  //                                             .eWallet
                                                                  //                                             .transaction
                                                                  //                                             .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
                                                                  //                                         callback: () {
                                                                  //                                           Navigator
                                                                  //                                               .pop(
                                                                  //                                               Preferences
                                                                  //                                                   .instance
                                                                  //                                                   .navigator
                                                                  //                                                   .currentContext);
                                                                  //                                           walletProvider
                                                                  //                                               .setDepositIndex(
                                                                  //                                               5);
                                                                  //                                           walletProvider
                                                                  //                                               .setAccountTypeIndex(
                                                                  //                                               null);
                                                                  //                                         },
                                                                  //                                       ));
                                                                  //                             }
                                                                  //                           }
                                                                  //                         });
                                                                  //               }
                                                                  //               else
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
                                                                  //                         msg:
                                                                  //                         'حدث خطأ برحاء المحاولة مرة اخري',
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
                                                              ApplyConfirmationDialog(
                                                                onOkPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      c);
                                                                },
                                                                isDone: false,
                                                              ));
                                                    }
                                                  }
                                                },
                                                shipmentId:
                                                    data.shipmentById!.id!,
                                                amount: data
                                                    .shipmentById!.amount
                                                    .toString(),
                                                shippingCost: data.shipmentById!
                                                    .expectedShippingCost
                                                    .toString(),
                                              ));
                                      // }else{
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (cx) => ActionDialog(
                                      //       content:
                                      //       'يمكنك التقديم علي الشحنات من ١٠ صباحاً حتي ١٠ مساءاً',
                                      //       onApproveClick: () {
                                      //         Navigator.pop(cx);
                                      //       },
                                      //       approveAction: 'حسناً',
                                      //     ));}
                                    },
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                      ),
                                      padding:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(
                                          12.0,
                                        ),
                                      ),
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              weevoPrimaryOrangeColor),
                                    ),
                                    icon: Image.asset(
                                      'assets/images/deliver_shipment_icon.png',
                                      height: 30.0,
                                      width: 30.0,
                                    ),
                                    label: const Text(
                                      'وصل الشحنة',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      strutStyle: StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                  ),
                                )
                              : data.shipmentById!.status == 'available' &&
                                      data.shipmentById!.isOfferBased == 1 &&
                                      data.shipmentById!.parentId == 0
                                  ? Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                InsideOfferDialog(
                                              onShippingCostPressed: (String v,
                                                  String shippingCost,
                                                  String shippingAmount) {
                                                log('onShippingCostPressed -> $v');
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
                                                              await data.getShipmentById(
                                                                  id: data
                                                                      .shipmentById!
                                                                      .id!,
                                                                  isFirstTime:
                                                                      false);
                                                              await WeevoCaptain
                                                                  .facebookAppEvents
                                                                  .logInitiatedCheckout(
                                                                      totalPrice: num.parse(data
                                                                              .shipmentById!
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
                                                                      .doc(data
                                                                          .shipmentById!
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
                                                                  .doc(data
                                                                      .shipmentById!
                                                                      .merchantId
                                                                      .toString())
                                                                  .collection(data
                                                                      .shipmentById!
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
                                                                        shipmentId: data
                                                                            .shipmentById!
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
                                                                  data: ShipmentTrackingModel(shipmentId: data.shipmentById!.id, hasChildren: 1).toJson(),
                                                                  screenTo: 'shipment_screen',
                                                                  type: 'cancel_shipment');
                                                            },
                                                            isDone: true,
                                                            isOffer: true,
                                                          ));
                                                } else {
                                                  if (shipmentProvider
                                                          .noCredit ??
                                                      false) {
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
                                                                    walletProvider.setDepositAmount(num.parse(data
                                                                            .bulkShipmentById!
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

                                                                    // Navigator.pop(
                                                                    //     c);
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
                                                                    //               data
                                                                    //                   .shipmentById
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
                                                                    //                                   .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',                                                                                            callback: () {
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
                                                          .updateOffer ??
                                                      false) {
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
                                                                                                    data.shipmentById!.merchantId.toString(),
                                                                                                  )
                                                                                                  .get();
                                                                                              String token = userToken['fcmToken'];
                                                                                              FirebaseFirestore.instance.collection('merchant_notifications').doc(data.shipmentById!.merchantId.toString()).collection(data.shipmentById!.merchantId.toString()).add({
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
                                                                                                  receivingState: data.shipmentById!.receivingState,
                                                                                                  receivingCity: null,
                                                                                                  deliveryState: data.shipmentById!.deliveringState,
                                                                                                  deliveryCity: null,
                                                                                                  totalShipmentCost: data.shipmentById!.amount,
                                                                                                  shipmentId: data.shipmentById!.id,
                                                                                                  merchantImage: data.shipmentById!.merchant!.photo,
                                                                                                  merchantName: data.shipmentById!.merchant!.name,
                                                                                                  childrenShipment: 0,
                                                                                                  shippingCost: data.shipmentById!.expectedShippingCost,
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
                                                                                                    receivingState: data.shipmentById!.receivingState,
                                                                                                    receivingCity: null,
                                                                                                    deliveryState: data.shipmentById!.deliveringState,
                                                                                                    deliveryCity: null,
                                                                                                    totalShipmentCost: data.shipmentById!.amount,
                                                                                                    shipmentId: data.shipmentById!.id,
                                                                                                    merchantImage: data.shipmentById!.merchant!.photo,
                                                                                                    merchantName: data.shipmentById!.merchant!.name,
                                                                                                    childrenShipment: 0,
                                                                                                    shippingCost: data.shipmentById!.expectedShippingCost,
                                                                                                  ).toMap());
                                                                                            },
                                                                                            isDone: true,
                                                                                          ));
                                                                                } else {
                                                                                  if (authProvider.betterOfferIsBiggerThanLastOne) {
                                                                                    showDialog(
                                                                                        context: ct,
                                                                                        builder: (cx) => ActionDialog(
                                                                                              content: authProvider.betterOfferMessage,
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
                                                                                receivingState: data.shipmentById!.receivingState,
                                                                                receivingCity: null,
                                                                                deliveryState: data.shipmentById!.deliveringState,
                                                                                deliveryCity: null,
                                                                                shipmentId: data.shipmentById!.id,
                                                                                offerId: authProvider.offerId,
                                                                                totalShipmentCost: data.shipmentById!.amount,
                                                                                merchantImage: data.shipmentById!.merchant!.photo,
                                                                                merchantName: data.shipmentById!.merchant!.name,
                                                                                childrenShipment: 0,
                                                                                shippingCost: data.shipmentById!.expectedShippingCost,
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
                                                                        .doc(data
                                                                            .shipmentById!
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
                                                                    .doc(data
                                                                        .shipmentById!
                                                                        .merchantId
                                                                        .toString())
                                                                    .collection(data
                                                                        .shipmentById!
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
                                                                    receivingState: data
                                                                        .shipmentById!
                                                                        .receivingState,
                                                                    receivingCity:
                                                                        null,
                                                                    deliveryState: data
                                                                        .shipmentById!
                                                                        .deliveringState,
                                                                    deliveryCity:
                                                                        null,
                                                                    totalShipmentCost: data
                                                                        .shipmentById!
                                                                        .amount,
                                                                    shipmentId: data
                                                                        .shipmentById!
                                                                        .id,
                                                                    merchantImage: data
                                                                        .shipmentById!
                                                                        .merchant!
                                                                        .photo,
                                                                    merchantName: data
                                                                        .shipmentById!
                                                                        .merchant!
                                                                        .name,
                                                                    childrenShipment:
                                                                        0,
                                                                    shippingCost: data
                                                                        .shipmentById!
                                                                        .expectedShippingCost,
                                                                  ).toMap(),
                                                                });
                                                                authProvider.sendNotification(
                                                                    title: 'عرض جديد',
                                                                    body: 'تم تقديم عرض جديد من الكابتن ${authProvider.name}',
                                                                    toToken: token,
                                                                    image: authProvider.photo!.isNotEmpty
                                                                        ? authProvider.photo!.contains(ApiConstants.baseUrl)
                                                                            ? authProvider.photo
                                                                            : '${ApiConstants.baseUrl}${authProvider.photo}'
                                                                        : '',
                                                                    type: '',
                                                                    screenTo: 'shipment_offers',
                                                                    data: ShipmentNotification(receivingState: data.shipmentById!.receivingState, receivingCity: null, deliveryState: data.shipmentById!.deliveringState, deliveryCity: null, shipmentId: data.shipmentById!.id, merchantImage: data.shipmentById!.merchant!.photo, merchantName: data.shipmentById!.merchant!.name, childrenShipment: 0, shippingCost: data.shipmentById!.expectedShippingCost, totalShipmentCost: data.shipmentById!.amount).toMap());
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
                                                                    walletProvider.setDepositAmount(num.parse(data
                                                                            .bulkShipmentById!
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

                                                                    // Navigator.pop(
                                                                    //     c);
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
                                                                    //               data
                                                                    //                   .shipmentById
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
                                                                    //                                   .amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',                                                                                            callback: () {
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
                                              shipmentNotification:
                                                  ShipmentNotification(
                                                shipmentId:
                                                    data.shipmentById!.id,
                                                shippingCost: data.shipmentById!
                                                    .expectedShippingCost
                                                    .toString(),
                                                totalShipmentCost:
                                                    data.shipmentById!.amount,
                                                merchantImage: data
                                                    .shipmentById!
                                                    .merchant!
                                                    .photo,
                                                flags: data.shipmentById!.flags,
                                                merchantName: data.shipmentById!
                                                    .merchant!.name,
                                                childrenShipment: 0,
                                              ),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                12.0,
                                              ),
                                            ),
                                          ),
                                          padding: WidgetStateProperty.all<
                                              EdgeInsets>(
                                            const EdgeInsets.all(
                                              12.0,
                                            ),
                                          ),
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  weevoPrimaryOrangeColor),
                                        ),
                                        icon: Container(height: 30.0),
                                        label: const Text(
                                          'تقديم عرض',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                          strutStyle: StrutStyle(
                                            forceStrutHeight: true,
                                          ),
                                        ),
                                      ),
                                    )
                                  : (((data.shipmentById!.status ==
                                                      'merchant-accepted-shipping-offer' ||
                                                  data.shipmentById!.status ==
                                                      'on-the-way-to-get-shipment-from-merchant' ||
                                                  data.shipmentById!.status ==
                                                      'courier-applied-to-shipment' ||
                                                  data.shipmentById!.status ==
                                                      'on-delivery') &&
                                              data.shipmentById!.courierId ==
                                                  int.parse(Preferences
                                                      .instance.getUserId) &&
                                              data.shipmentById!.parentId ==
                                                  0) ||
                                          (data.shipmentById!.status ==
                                                  'on-delivery' &&
                                              data.shipmentById!.courierId ==
                                                  int.parse(Preferences
                                                      .instance.getUserId) &&
                                              data.shipmentById!.parentId! > 0))
                                      ? Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) =>
                                                      const Loading());
                                              await data.getShipmentById(
                                                id: data.shipmentById!.id!,
                                                isFirstTime: false,
                                              );

                                              if (data.shipmentById!.status == 'delivered' ||
                                                  data.shipmentById!.status ==
                                                      'cancelled' ||
                                                  data.shipmentById!.status ==
                                                      'bulk-shipment-closed' ||
                                                  data.shipmentById!.status ==
                                                      'returned') {
                                                MagicRouter.pop();
                                                return;
                                              }
                                              MagicRouter.pop();
                                              MagicRouter.navigateTo(
                                                HandleShipment(
                                                  model: ShipmentTrackingModel(
                                                    merchantRating: data
                                                        .shipmentById!
                                                        .merchant
                                                        ?.cachedAverageRating,
                                                    merchantNationalId: data
                                                        .shipmentById
                                                        ?.merchant
                                                        ?.phone,
                                                    courierNationalId:
                                                        authProvider
                                                            .getNationalId,
                                                    shipmentId:
                                                        data.shipmentById?.id,
                                                    deliveringState: data
                                                        .shipmentById
                                                        ?.deliveringState,
                                                    status: data
                                                        .shipmentById?.status,
                                                    hasChildren: data
                                                                .shipmentById!
                                                                .parentId ==
                                                            0
                                                        ? 0
                                                        : 1,
                                                    deliveringCity: data
                                                        .shipmentById
                                                        ?.deliveringCity,
                                                    receivingState: data
                                                        .shipmentById
                                                        ?.receivingState,
                                                    receivingStreet: data
                                                        .shipmentById
                                                        ?.receivingStreet,
                                                    receivingApartment: data
                                                        .shipmentById
                                                        ?.receivingApartment,
                                                    receivingBuildingNumber: data
                                                        .shipmentById
                                                        ?.receivingBuildingNumber,
                                                    receivingFloor: data
                                                        .shipmentById
                                                        ?.receivingFloor,
                                                    receivingLandmark: data
                                                        .shipmentById!
                                                        .receivingLandmark,
                                                    receivingLat: data
                                                        .shipmentById!
                                                        .receivingLat,
                                                    receivingLng: data
                                                        .shipmentById!
                                                        .receivingLng,
                                                    clientPhone: data
                                                        .shipmentById!
                                                        .clientPhone,
                                                    receivingCity: data
                                                        .shipmentById!
                                                        .receivingCity,
                                                    paymentMethod: data
                                                        .shipmentById!
                                                        .paymentMethod,
                                                    deliveringLat: data
                                                        .shipmentById!
                                                        .deliveringLat,
                                                    deliveringLng: data
                                                        .shipmentById!
                                                        .deliveringLng,
                                                    fromLat: authProvider
                                                        .locationData?.latitude,
                                                    fromLng: authProvider
                                                        .locationData
                                                        ?.longitude,
                                                    merchantId: data
                                                        .shipmentById!
                                                        .merchantId,
                                                    courierId: data
                                                        .shipmentById!
                                                        .courierId,
                                                    merchantImage: data
                                                        .shipmentById!
                                                        .merchant!
                                                        .photo,
                                                    merchantName: data
                                                        .shipmentById!
                                                        .merchant!
                                                        .name,
                                                    merchantPhone: data
                                                        .shipmentById!
                                                        .merchant!
                                                        .phone,
                                                    courierName:
                                                        authProvider.name,
                                                    courierImage:
                                                        authProvider.photo,
                                                    courierPhone:
                                                        authProvider.phone,
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ButtonStyle(
                                              shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    12.0,
                                                  ),
                                                ),
                                              ),
                                              padding: WidgetStateProperty.all<
                                                  EdgeInsets>(
                                                const EdgeInsets.all(
                                                  12.0,
                                                ),
                                              ),
                                              backgroundColor:
                                                  WidgetStateProperty.all<
                                                          Color>(
                                                      weevoPrimaryOrangeColor),
                                            ),
                                            icon: Container(height: 30.0),
                                            label: Text(
                                              (data.shipmentById!.status ==
                                                      'on-the-way-to-get-shipment-from-merchant')
                                                  ? 'توجه للإستلام'
                                                  : (data.shipmentById!
                                                              .status ==
                                                          'on-delivery')
                                                      ? 'توجه للتسليم'
                                                      : 'إبدأ التوصيل',
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                              strutStyle: const StrutStyle(
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                          (data.shipmentById!.status ==
                                          'merchant-accepted-shipping-offer' ||
                                      data.shipmentById!.status ==
                                          'courier-applied-to-shipment' ||
                                      data.shipmentById!.status ==
                                          'on-the-way-to-get-shipment-from-merchant') &&
                                  data.shipmentById!.parentId == 0 &&
                                  data.shipmentById!.courierId ==
                                      int.parse(Preferences.instance.getUserId)
                              ? const SizedBox(width: 10)
                              : Container(),
                          (data.shipmentById!.status ==
                                          'merchant-accepted-shipping-offer' ||
                                      data.shipmentById!.status ==
                                          'courier-applied-to-shipment' ||
                                      data.shipmentById!.status ==
                                          'on-the-way-to-get-shipment-from-merchant') &&
                                  data.shipmentById!.parentId == 0 &&
                                  data.shipmentById!.courierId ==
                                      int.parse(Preferences.instance.getUserId)
                              ? Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      if (await authProvider
                                          .checkConnection()) {
                                        await cancelShippingCallback(
                                            data, authProvider);
                                      } else {
                                        showDialog(
                                          context: navigator.currentContext!,
                                          builder: (ctx) => ActionDialog(
                                            content:
                                                'تأكد من الاتصال بشبكة الانترنت',
                                            cancelAction: 'حسناً',
                                            approveAction: 'حاول مرة اخري',
                                            onApproveClick: () async {
                                              Navigator.pop(context);
                                              await cancelShippingCallback(
                                                  data, authProvider);
                                            },
                                            onCancelClick: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      }
                                    },
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                      ),
                                      padding:
                                          WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.all(
                                          12.0,
                                        ),
                                      ),
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              Colors.red),
                                    ),
                                    icon: Container(height: 30.0),
                                    label: const Text(
                                      'الغاء التوصيل',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      strutStyle: StrutStyle(
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> cancelShippingCallback(
      ShipmentProvider data, AuthProvider authProvider) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => CancelShipmentDialog(onOkPressed: () async {
              Navigator.pop(ctx);
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Loading());
              await data.cancelShipping(data.shipmentById!.id!);
              check(
                  auth: authProvider,
                  ctx: navigator.currentContext!,
                  state: data.cancelShippingState!);
              if (data.cancelShippingState == NetworkState.success) {
                Navigator.pop(navigator.currentContext!);
                await showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (context) => ActionDialog(
                          content: data.cancelMessage,
                          onApproveClick: () {
                            Navigator.pop(context);
                          },
                          approveAction: 'حسناً',
                        ));
                showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (context) => const Loading());

                DocumentSnapshot userToken = await FirebaseFirestore.instance
                    .collection('merchant_users')
                    .doc(data.shipmentById!.merchantId.toString())
                    .get();
                String token = userToken['fcmToken'];
                FirebaseFirestore.instance
                    .collection('merchant_notifications')
                    .doc(data.shipmentById!.merchantId.toString())
                    .collection(data.shipmentById!.merchantId.toString())
                    .add({
                  'read': false,
                  'date_time': DateTime.now().toIso8601String(),
                  'type': 'cancel_shipment',
                  'title': 'تم إلغاء الشحن',
                  'body':
                      'قام الكابتن ${authProvider.name} بالغاء الشحنة يمكنك الذهاب للشحنة في الشحنات المتاحة',
                  'user_icon': authProvider.photo!.isNotEmpty
                      ? authProvider.photo!.contains(ApiConstants.baseUrl)
                          ? authProvider.photo
                          : '${ApiConstants.baseUrl}${authProvider.photo}'
                      : '',
                  'screen_to': 'shipment_screen',
                  'data': {
                    'has_children': 0,
                    'shipment_id': data.shipmentById!.id,
                  },
                });
                await Provider.of<AuthProvider>(navigator.currentContext!,
                        listen: false)
                    .sendNotification(
                        title: 'تم إلغاء الشحن',
                        body:
                            'قام الكابتن ${authProvider.name} بالغاء الشحنة يمكنك الذهاب للشحنة في الشحنات المتاحة',
                        toToken: token,
                        image: authProvider.photo!.isNotEmpty
                            ? authProvider.photo!.contains(ApiConstants.baseUrl)
                                ? authProvider.photo
                                : '${ApiConstants.baseUrl}${authProvider.photo}'
                            : '',
                        data: {
                          'has_children': 0,
                          'shipment_id': data.shipmentById!.id,
                        },
                        screenTo: 'shipment_screen',
                        type: 'cancel_shipment');

                String courierPhoneNumber = Preferences.instance.getPhoneNumber;
                String merchantPhoneNumber =
                    data.shipmentById!.merchant!.phone!;
                String locationId =
                    '$courierPhoneNumber-$merchantPhoneNumber-${data.shipmentById!.id}';
                FirebaseFirestore.instance
                    .collection('locations')
                    .doc(locationId)
                    .set(
                  {'status': 'closed'},
                );
                Navigator.pop(navigator.currentContext!);
                Navigator.pop(navigator.currentContext!);
              } else if (data.cancelShippingState == NetworkState.error) {
                Navigator.pop(navigator.currentContext!);
                showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (context) => ActionDialog(
                          content: 'حدث خطأ من فضلك حاول مرة اخري',
                          cancelAction: 'حسناً',
                          onCancelClick: () {
                            Navigator.pop(context);
                          },
                        ));
              }
            }, onCancelPressed: () {
              Navigator.pop(context);
            }));
  }

  Future<void> getMezaStatus(
      {required WalletProvider walletProvider,
      required AuthProvider authProvider,
      required String value}) async {
    log(value);
    log('${walletProvider.meezaCard!.transaction!.id}');
    Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      log('t');
      await walletProvider.checkPaymentStatus(
          systemReferenceNumber: value,
          transactionId: walletProvider.meezaCard!.transaction!.id!);
      if (walletProvider.state == NetworkState.success) {
        log('success');
        if (walletProvider.creditStatus!.status == 'completed') {
          log('status compeleted');
          if (t.isActive) {
            t.cancel();
            log('timer cancelled');
          }
          log(walletProvider.creditStatus!.status!);
          await walletProvider.getCurrentBalance(
              authorization: authProvider.appAuthorization, fromRefresh: false);
          Navigator.pop(navigator.currentContext!);
          showDialog(
              context: navigator.currentContext!,
              barrierDismissible: false,
              builder: (context) => ContentDialog(
                    content:
                        '.لقد تم شحن محفظتك بنجاح بمبلغ ${walletProvider.meezaCard!.transaction!.amount}\nيمكنك الان التقديم على الشحنة مرة اخرى',
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
