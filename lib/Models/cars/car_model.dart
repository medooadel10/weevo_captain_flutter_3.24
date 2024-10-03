import 'car_sub_model.dart';

class CarModel {
  int? iD;
  String? name;
  String? photo;
  List<CarSubModels>? models;

  CarModel({
    this.iD,
    this.name,
    this.photo,
    this.models,
  });

  CarModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['name'];
    photo = json['photo'];
    if (json['Models'] != null) {
      models = [];
      json['Models'].forEach((v) {
        models?.add(CarSubModels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['name'] = name;
    data['photo'] = photo;
    if (models != null) {
      data['Models'] = models?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
