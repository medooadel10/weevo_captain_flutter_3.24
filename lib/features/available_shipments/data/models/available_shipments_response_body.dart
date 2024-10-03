import 'available_shipment_model.dart';

class AvailableShipmentsResponseBody {
  final List<AvailableShipmentModel> availableShipments;
  final int? currentPage;
  final int? total;

  AvailableShipmentsResponseBody(
      this.availableShipments, this.currentPage, this.total);

  factory AvailableShipmentsResponseBody.fromJson(Map<String, dynamic> json) =>
      AvailableShipmentsResponseBody(
        (json['data'] as List)
            .map((e) => AvailableShipmentModel.fromJson(e))
            .toList(),
        json['current_page'],
        json['total'],
      );
}
