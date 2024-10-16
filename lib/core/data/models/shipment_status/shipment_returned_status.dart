import 'package:flutter/material.dart';

import 'base_shipment_status.dart';

class ShipmentReturnedStatus extends BaseShipmentStatus {
  @override
  Widget buildWasullyDetailsButtons(BuildContext context) {
    return Container();
  }

  @override
  String get status => 'returned';

  @override
  String get statusAr => 'مرتجعة';

  @override
  String get image => 'assets/images/returned_icon.png';
}
