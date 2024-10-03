class WasullyOfferResponseBody {
  final String message;
  final bool? alreadyExist;
  final WasullyOfferModel data;

  WasullyOfferResponseBody(this.message, this.alreadyExist, this.data);

  factory WasullyOfferResponseBody.fromJson(Map<String, dynamic> json) =>
      WasullyOfferResponseBody(
        json['message'],
        json['alreadyExist'],
        WasullyOfferModel.fromJson(json['entity']),
      );
}

class WasullyOfferModel {
  final int id;
  final int shipmentId;
  final int driverId;
  final String offer;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String expiresAt;

  WasullyOfferModel(this.id, this.shipmentId, this.driverId, this.offer,
      this.status, this.createdAt, this.updatedAt, this.expiresAt);

  factory WasullyOfferModel.fromJson(Map<String, dynamic> json) =>
      WasullyOfferModel(
        json['id'],
        json['shipment_id'],
        json['driver_id'],
        json['offer'],
        json['status'],
        json['created_at'],
        json['updated_at'],
        json['expires_at'],
      );
}
