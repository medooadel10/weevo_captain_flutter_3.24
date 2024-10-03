class ArticlesData {
  int? id;
  String? title;
  String? image;
  String? text;
  String? link;
  String? createdAt;
  String? updatedAt;

  ArticlesData({
    this.id,
    this.title,
    this.image,
    this.text,
    this.link,
    this.createdAt,
    this.updatedAt,
  });

  ArticlesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    text = json['text'];
    link = json['link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['text'] = text;
    data['link'] = link;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
