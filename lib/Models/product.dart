import 'product_info.dart';

class Product {
  int? id;
  int? shipmentId;
  int? productId;
  int? qty;
  int? price;
  int? total;
  String? createdAt;
  String? updatedAt;
  ProductInfo? productInfo;

  Product(
      {this.id,
      this.shipmentId,
      this.productId,
      this.qty,
      this.price,
      this.total,
      this.createdAt,
      this.updatedAt,
      this.productInfo});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shipmentId = json['shipment_id'];
    productId = json['product_id'];
    qty = json['qty'];
    price = json['price'];
    total = json['total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productInfo = json['product_info'] != null
        ? ProductInfo.fromJson(json['product_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shipment_id'] = shipmentId;
    data['product_id'] = productId;
    data['qty'] = qty;
    data['price'] = price;
    data['total'] = total;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (productInfo != null) {
      data['product_info'] = productInfo?.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Product{id: $id, shipmentId: $shipmentId, productId: $productId, qty: $qty, price: $price, total: $total, createdAt: $createdAt, updatedAt: $updatedAt, productInfo: $productInfo}';
  }
}
