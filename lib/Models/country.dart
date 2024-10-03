import 'state.dart';

class Countries {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<States>? states;

  Countries({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.states,
  });

  Countries.fromJson(Map<String?, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['states'] != null) {
      states = <States>[];
      json['states'].forEach((v) {
        states?.add(States.fromJson(v));
      });
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (states != null) {
      data['states'] = states?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
