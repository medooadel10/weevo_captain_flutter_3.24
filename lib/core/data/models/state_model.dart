class StateModel {
  final int id;
  final String name;

  StateModel(this.id, this.name);

  factory StateModel.fromJson(Map<String, dynamic>? json) =>
      json == null ? StateModel(0, '') : StateModel(json['id'], json['name']);
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
