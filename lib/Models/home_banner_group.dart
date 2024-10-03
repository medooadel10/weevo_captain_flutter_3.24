class HomeBannerGroup {
  int? id;
  String? name;
  String? slug;
  String? createdAt;
  String? updatedAt;

  HomeBannerGroup(
      {this.id, this.name, this.slug, this.createdAt, this.updatedAt});

  HomeBannerGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
