class AcceptMerchantOffer {
  final int shipmentId;
  final int childrenShipment;

  AcceptMerchantOffer({
    required this.shipmentId,
    required this.childrenShipment,
  });

  factory AcceptMerchantOffer.fromMap(Map<String, dynamic> map) =>
      AcceptMerchantOffer(
          shipmentId: map['shipment_id'],
          childrenShipment: map['children_shipment']);

  Map<String, dynamic> toMap() => {
        'shipment_id': shipmentId,
        'children_shipment': childrenShipment,
      };
}
