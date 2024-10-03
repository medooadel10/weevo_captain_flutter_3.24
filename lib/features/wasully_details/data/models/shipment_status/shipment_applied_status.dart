import 'package:flutter/material.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../ui/widgets/wasully_details_cancel_shipment_btn.dart';
import '../../../ui/widgets/wasully_details_handle_shipment_btn.dart';
import '../../../ui/widgets/wasully_details_merchant_header.dart';
import 'base_shipment_status.dart';

class ShipmentAppliedStatus extends BaseShipmentStatus {
  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
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
  Widget buildShipmentMerchantHeader(BuildContext context) {
    return const WasullyDetailsMerchantHeader();
  }

  @override
  String get status => 'courier-applied-to-shipment';

  @override
  String get statusAr => 'مقدم عليها';

  @override
  String get image => 'assets/images/new_icon.png';
}
