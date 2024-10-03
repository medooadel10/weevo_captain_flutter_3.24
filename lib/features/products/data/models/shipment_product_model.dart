import 'shipment_product_info_model.dart.dart';

class ShipmentProductModel {
  final int id;
  final int shipmentId;
  final int productId;
  final int qty;
  final int price;
  final int total;
  final String createdAt;
  final String updatedAt;
  final ShipmentProductInfoModel productInfo;

  ShipmentProductModel({
    required this.id,
    required this.shipmentId,
    required this.productId,
    required this.qty,
    required this.price,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.productInfo,
  });

  factory ShipmentProductModel.fromJson(Map<String, dynamic> json) =>
      ShipmentProductModel(
        id: json['id'],
        shipmentId: json['shipment_id'],
        productId: json['product_id'],
        qty: json['qty'],
        price: json['price'],
        total: json['total'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        productInfo: ShipmentProductInfoModel.fromJson(json['product_info']),
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'shipment_id': shipmentId,
        'product_id': productId,
        'qty': qty,
        'price': price,
        'total': total,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'product_info': productInfo.toJson(),
      };
}
