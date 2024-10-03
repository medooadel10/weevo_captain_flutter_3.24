class BankModel {
  int? id;
  String? nameEn;
  String? nameAr;

  BankModel({this.id, this.nameEn, this.nameAr});

  BankModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['name_en'];
    nameAr = json['name_ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_en'] = nameEn;
    data['name_ar'] = nameAr;
    return data;
  }
}
