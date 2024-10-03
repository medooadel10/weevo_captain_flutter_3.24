import 'car_model.dart';

class Cars {
  List<CarModel>? cars;

  Cars({this.cars});

  Cars.fromJson(Map<String, dynamic> json) {
    if (json['Cars'] != null) {
      cars = [];
      json['Cars'].forEach((v) {
        cars?.add(CarModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cars != null) {
      data['Cars'] = cars?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
