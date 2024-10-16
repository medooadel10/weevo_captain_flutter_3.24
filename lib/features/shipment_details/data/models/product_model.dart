import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductModel {
  final int id;
  final int productId;
  final int shipmentId;
  final double price;
  final double? total;
  final int qty;
  final ProductInfoModel productInfo;

  ProductModel(this.id, this.productId, this.shipmentId, this.price, this.total,
      this.productInfo, this.qty);

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductInfoModel {
  final int id;
  final String name;
  final String description;
  final double defaultPrice;
  final String image;
  final int categoryId;
  final String length;
  final String width;
  final String height;
  final String weight;
  final ProductCategoryModel productCategory;

  ProductInfoModel(
      this.id,
      this.name,
      this.description,
      this.defaultPrice,
      this.image,
      this.categoryId,
      this.length,
      this.width,
      this.height,
      this.weight,
      this.productCategory);

  factory ProductInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ProductInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductInfoModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductCategoryModel {
  final int id;
  final String name;
  final String image;

  ProductCategoryModel(this.id, this.name, this.image);

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCategoryModelToJson(this);
}
