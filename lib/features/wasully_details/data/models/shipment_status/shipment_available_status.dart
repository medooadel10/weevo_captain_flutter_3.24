import 'package:flutter/material.dart';

import '../../../ui/widgets/wasully_details_shipping_btn.dart';
import 'base_shipment_status.dart';

class ShipmentAvailableStatus extends BaseShipmentStatus {
  @override
  Widget buildShipmentDetailsButtons(BuildContext context) {
    return const WasullyDetailsShippingBtn();
  }

  @override
  String get status => 'available';

  @override
  String get statusAr => 'متاحة';

  @override
  String get image => 'assets/images/delivered_icon.png';
}
