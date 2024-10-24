class CityModel {
  final int id;
  final String name;

  CityModel(this.id, this.name);

  factory CityModel.fromJson(Map<String, dynamic>? json) {
    return json == null
        ? CityModel(0, 'غير محدد')
        : CityModel(json['id'], json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
