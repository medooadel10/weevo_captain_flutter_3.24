import 'package:flutter/material.dart';

import 'shipment_applied_status.dart';
import 'shipment_available_status.dart';
import 'shipment_delivered_status.dart';
import 'shipment_merchant_accepted_status.dart';
import 'shipment_on_delivery_status.dart';
import 'shipment_on_the_way_status.dart';
import 'shipment_returned_status.dart';

abstract class BaseShipmentStatus {
  static Map<String, BaseShipmentStatus> shipmentStatusMap = {
    'courier-applied-to-shipment': ShipmentAppliedStatus(),
    'merchant-accepted-shipping-offer': ShipmentMerchantAcceptedStatus(),
    'on-the-way-to-get-shipment-from-merchant': ShipmentOnTheWayStatus(),
    'on-delivery': ShipmentOnDeliveryStatus(),
    'delivered': ShipmentDeliveredStatus(),
    'bulk-shipment-closed': ShipmentDeliveredStatus(),
    'cancelled': ShipmentReturnedStatus(),
    'available': ShipmentAvailableStatus(),
    'returned': ShipmentReturnedStatus(),
  };
  static List<BaseShipmentStatus> shipmentStatusList = [
    ShipmentAppliedStatus(),
    ShipmentMerchantAcceptedStatus(),
    ShipmentOnTheWayStatus(),
    ShipmentOnDeliveryStatus(),
  ];

  static List<BaseShipmentStatus> closedShipmentStatusList = [
    ShipmentDeliveredStatus(),
    ShipmentReturnedStatus(),
  ];

  Widget buildShipmentDetailsButtons(BuildContext context);
  Widget buildShipmentMerchantHeader(BuildContext context) {
    return Container();
  }

  String get status;
  String get statusAr;
  String get image;
}
