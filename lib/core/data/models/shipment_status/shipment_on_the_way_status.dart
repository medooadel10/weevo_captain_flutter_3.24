import 'package:flutter/material.dart';

import '../../../../Utilits/colors.dart';
import '../../../../features/shipment_details/ui/widgets/buttons/shipment_cancel_btn.dart';
import '../../../../features/shipment_details/ui/widgets/buttons/shipment_track_shipment_btn.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_details_handle_shipment_btn.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_details_merchant_header.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_details_tel_button.dart';
import '../../../helpers/spacing.dart';
import 'base_shipment_status.dart';

class ShipmentOnTheWayStatus extends BaseShipmentStatus {
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
    return Row(
      children: [
        const Expanded(
          child: ShipmentTrackShipmentBtn(),
        ),
        horizontalSpace(8),
        const Expanded(
          child: ShipmentCancelBtn(),
        ),
      ],
    );
  }

  @override
  String get status => 'on-the-way-to-get-shipment-from-merchant';

  @override
  String get statusAr => 'في الطريق';

  @override
  String get image => 'assets/images/in_my_way_icon.png';

  @override
  Widget buildWasullyMerchantHeader(BuildContext context) {
    return const WasullyDetailsMerchantHeader();
  }
}
