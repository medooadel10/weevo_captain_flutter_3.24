import 'city.dart';

class States {
  int? id;
  String? name;
  int? countryId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Cities>? cities;

  States({
    this.id,
    this.name,
    this.countryId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.cities,
  });

  States.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities?.add(Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country_id'] = countryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (cities != null) {
      data['cities'] = cities?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
