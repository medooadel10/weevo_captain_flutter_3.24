import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Models/shipment_offer_data.dart';
import '../Providers/auth_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../core/widgets/custom_image.dart';

class ShipmentOfferItem extends StatefulWidget {
  final ShipmentOfferData shipmentOfferData;
  final VoidCallback onItemPressed;
  final VoidCallback onDeclineOfferCallback;

  const ShipmentOfferItem({
    super.key,
    required this.shipmentOfferData,
    required this.onItemPressed,
    required this.onDeclineOfferCallback,
  });

  @override
  State<ShipmentOfferItem> createState() => _ShipmentOfferItemState();
}

class _ShipmentOfferItemState extends State<ShipmentOfferItem> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    log('ship -> ${widget.shipmentOfferData.shipment!.products!.length}');
    return GestureDetector(
      onTap: widget.onItemPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6.0),
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CustomImage(
                    image:
                        widget.shipmentOfferData.shipment!.products!.isNotEmpty
                            ? widget.shipmentOfferData.shipment!.products![0]
                                .productInfo!.image!
                            : '',
                    height: 150.0.h,
                    width: 150.0.h,
                    radius: 30.0.h,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 6.0),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: widget.onDeclineOfferCallback,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        weevoPrimaryOrangeColor,
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 20.0)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'انسحب',
                      style: TextStyle(fontSize: 16.0.sp),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.shipmentOfferData.shipment!.products!
                                        .isNotEmpty
                                    ? widget.shipmentOfferData.shipment!
                                        .products![0].productInfo!.name!
                                    : '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.shipmentOfferData.shipment!.products!
                                        .isNotEmpty
                                    ? widget.shipmentOfferData.shipment!
                                        .products![0].productInfo!.description!
                                    : '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: weevoPrimaryOrangeColor,
                          ),
                          height: 8.h,
                          width: 8.w,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: Text(
                            '${authProvider.getStateNameById(int.parse(widget.shipmentOfferData.shipment!.deliveringState!))} - ${authProvider.getCityNameById(int.parse(widget.shipmentOfferData.shipment!.deliveringState!), int.parse(widget.shipmentOfferData.shipment!.deliveringCity!))}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: const EdgeInsets.only(top: 1),
                            height: 3,
                            width: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1.5),
                              color: index < 3
                                  ? weevoPrimaryOrangeColor
                                  : weevoPrimaryBlueColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: weevoPrimaryBlueColor,
                          ),
                          height: 8.h,
                          width: 8.w,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: Text(
                            '${authProvider.getStateNameById(int.parse(widget.shipmentOfferData.shipment!.receivingState!))} - ${authProvider.getCityNameById(int.parse(widget.shipmentOfferData.shipment!.receivingState!), int.parse(widget.shipmentOfferData.shipment!.receivingCity!))}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xffD8F3FF),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/money_icon.png',
                                  fit: BoxFit.contain,
                                  color: const Color(0xff091147),
                                  height: 20.h,
                                  width: 20.w,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  '${double.parse(widget.shipmentOfferData.shipment!.amount!).toInt()}',
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  'جنية',
                                  style: TextStyle(
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                if (Preferences.instance.getUserFlags ==
                                    'freelance') ...[
                                  Image.asset(
                                    'assets/images/van_icon.png',
                                    fit: BoxFit.contain,
                                    color: const Color(0xff091147),
                                    height: 20.h,
                                    width: 20.w,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    '${double.parse(widget.shipmentOfferData.shipment!.agreedShippingCost ?? widget.shipmentOfferData.shipment!.expectedShippingCost ?? '0').toInt()}',
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Text(
                                    'جنية',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
