class DriverArea {
  int? id;
  int? driverId;
  int? cityId;
  String? createdAt;
  String? updatedAt;

  DriverArea(
      {this.id, this.driverId, this.cityId, this.createdAt, this.updatedAt});

  DriverArea.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    cityId = json['city_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['driver_id'] = driverId;
    data['city_id'] = cityId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'DriverArea{id: $id, driverId: $driverId, cityId: $cityId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
