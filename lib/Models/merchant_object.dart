class MerchantObject {
  int? id;
  String? photo;
  String? firstName;
  String? lastName;
  String? phone;
  String? gender;
  String? brandName;
  String? cachedAverageRating;
  String? name;

  MerchantObject(
      {this.id,
      this.photo,
      this.firstName,
      this.lastName,
      this.phone,
      this.gender,
      this.brandName,
      this.cachedAverageRating,
      this.name});

  MerchantObject.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    photo = json?['photo'];
    firstName = json?['first_name'];
    lastName = json?['last_name'];
    phone = json?['phone'];
    gender = json?['gender'];
    brandName = json?['brand_name'];
    cachedAverageRating = json?['cached_average_rating'];
    name = json?['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['photo'] = photo;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['gender'] = gender;
    data['brand_name'] = brandName;
    data['cached_average_rating'] = cachedAverageRating;
    data['name'] = name;
    return data;
  }
}
