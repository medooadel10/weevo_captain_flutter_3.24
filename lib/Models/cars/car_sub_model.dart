class CarSubModels {
  int? iD;
  String? name;

  CarSubModels({this.iD, this.name});

  CarSubModels.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['name'] = name;
    return data;
  }
}
