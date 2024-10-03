class ShipmentStatus {
  String? status;
  int? total;

  ShipmentStatus({this.status, this.total});

  ShipmentStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total'] = total;
    return data;
  }
}
