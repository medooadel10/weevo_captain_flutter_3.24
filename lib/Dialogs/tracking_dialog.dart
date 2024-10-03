import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/chat_data.dart';
import '../Models/shipment_tracking_model.dart';
import '../Providers/auth_provider.dart';
import '../Screens/chat_screen.dart';
import '../Utilits/colors.dart';
import '../Widgets/weevo_button.dart';
import '../core/helpers/spacing.dart';

class TrackingDialog extends StatelessWidget {
  final ShipmentTrackingModel model;
  final VoidCallback onMyWayCallback;
  final String? status;
  final VoidCallback onCancelShipmentCallback;
  final VoidCallback onReceivingShipmentCallback;
  final VoidCallback onArrivedCallback;
  final VoidCallback onMerchantLocation;
  final VoidCallback onReturnShipmentCallback;
  final VoidCallback onHandOverShipmentCallback;
  final VoidCallback onHandOverReturnedShipmentCallback;
  final VoidCallback onClientLocationCallback;
  final VoidCallback onCLientPhoneCallback;
  final VoidCallback onReceiveShipmentToClientCallback;

  const TrackingDialog({
    super.key,
    required this.model,
    required this.status,
    required this.onMyWayCallback,
    required this.onMerchantLocation,
    required this.onReceivingShipmentCallback,
    required this.onCancelShipmentCallback,
    required this.onArrivedCallback,
    required this.onReturnShipmentCallback,
    required this.onHandOverShipmentCallback,
    required this.onHandOverReturnedShipmentCallback,
    required this.onClientLocationCallback,
    required this.onCLientPhoneCallback,
    required this.onReceiveShipmentToClientCallback,
  });
  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    log('Status is $status');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: model.wasullyModel != null
                ? BorderRadius.circular(0.0)
                : const BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0))),
        elevation: model.wasullyModel != null ? 0.0 : 4.0,
        color: Colors.white,
        margin: const EdgeInsets.all(0.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35.0,
                    backgroundImage: model.merchantImage != null &&
                            model.merchantImage!.isNotEmpty
                        ? NetworkImage(model.merchantImage!)
                        : const AssetImage('assets/images/profile_picture.png'),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.merchantName!,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              model.merchantRating != null
                                  ? double.tryParse(model.merchantRating!)
                                          ?.toStringAsFixed(1) ??
                                      '4.5'
                                  : '4.5',
                              style: const TextStyle(
                                color: weevoPrimaryOrangeColor,
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              color: weevoPrimaryOrangeColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ChatScreen.id,
                              arguments: ChatData(
                                  currentUserImageUrl: authProvider.photo,
                                  currentUserId: authProvider.id,
                                  currentUserName: authProvider.name,
                                  currentUserNationalId:
                                      authProvider.getNationalId,
                                  peerNationalId: model.merchantNationalId,
                                  shipmentId: model.shipmentId,
                                  peerId: model.merchantId.toString(),
                                  peerUserName: model.merchantName,
                                  peerImageUrl: model.merchantImage));
                        },
                        child: const CircleAvatar(
                          backgroundColor: weevoLightPurpleColor,
                          radius: 20.0,
                          child: Icon(
                            Icons.message,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await launchUrl(
                            Uri.parse('tel:${model.merchantPhone}'),
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: weevoLightGreen,
                          radius: 20.0,
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 5.0,
                    backgroundColor: weevoPrimaryOrangeColor,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    child: model.wasullyModel == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authProvider.getStateNameById(
                                        int.parse(model.receivingState!)) ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                authProvider.getCityNameById(
                                      int.parse(model.receivingState!),
                                      int.parse(model.receivingCity!),
                                    ) ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0.sp,
                                ),
                              ),
                              if (model.receivingStreet != null)
                                Text(
                                  model.receivingStreet!,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0.sp,
                                  ),
                                ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.wasullyModel!.receivingStateModel.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                model.wasullyModel!.receivingCityModel.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0.sp,
                                ),
                              ),
                              if (model.deliveringStreet != null)
                                Text(
                                  model.deliveringStreet!,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0.sp,
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 5.0,
                    backgroundColor: weevoPrimaryBlueColor,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    child: model.wasullyModel == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authProvider.getStateNameById(
                                      int.parse(model.deliveringState!),
                                    ) ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                authProvider.getCityNameById(
                                        int.parse(model.deliveringState!),
                                        int.parse(model.deliveringCity!)) ??
                                    '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0.sp,
                                ),
                              ),
                              if (model.receivingStreet != null)
                                Text(
                                  model.receivingStreet!,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.0.sp),
                                ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.wasullyModel!.deliveringStateModel.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                model.wasullyModel!.deliveringCityModel.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0.sp,
                                ),
                              ),
                              if (model.receivingStreet != null)
                                Text(
                                  model.receivingStreet!,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14.0.sp),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
              if (model.wasullyModel != null) ...[
                verticalSpace(20),
                Row(
                  children: [
                    Text(
                      'سيتم تحصيل رسوم التوصيل من',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    horizontalSpace(4),
                    Expanded(
                      child: Text(
                        model.wasullyModel?.whoPay == 'me'
                            ? 'المرسل'
                            : 'المستلم',
                        style: TextStyle(
                          color: weevoPrimaryOrangeColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(
                height: 16.h,
              ),
              status == '' || status == null
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: WeevoButton(
                                onTap: onMyWayCallback,
                                title: 'في الطريق',
                                color: weevoPrimaryOrangeColor,
                                isStable: true,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Expanded(
                              child: WeevoButton(
                                onTap: onCancelShipmentCallback,
                                title: model.wasullyModel != null
                                    ? 'إلغاء الطلب'
                                    : 'إلغاء الشحنة',
                                color: weevoPrimaryBlueColor,
                                isStable: true,
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(10),
                        SizedBox(
                          width: double.infinity,
                          child: WeevoButton(
                            onTap: onMerchantLocation,
                            title: model.wasullyModel != null
                                ? 'لوكيشن المرسل'
                                : 'لوكيشن التاجر',
                            color: weevoGoldYellow,
                            isStable: true,
                          ),
                        ),
                      ],
                    )
                  : status == 'inMyWay' ||
                          status == 'arrived' ||
                          status == 'receivingShipment'
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: WeevoButton(
                                    onTap: onReceivingShipmentCallback,
                                    title: model.wasullyModel != null
                                        ? 'إستلام الطلب'
                                        : 'إستلام الشحنة',
                                    color: weevoPrimaryOrangeColor,
                                    isStable: true,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Expanded(
                                  child: WeevoButton(
                                    onTap: onArrivedCallback,
                                    title: 'وصلت',
                                    color: weevoPrimaryBlueColor,
                                    isStable: true,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: WeevoButton(
                                    onTap: onMerchantLocation,
                                    title: model.wasullyModel != null
                                        ? 'لوكيشن المرسل'
                                        : 'لوكيشن التاجر',
                                    color: weevoGoldYellow,
                                    isStable: true,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Expanded(
                                  child: WeevoButton(
                                    onTap: onCancelShipmentCallback,
                                    title: model.wasullyModel != null
                                        ? 'إلغاء الطلب'
                                        : 'إلغاء الشحن',
                                    color: weevoDarkGrey,
                                    isStable: true,
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      : status == 'receivedShipment' ||
                              status == 'handingOverShipmentToCustomer'
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: WeevoButton(
                                        onTap: onHandOverShipmentCallback,
                                        title: model.wasullyModel != null
                                            ? 'تسليم الطلب'
                                            : 'تسليم الشحنة',
                                        color: weevoPrimaryOrangeColor,
                                        isStable: true,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Expanded(
                                      child: WeevoButton(
                                        onTap: onReturnShipmentCallback,
                                        title: 'مرتجع',
                                        color: weevoPrimaryBlueColor,
                                        isStable: true,
                                      ),
                                    )
                                  ],
                                ),
                                verticalSpace(10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: WeevoButton(
                                        onTap: onClientLocationCallback,
                                        title: model.wasullyModel != null
                                            ? 'لوكيشن المرسل اليه'
                                            : 'لوكيشن العميل',
                                        color: weevoGoldYellow,
                                        isStable: true,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Expanded(
                                      child: WeevoButton(
                                        onTap: onCLientPhoneCallback,
                                        title: model.wasullyModel != null
                                            ? 'رقم المرسل اليه'
                                            : 'رقم العميل',
                                        color: weevoDarkGrey,
                                        isStable: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : status == 'returnShipment'
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: WeevoButton(
                                            onTap:
                                                onHandOverReturnedShipmentCallback,
                                            title: 'تسليم المرتجع',
                                            color: weevoPrimaryOrangeColor,
                                            isStable: true,
                                          ),
                                        ),
                                        horizontalSpace(10),
                                        Expanded(
                                          child: WeevoButton(
                                            onTap: onMerchantLocation,
                                            title: model.wasullyModel != null
                                                ? 'لوكيشن المرسل'
                                                : 'لوكيشن التاجر',
                                            color: weevoPrimaryBlueColor,
                                            isStable: true,
                                          ),
                                        )
                                      ],
                                    ),
                                    verticalSpace(10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: WeevoButton(
                                        onTap:
                                            onReceiveShipmentToClientCallback,
                                        title: model.wasullyModel != null
                                            ? 'إعادة توصيل الطلب الي المرسل اليه'
                                            : 'إعادة توصيل الطلب الي العميل',
                                        color: weevoGoldYellow,
                                        isStable: true,
                                      ),
                                    ),
                                  ],
                                )
                              : status ==
                                      'handingOverReturnedShipmentToMerchant'
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: WeevoButton(
                                        onTap:
                                            onReceiveShipmentToClientCallback,
                                        title: model.wasullyModel != null
                                            ? 'إعادة توصيل الطلب الي المرسل اليه'
                                            : 'إعادة توصيل الطلب الي العميل',
                                        color: weevoPrimaryOrangeColor,
                                        isStable: true,
                                      ),
                                    )
                                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
