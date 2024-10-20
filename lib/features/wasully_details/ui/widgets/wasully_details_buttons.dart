import 'package:flutter/material.dart';

import '../../../../core/data/models/shipment_status/base_shipment_status.dart';

class WasullyDetailsButtons extends StatelessWidget {
  final String status;
  const WasullyDetailsButtons({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return BaseShipmentStatus.shipmentStatusMap[status]
            ?.buildWasullyDetailsButtons(context) ??
        Container();
  }
}
