import 'package:flutter/material.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../ui/widgets/wasully_details_cancel_shipment_btn.dart';
import '../../../ui/widgets/wasully_details_handle_shipment_btn.dart';
import '../../../ui/widgets/wasully_details_merchant_header.dart';
import 'base_shipment_status.dart';

class ShipmentMerchantAcceptedStatus extends BaseShipmentStatus {
  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: WasullyDetailsHandleShipmentBtn(),
        ),
        horizontalSpace(10),
        const Expanded(
          child: WasullyDetailsCancelShipmentBtn(),
        ),
      ],
    );
  }

  @override
  String get status => 'merchant-accepted-shipping-offer';

  @override
  String get statusAr => 'في انتظار التوصيل';

  @override
  String get image => 'assets/images/wait_to_deliver.png';

  @override
  Widget buildShipmentMerchantHeader(BuildContext context) {
    return const WasullyDetailsMerchantHeader();
  }
}
