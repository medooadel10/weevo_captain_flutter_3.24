import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../Models/shipment_notification.dart';
import '../Providers/auth_provider.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/edit_text.dart';
import '../core/networking/api_constants.dart';

class UpdateOfferDialog extends StatefulWidget {
  final Function onBetterShippingOfferPressed;
  final ShipmentNotification shipmentNotification;

  const UpdateOfferDialog({
    super.key,
    required this.onBetterShippingOfferPressed,
    required this.shipmentNotification,
  });

  @override
  State<UpdateOfferDialog> createState() => _UpdateOfferDialogState();
}

class _UpdateOfferDialogState extends State<UpdateOfferDialog> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late TextEditingController myOfferController;

  @override
  void initState() {
    super.initState();
    myOfferController = TextEditingController();
  }

  @override
  void dispose() {
    myOfferController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: authProvider.networkState == NetworkState.waiting
            ? const EdgeInsets.all(
                100,
              )
            : EdgeInsets.symmetric(
                horizontal: 20.0.w,
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            authProvider.networkState == NetworkState.waiting ? 50.0 : 20.0,
          ),
          child: authProvider.networkState == NetworkState.waiting
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            weevoPrimaryOrangeColor),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        widget.shipmentNotification.childrenShipment! > 0
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: weevoPrimaryOrangeColor,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(14.0.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w,
                                  vertical: 5.0.h,
                                ),
                                child: Text(
                                  '${widget.shipmentNotification.childrenShipment}شحنات ',
                                  style: const TextStyle(
                                    color: weevoPrimaryOrangeColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              )
                            : Container(),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.shipmentNotification.merchantName!,
                                style: const TextStyle(
                                  color: weevoBlack,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text('3.6'),
                                      Icon(
                                        Icons.star_border,
                                        color: weevoPrimaryOrangeColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10.0.w,
                        ),
                        widget.shipmentNotification.merchantImage == null ||
                                widget
                                    .shipmentNotification.merchantImage!.isEmpty
                            ? const CircleAvatar(
                                radius: 30.0,
                                backgroundImage: AssetImage(
                                  'assets/images/profile_picture.png',
                                ),
                              )
                            : CircleAvatar(
                                radius: 30.0,
                                backgroundImage: NetworkImage(
                                  '${ApiConstants.baseUrl}${widget.shipmentNotification.merchantImage}',
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      'قدم عرض أفضل',
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //         int offer = (num.parse(widget
                    //                         .shipmentNotification.shippingCost)
                    //                     .toDouble() -
                    //                 num.parse(widget.shipmentNotification
                    //                             .shippingCost)
                    //                         .toDouble() *
                    //                     0.1)
                    //             .toInt();
                    //         await authProvider.updateShipmentOffer(
                    //             offerId: widget.shipmentNotification.offerId,
                    //             offer: offer);
                    //         check(
                    //             auth: authProvider,
                    //             ctx: context,
                    //             state: authProvider.networkState);
                    //         if (authProvider.networkState ==
                    //             NetworkState.SUCCESS) {
                    //           Navigator.pop(context);
                    //           widget.onBetterShippingOfferPressed(
                    //               'DONE',
                    //               offer,
                    //               widget
                    //                   .shipmentNotification.totalShipmentCost);
                    //         } else if (authProvider.networkState ==
                    //             NetworkState.ERROR) {
                    //           Navigator.pop(context);
                    //           widget.onBetterShippingOfferPressed(
                    //               'ERROR',
                    //               offer,
                    //               widget
                    //                   .shipmentNotification.totalShipmentCost);
                    //         }
                    //       },
                    //       child: Text(
                    //         '${(num.parse(widget.shipmentNotification.shippingCost).toDouble() - num.parse(widget.shipmentNotification.shippingCost).toDouble() * 0.1).toInt()} جنية',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500, fontSize: 12.0.sp),
                    //       ),
                    //       style: ButtonStyle(
                    //         backgroundColor: MaterialStateProperty.all<Color>(
                    //           weevoPrimaryOrangeColor,
                    //         ),
                    //         padding: MaterialStateProperty.all<EdgeInsets>(
                    //             EdgeInsets.all(
                    //           20.0,
                    //         )),
                    //         shape: MaterialStateProperty.all<
                    //             RoundedRectangleBorder>(
                    //           RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(17.0.r),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 5.w,
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //         int offer = (num.parse(widget.shipmentNotification
                    //                             .shippingCost)
                    //                         .toDouble() *
                    //                     0.1 +
                    //                 num.parse(widget
                    //                         .shipmentNotification.shippingCost)
                    //                     .toDouble())
                    //             .toInt();
                    //         await authProvider.updateShipmentOffer(
                    //             offerId: widget.shipmentNotification.offerId,
                    //             offer: offer);
                    //         check(
                    //             auth: authProvider,
                    //             ctx: context,
                    //             state: authProvider.networkState);
                    //         if (authProvider.networkState ==
                    //             NetworkState.SUCCESS) {
                    //           Navigator.pop(context);
                    //           widget.onBetterShippingOfferPressed(
                    //               'DONE',
                    //               offer,
                    //               widget
                    //                   .shipmentNotification.totalShipmentCost);
                    //         } else if (authProvider.networkState ==
                    //             NetworkState.ERROR) {
                    //           Navigator.pop(context);
                    //           widget.onBetterShippingOfferPressed(
                    //               'ERROR',
                    //               offer,
                    //               widget
                    //                   .shipmentNotification.totalShipmentCost);
                    //         }
                    //       },
                    //       child: Text(
                    //         '${(num.parse(widget.shipmentNotification.shippingCost).toDouble() * 0.1 + num.parse(widget.shipmentNotification.shippingCost).toDouble()).toInt()} جنية',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500, fontSize: 12.0.sp),
                    //       ),
                    //       style: ButtonStyle(
                    //         backgroundColor: MaterialStateProperty.all<Color>(
                    //           weevoPrimaryOrangeColor,
                    //         ),
                    //         padding: MaterialStateProperty.all<EdgeInsets>(
                    //             EdgeInsets.all(
                    //           20.0,
                    //         )),
                    //         shape: MaterialStateProperty.all<
                    //             RoundedRectangleBorder>(
                    //           RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(17.0.r),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 5.w,
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //         int offer = (num.parse(widget.shipmentNotification
                    //                             .shippingCost)
                    //                         .toDouble() *
                    //                     0.2 +
                    //                 num.parse(widget
                    //                         .shipmentNotification.shippingCost)
                    //                     .toDouble())
                    //             .toInt();
                    //         await authProvider.updateShipmentOffer(
                    //             offerId: widget.shipmentNotification.offerId,
                    //             offer: offer);
                    //         check(
                    //             auth: authProvider,
                    //             ctx: context,
                    //             state: authProvider.networkState);
                    //         if (authProvider.networkState ==
                    //             NetworkState.SUCCESS) {
                    //           Navigator.pop(context);
                    //           widget.onBetterShippingOfferPressed(
                    //               'DONE',
                    //               offer,
                    //               widget
                    //                   .shipmentNotification.totalShipmentCost);
                    //         } else if (authProvider.networkState ==
                    //             NetworkState.ERROR) {
                    //           Navigator.pop(context);
                    //           widget.onBetterShippingOfferPressed(
                    //               'ERROR',
                    //               offer,
                    //               widget
                    //                   .shipmentNotification.totalShipmentCost);
                    //         }
                    //       },
                    //       child: Text(
                    //         '${(num.parse(widget.shipmentNotification.shippingCost).toDouble() * 0.2 + num.parse(widget.shipmentNotification.shippingCost).toDouble()).toInt()} جنية',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500, fontSize: 12.0.sp),
                    //       ),
                    //       style: ButtonStyle(
                    //         backgroundColor: MaterialStateProperty.all<Color>(
                    //           weevoPrimaryOrangeColor,
                    //         ),
                    //         padding: MaterialStateProperty.all<EdgeInsets>(
                    //             EdgeInsets.all(
                    //           20.0,
                    //         )),
                    //         shape: MaterialStateProperty.all<
                    //             RoundedRectangleBorder>(
                    //           RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(17.0.r),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Form(
                      key: formState,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          EditText(
                            controller: myOfferController,
                            readOnly: false,
                            upperTitle: false,
                            type: TextInputType.number,
                            action: TextInputAction.done,
                            isPhoneNumber: false,
                            isPassword: false,
                            validator: (String? output) =>
                                output == null || output.isEmpty
                                    ? 'من فضلك أدخل عرض التوصيل الخاص بك'
                                    : num.parse(output) <= 0
                                        ? 'من فضلك أدخل عرض توصيل صحيح'
                                        : '',
                            labelText: 'عرض التوصيل الخاص بك',
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (formState.currentState!.validate()) {
                                int offer =
                                    num.parse(myOfferController.text).toInt();
                                await authProvider.updateShipmentOffer(
                                    offerId:
                                        widget.shipmentNotification.offerId,
                                    offer: offer);
                                check(
                                    auth: authProvider,
                                    ctx: navigator.currentContext!,
                                    state: authProvider.networkState!);
                                if (authProvider.networkState ==
                                    NetworkState.success) {
                                  Navigator.pop(navigator.currentContext!);
                                  widget.onBetterShippingOfferPressed(
                                      'DONE',
                                      offer,
                                      widget.shipmentNotification
                                          .totalShipmentCost);
                                } else if (authProvider.networkState ==
                                    NetworkState.error) {
                                  Navigator.pop(navigator.currentContext!);
                                  widget.onBetterShippingOfferPressed(
                                      'ERROR',
                                      offer,
                                      widget.shipmentNotification
                                          .totalShipmentCost);
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                weevoPrimaryBlueColor,
                              ),
                              padding: WidgetStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 30.0)),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17.0.r),
                                ),
                              ),
                            ),
                            child: Text(
                              'ارسال عرض التوصيل الخاص بك',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
