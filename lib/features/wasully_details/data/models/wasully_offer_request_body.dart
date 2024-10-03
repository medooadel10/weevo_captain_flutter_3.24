class WasullyOfferRequestBody {
  final int shipmentid;
  final String offer;

  WasullyOfferRequestBody(this.shipmentid, this.offer);

  Map<String, dynamic> toJson() => {
        'shipment_id': shipmentid,
        'offer': offer,
      };
}
