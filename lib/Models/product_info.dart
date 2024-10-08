class ProductInfo {
  int? id;
  String? name;
  int? defaultPrice;
  String? description;
  int? categoryId;
  String? image;
  String? length;
  String? width;
  String? height;
  String? weight;
  ProductCategory? productCategory;

  ProductInfo(
      {this.id,
      this.name,
      this.defaultPrice,
      this.description,
      this.categoryId,
      this.image,
      this.length,
      this.width,
      this.height,
      this.productCategory,
      this.weight});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    defaultPrice = json['default_price'];
    description = json['description'];
    categoryId = json['category_id'];
    image = json['image'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    weight = json['weight'];
    productCategory = json['product_category'] != null
        ? ProductCategory.fromJson(json['product_category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['default_price'] = defaultPrice;
    data['description'] = description;
    data['category_id'] = categoryId;
    data['image'] = image;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['weight'] = weight;
    return data;
  }
}

class ProductCategory {
  int? id;
  String? name;
  String? image;

  ProductCategory({this.id, this.name, this.image});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
