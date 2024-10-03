class Banners {
  int? id;
  int? groupId;
  String? name;
  String? type;
  String? image;
  String? embedVideoCode;
  String? link;
  int? active;
  String? createdAt;
  String? updatedAt;

  Banners(
      {this.id,
      this.groupId,
      this.name,
      this.type,
      this.image,
      this.embedVideoCode,
      this.link,
      this.active,
      this.createdAt,
      this.updatedAt});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['group_id'];
    name = json['name'];
    type = json['type'];
    image = json['image'];
    embedVideoCode = json['embed_video_code'];
    link = json['link'];
    active = json['active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['group_id'] = groupId;
    data['name'] = name;
    data['type'] = type;
    data['image'] = image;
    data['embed_video_code'] = embedVideoCode;
    data['link'] = link;
    data['active'] = active;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
