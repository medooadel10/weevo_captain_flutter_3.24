import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../Models/shipment_notification.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/edit_text.dart';
import '../core/networking/api_constants.dart';

class OfferDialog extends StatefulWidget {
  final Function onShippingCostPressed;
  final Function onShippingOfferPressed;
  final ShipmentNotification shipmentNotification;
  final bool betterOffer;
  final bool isWasully;

  const OfferDialog({
    super.key,
    required this.onShippingCostPressed,
    required this.onShippingOfferPressed,
    required this.shipmentNotification,
    required this.betterOffer,
    this.isWasully = false,
  });

  @override
  State<OfferDialog> createState() => _OfferDialogState();
}

class _OfferDialogState extends State<OfferDialog> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  int? offer;
  late TextEditingController _priceController, myOfferController;
  late FocusNode _priceNode;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
    myOfferController = TextEditingController();
    _priceNode = FocusNode();
  }

  @override
  void dispose() {
    _priceController.dispose();
    myOfferController.dispose();
    _priceNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of(context);
    final ShipmentProvider shipmentProvider = Provider.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            12.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  widget.shipmentNotification.childrenShipment! > 1
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
                            Text('3.6'),
                            Icon(
                              Icons.star_border,
                              color: weevoPrimaryOrangeColor,
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
                          widget.shipmentNotification.merchantImage!.isEmpty
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
                height: 10.0.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await shipmentProvider.applyToAvailableShipping(
                            shipmentId: widget.shipmentNotification.shipmentId);
                        check(
                            auth: authProvider,
                            ctx: navigator.currentContext!,
                            state: shipmentProvider
                                .applyToAvailableShipmentState!);
                        if (shipmentProvider.applyToAvailableShipmentState ==
                            NetworkState.success) {
                          Navigator.pop(navigator.currentContext!);
                          widget.onShippingCostPressed(
                              'DONE',
                              widget.shipmentNotification.shippingCost,
                              widget.shipmentNotification.totalShipmentCost);
                        } else if (shipmentProvider
                                .applyToAvailableShipmentState ==
                            NetworkState.error) {
                          Navigator.pop(navigator.currentContext!);
                          widget.onShippingCostPressed(
                              'ERROR',
                              widget.shipmentNotification.shippingCost,
                              widget.shipmentNotification.totalShipmentCost);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          weevoPrimaryOrangeColor,
                        ),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 30.0)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0.r),
                          ),
                        ),
                      ),
                      child: Text(
                        'قبول التوصيل ب ${num.parse(widget.shipmentNotification.shippingCost!).toInt()} جنية',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'او قدم عرض التوصيل الخاص بك',
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
                    //             .shipmentNotification
                    //             .shippingCost)
                    //             .toDouble() -
                    //             num.parse(widget.shipmentNotification
                    //                 .shippingCost)
                    //                 .toDouble() *
                    //                 0.1)
                    //             .toInt();
                    //         if(widget.betterOffer){
                    //           await authProvider.updateShipmentOffer(
                    //                         offerId: widget.shipmentNotification.offerId,
                    //                         offer: offer);
                    //         }else{
                    //           await authProvider.sendShipmentOffer(
                    //               offer: offer,
                    //               shipmentId: widget
                    //                   .shipmentNotification.shipmentId);
                    //         }
                    //         if (authProvider.networkState ==
                    //             NetworkState.SUCCESS) {
                    //           Navigator.pop(context);
                    //           widget.onShippingOfferPressed(
                    //               'DONE',
                    //               offer,
                    //               widget.shipmentNotification
                    //                   .totalShipmentCost);
                    //         } else if (authProvider.networkState ==
                    //             NetworkState.ERROR) {
                    //           Navigator.pop(context);
                    //           widget.onShippingOfferPressed(
                    //               'ERROR',
                    //               offer,
                    //               widget.shipmentNotification
                    //                   .totalShipmentCost);
                    //         }
                    //       },
                    //       child: Text(
                    //         '${(num.parse(widget.shipmentNotification.shippingCost).toDouble() - num.parse(widget.shipmentNotification.shippingCost).toDouble() * 0.1).toInt()} جنية',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500,
                    //             fontSize: 12.0.sp),
                    //       ),
                    //       style: ButtonStyle(
                    //         backgroundColor:
                    //         MaterialStateProperty.all<Color>(
                    //           weevoPrimaryOrangeColor,
                    //         ),
                    //         padding:
                    //         MaterialStateProperty.all<EdgeInsets>(
                    //             EdgeInsets.all(
                    //               20.0,
                    //             )),
                    //         shape: MaterialStateProperty.all<
                    //             RoundedRectangleBorder>(
                    //           RoundedRectangleBorder(
                    //             borderRadius:
                    //             BorderRadius.circular(17.0.r),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 5.w,
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //         int offer = (num.parse(widget
                    //             .shipmentNotification
                    //             .shippingCost)
                    //             .toDouble() *
                    //             0.1 +
                    //             num.parse(widget.shipmentNotification
                    //                 .shippingCost)
                    //                 .toDouble())
                    //             .toInt();
                    //         if(widget.betterOffer){
                    //           await authProvider.updateShipmentOffer(
                    //               offerId: widget.shipmentNotification.offerId,
                    //               offer: offer);
                    //         }else{
                    //           await authProvider.sendShipmentOffer(
                    //               offer: offer,
                    //               shipmentId: widget
                    //                   .shipmentNotification.shipmentId);
                    //         }
                    //         if (authProvider.networkState ==
                    //             NetworkState.SUCCESS) {
                    //           Navigator.pop(context);
                    //           widget.onShippingOfferPressed(
                    //               'DONE',
                    //               offer,
                    //               widget.shipmentNotification
                    //                   .totalShipmentCost);
                    //         } else if (authProvider.networkState ==
                    //             NetworkState.ERROR) {
                    //           Navigator.pop(context);
                    //           widget.onShippingOfferPressed(
                    //               'ERROR',
                    //               offer,
                    //               widget.shipmentNotification
                    //                   .totalShipmentCost);
                    //         }
                    //       },
                    //       child: Text(
                    //         '${(num.parse(widget.shipmentNotification.shippingCost).toDouble() * 0.1 + num.parse(widget.shipmentNotification.shippingCost).toDouble()).toInt()} جنية',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500,
                    //             fontSize: 12.0.sp),
                    //       ),
                    //       style: ButtonStyle(
                    //         backgroundColor:
                    //         MaterialStateProperty.all<Color>(
                    //           weevoPrimaryOrangeColor,
                    //         ),
                    //         padding:
                    //         MaterialStateProperty.all<EdgeInsets>(
                    //             EdgeInsets.all(
                    //               20.0,
                    //             )),
                    //         shape: MaterialStateProperty.all<
                    //             RoundedRectangleBorder>(
                    //           RoundedRectangleBorder(
                    //             borderRadius:
                    //             BorderRadius.circular(17.0.r),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 5.w,
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //
                    //       },
                    //       child: Text(
                    //         '${(num.parse(widget.shipmentNotification.shippingCost).toDouble() * 0.2 + num.parse(widget.shipmentNotification.shippingCost).toDouble()).toInt()} جنية',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500,
                    //             fontSize: 12.0.sp),
                    //       ),
                    //       style: ButtonStyle(
                    //         backgroundColor:
                    //         MaterialStateProperty.all<Color>(
                    //           weevoPrimaryOrangeColor,
                    //         ),
                    //         padding:
                    //         MaterialStateProperty.all<EdgeInsets>(
                    //             EdgeInsets.all(
                    //               20.0,
                    //             )),
                    //         shape: MaterialStateProperty.all<
                    //             RoundedRectangleBorder>(
                    //           RoundedRectangleBorder(
                    //             borderRadius:
                    //             BorderRadius.circular(17.0.r),
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
                                if (widget.betterOffer) {
                                  await authProvider.updateShipmentOffer(
                                      offerId:
                                          widget.shipmentNotification.offerId,
                                      offer: offer);
                                } else {
                                  await authProvider.sendShipmentOffer(
                                      offer: offer,
                                      shipmentId: widget
                                          .shipmentNotification.shipmentId);
                                }
                                if (authProvider.networkState ==
                                    NetworkState.success) {
                                  Navigator.pop(navigator.currentContext!);
                                  widget.onShippingOfferPressed(
                                      'DONE',
                                      offer,
                                      widget.shipmentNotification
                                          .totalShipmentCost);
                                } else if (authProvider.networkState ==
                                    NetworkState.error) {
                                  Navigator.pop(navigator.currentContext!);
                                  widget.onShippingOfferPressed(
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
            ],
          ),
        ),
      ),
    );
  }
}
