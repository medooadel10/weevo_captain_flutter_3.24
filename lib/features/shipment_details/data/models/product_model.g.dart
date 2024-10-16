// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      (json['id'] as num).toInt(),
      (json['product_id'] as num).toInt(),
      (json['shipment_id'] as num).toInt(),
      (json['price'] as num).toDouble(),
      (json['total'] as num?)?.toDouble(),
      ProductInfoModel.fromJson(json['product_info'] as Map<String, dynamic>),
      (json['qty'] as num).toInt(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'shipment_id': instance.shipmentId,
      'price': instance.price,
      'total': instance.total,
      'qty': instance.qty,
      'product_info': instance.productInfo,
    };

ProductInfoModel _$ProductInfoModelFromJson(Map<String, dynamic> json) =>
    ProductInfoModel(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['description'] as String,
      (json['default_price'] as num).toDouble(),
      json['image'] as String,
      (json['category_id'] as num).toInt(),
      json['length'] as String,
      json['width'] as String,
      json['height'] as String,
      json['weight'] as String,
      ProductCategoryModel.fromJson(
          json['product_category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductInfoModelToJson(ProductInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'default_price': instance.defaultPrice,
      'image': instance.image,
      'category_id': instance.categoryId,
      'length': instance.length,
      'width': instance.width,
      'height': instance.height,
      'weight': instance.weight,
      'product_category': instance.productCategory,
    };

ProductCategoryModel _$ProductCategoryModelFromJson(
        Map<String, dynamic> json) =>
    ProductCategoryModel(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['image'] as String,
    );

Map<String, dynamic> _$ProductCategoryModelToJson(
        ProductCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
