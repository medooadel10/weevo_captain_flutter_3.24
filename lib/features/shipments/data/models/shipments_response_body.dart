import 'shipment_model.dart';

class ShipmentsResponseBody {
  final List<ShipmentModel> shipments;
  final int? currentPage;
  final int? total;

  ShipmentsResponseBody(this.shipments, this.currentPage, this.total);

  factory ShipmentsResponseBody.fromJson(Map<String, dynamic> json) {
    List<ShipmentModel> shipments = [];
    if (json['data'] != null) {
      if (json['data'] is List) {
        for (var v in (json['data'] as List)) {
          shipments.add(ShipmentModel.fromJson(v));
        }
      } else if (json['data'] is Map) {
        (json['data'] as Map).forEach((key, value) {
          shipments.add(ShipmentModel.fromJson(value));
        });
      }
    }
    return ShipmentsResponseBody(
      shipments,
      json['current_page'],
      json['total'],
    );
  }
}
