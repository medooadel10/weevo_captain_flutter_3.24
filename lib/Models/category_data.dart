class CategoryData {
  int? id;
  String? name;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  CategoryData(
      {this.id,
      this.name,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }

  @override
  String toString() {
    return 'CategoryData{id: $id, name: $name, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}
