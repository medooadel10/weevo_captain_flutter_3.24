import 'package:flutter/material.dart';
import 'package:weevo_captain_app/features/shipment_details/ui/widgets/buttons/shipment_track_shipment_btn.dart';
import 'package:weevo_captain_app/features/shipment_details/ui/widgets/shipment_details_merchant_header.dart';

import '../../../../Utilits/colors.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_details_handle_shipment_btn.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_details_merchant_header.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_details_tel_button.dart';
import '../../../helpers/spacing.dart';
import 'base_shipment_status.dart';

class ShipmentOnDeliveryStatus extends BaseShipmentStatus {
  @override
  Widget buildWasullyDetailsButtons(BuildContext context) {
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
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ShipmentTrackShipmentBtn(),
    );
  }

  @override
  Widget buildShipmentMerchantHeader(BuildContext context) {
    return ShipmentDetailsMerchantHeader();
  }

  @override
  String get status => 'on-delivery';

  @override
  String get statusAr => 'قيد التوصيل';

  @override
  String get image => 'assets/images/on_delivery.png';

  @override
  Widget buildWasullyMerchantHeader(BuildContext context) {
    return const WasullyDetailsMerchantHeader();
  }
}
