import 'package:flutter/material.dart';

import '../../../../../Utilits/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../ui/widgets/wasully_details_handle_shipment_btn.dart';
import '../../../ui/widgets/wasully_details_merchant_header.dart';
import '../../../ui/widgets/wasully_details_tel_button.dart';
import 'base_shipment_status.dart';

class ShipmentOnDeliveryStatus extends BaseShipmentStatus {
  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: WasullyDetailsHandleShipmentBtn(),
        ),
        horizontalSpace(10),
        const Expanded(
          child: WasullyDetailsTelButton(
            color: weevoPrimaryBlueColor,
          ),
        ),
      ],
    );
  }

  @override
  String get status => 'on-delivery';

  @override
  String get statusAr => 'قيد التوصيل';

  @override
  String get image => 'assets/images/on_delivery.png';

  @override
  Widget buildShipmentMerchantHeader(BuildContext context) {
    return const WasullyDetailsMerchantHeader();
  }
}
