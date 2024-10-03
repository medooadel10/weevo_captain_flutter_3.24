class ShipmentProductInfoModel {
  final int id;
  final String name;
  final int defaultPrice;
  final String description;
  final int categoryId;
  final String image;
  final String length;
  final String width;
  final String height;
  final String weight;
  final ProductCategory productCategory;

  ShipmentProductInfoModel({
    required this.id,
    required this.name,
    required this.defaultPrice,
    required this.description,
    required this.categoryId,
    required this.image,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
    required this.productCategory,
  });

  factory ShipmentProductInfoModel.fromJson(Map<String, dynamic> json) =>
      ShipmentProductInfoModel(
        id: json['id'],
        name: json['name'],
        defaultPrice: json['default_price'],
        description: json['description'],
        categoryId: json['category_id'],
        image: json['image'],
        length: json['length'],
        width: json['width'],
        height: json['height'],
        weight: json['weight'],
        productCategory: ProductCategory.fromJson(json['product_category']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'default_price': defaultPrice,
        'description': description,
        'category_id': categoryId,
        'image': image,
        'length': length,
        'width': width,
        'height': height,
        'weight': weight,
        'product_category': productCategory.toJson(),
      };
}

class ProductCategory {
  final int id;
  final String name;
  final String image;

  ProductCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        id: json['id'],
        name: json['name'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
      };
}
