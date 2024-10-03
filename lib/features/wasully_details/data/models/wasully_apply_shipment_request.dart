class WasullyApplyShipmentRequestBody {
  final int shipmentId;

  WasullyApplyShipmentRequestBody(this.shipmentId);

  Map<String, dynamic> toJson() => {
        'shipment_id': shipmentId,
      };
}
