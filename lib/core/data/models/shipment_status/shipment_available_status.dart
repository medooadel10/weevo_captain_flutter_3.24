import 'package:flutter/material.dart';
import 'package:weevo_captain_app/features/shipment_details/ui/widgets/buttons/shipment_shipping_btn.dart';

import '../../../../features/wasully_details/ui/widgets/wasully_details_shipping_btn.dart';
import 'base_shipment_status.dart';

class ShipmentAvailableStatus extends BaseShipmentStatus {
  @override
  Widget buildWasullyDetailsButtons(BuildContext context) {
    return const WasullyDetailsShippingBtn();
  }

  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return ShipmentShippingBtn();
  }

  @override
  String get status => 'available';

  @override
  String get statusAr => 'متاحة';

  @override
  String get image => 'assets/images/delivered_icon.png';
}
