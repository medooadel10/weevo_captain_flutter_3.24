import 'banner.dart';

class GroupBanner {
  int? id;
  String? name;
  String? slug;
  String? createdAt;
  String? updatedAt;
  List<Banners>? banners;

  GroupBanner(
      {this.id,
      this.name,
      this.slug,
      this.createdAt,
      this.updatedAt,
      this.banners});

  GroupBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners?.add(Banners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (banners != null) {
      data['banners'] = banners?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
