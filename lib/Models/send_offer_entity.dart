class Entity {
  int? id;
  int? shipmentId;
  int? driverId;
  String? offer;
  String? status;
  String? createdAt;
  String? updatedAt;

  Entity(
      {this.id,
      this.shipmentId,
      this.driverId,
      this.offer,
      this.status,
      this.createdAt,
      this.updatedAt});

  Entity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shipmentId = json['shipment_id'];
    driverId = json['driver_id'];
    offer = json['offer'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shipment_id'] = shipmentId;
    data['driver_id'] = driverId;
    data['offer'] = offer;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
