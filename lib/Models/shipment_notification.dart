class ShipmentNotification {
  String? receivingState;
  String? receivingCity;
  String? deliveryState;
  String? deliveryCity;
  int? shipmentId;
  String? totalShipmentCost;
  String? shippingCost;
  int? childrenShipment;
  String? merchantName;
  String? merchantFcmToken;
  String? merchantImage;
  String? merchantId;
  String? flags;
  int? offerId;
  bool? isWasully;

  ShipmentNotification({
    this.receivingState,
    this.receivingCity,
    this.deliveryState,
    this.deliveryCity,
    this.shipmentId,
    this.merchantId,
    this.flags,
    this.totalShipmentCost,
    this.shippingCost,
    this.childrenShipment,
    this.merchantName,
    this.merchantFcmToken,
    this.merchantImage,
    this.offerId,
    this.isWasully = false,
  });

  factory ShipmentNotification.fromMap(Map<String, dynamic> map) =>
      ShipmentNotification(
        merchantImage: map['merchant_image'],
        merchantName: map['merchant_name'],
        merchantFcmToken: map['merchant_fcm_token'],
        receivingState: map['receiving_state'],
        receivingCity: map['receiving_city'],
        deliveryState: map['delivery_state'],
        deliveryCity: map['delivery_city'],
        flags: map['flags'],
        totalShipmentCost: map['total_shipment_cost'],
        shippingCost: map['expected_shipping_cost'],
        childrenShipment: map['children_shipment'],
        shipmentId: map['shipment_id'],
        merchantId: map['merchant_id'],
        offerId: map['offer_id'],
      );

  Map<String, dynamic> toMap() => {
        'merchant_image': merchantImage,
        'merchant_name': merchantName,
        'merchant_fcm_token': merchantFcmToken,
        'receiving_state': receivingState,
        'receiving_city': receivingCity,
        'delivery_state': deliveryState,
        'delivery_city': deliveryCity,
        'flags': flags,
        'total_shipment_cost': totalShipmentCost,
        'expected_shipping_cost': shippingCost,
        'children_shipment': childrenShipment,
        'shipment_id': shipmentId,
        'merchant_id': merchantId,
        'offer_id': offerId,
      };

  @override
  String toString() {
    return 'ShipmentNotification{receivingState: $receivingState, receivingCity: $receivingCity, deliveryState: $deliveryState, deliveryCity: $deliveryCity, shipmentId: $shipmentId, totalShipmentCost: $totalShipmentCost, shippingCost: $shippingCost, childrenShipment: $childrenShipment, merchantName: $merchantName, merchantFcmToken: $merchantFcmToken, merchantImage: $merchantImage, merchantId: $merchantId, offerId: $offerId}';
  }
}
