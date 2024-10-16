import 'package:flutter/material.dart';
import 'package:weevo_captain_app/features/shipment_details/ui/widgets/buttons/shipment_cancel_btn.dart';
import 'package:weevo_captain_app/features/shipment_details/ui/widgets/buttons/shipment_track_shipment_btn.dart';
import 'package:weevo_captain_app/features/shipment_details/ui/widgets/shipment_details_merchant_header.dart';

import '../../../../features/wasully_details/ui/widgets/wasully_details_cancel_shipment_btn.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_details_handle_shipment_btn.dart';
import '../../../../features/wasully_details/ui/widgets/wasully_details_merchant_header.dart';
import '../../../helpers/spacing.dart';
import 'base_shipment_status.dart';

class ShipmentAppliedStatus extends BaseShipmentStatus {
  @override
  Widget buildWasullyDetailsButtons(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: WasullyDetailsHandleShipmentBtn(),
        ),
        horizontalSpace(8),
        const Expanded(
          child: WasullyDetailsCancelShipmentBtn(),
        ),
      ],
    );
  }

  @override
  Widget buildWasullyMerchantHeader(BuildContext context) {
    return const WasullyDetailsMerchantHeader();
  }

  @override
  Widget buildShipmentMerchantHeader(BuildContext context) {
    return ShipmentDetailsMerchantHeader();
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
  String get status => 'courier-applied-to-shipment';

  @override
  String get statusAr => 'مقدم عليها';

  @override
  String get image => 'assets/images/new_icon.png';
}
