import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';

class DeliverShipmentDialog extends StatefulWidget {
  final String amount;
  final String shippingCost;
  final Function onOkPressed;
  final int shipmentId;

  const DeliverShipmentDialog({
    super.key,
    required this.amount,
    required this.shippingCost,
    required this.shipmentId,
    required this.onOkPressed,
  });

  @override
  State<DeliverShipmentDialog> createState() => _DeliverShipmentDialogState();
}

class _DeliverShipmentDialogState extends State<DeliverShipmentDialog> {
  @override
  Widget build(BuildContext context) {
    final shipmentProvider = Provider.of<ShipmentProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Dialog(
      insetPadding:
          shipmentProvider.applyToAvailableShipmentState == NetworkState.waiting
              ? const EdgeInsets.all(
                  100,
                )
              : EdgeInsets.symmetric(
                  horizontal: 20.0.w,
                ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: shipmentProvider.applyToAvailableShipmentState ==
                NetworkState.waiting
            ? const EdgeInsets.all(
                50.0,
              )
            : const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 20.0,
              ),
        child: shipmentProvider.applyToAvailableShipmentState ==
                NetworkState.waiting
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
                children: [
                  Image.asset(
                    'assets/images/atm_wallet_1500px_resized.png',
                    height: 150.h,
                    width: 150.h,
                  ),
                  Text(
                    'سوف يتم خصم ${double.parse(widget.amount).toInt()} جنية مقدم الشحنة\nمن محفظتك بالأضافة الي ${(double.parse(widget.shippingCost) * (Preferences.instance.getCourierCommission / 100)).toInt()} جنية\nنسبة التطبيق',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              weevoPrimaryBlueColor,
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(vertical: 8),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await shipmentProvider.applyToAvailableShipping(
                                shipmentId: widget.shipmentId);
                            check(
                                auth: authProvider,
                                state: shipmentProvider
                                    .applyToAvailableShipmentState!,
                                ctx: navigator.currentContext!);
                            if (shipmentProvider
                                    .applyToAvailableShipmentState ==
                                NetworkState.success) {
                              Navigator.pop(navigator.currentContext!);
                              widget.onOkPressed('DONE');
                            } else if (shipmentProvider
                                    .applyToAvailableShipmentState ==
                                NetworkState.error) {
                              Navigator.pop(navigator.currentContext!);
                              widget.onOkPressed('ERROR');
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              weevoPrimaryOrangeColor,
                            ),
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(vertical: 8),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Text(
                            'موافق',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0.sp,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
