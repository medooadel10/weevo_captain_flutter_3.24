class Courier {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? photo;
  String? email;
  String? vehicleNumber;
  String? vehicleColor;
  String? vehicleModel;
  String? deliveryMethod;
  int? online;
  String? name;

  Courier(
      {this.id,
      this.firstName,
      this.lastName,
      this.phone,
      this.photo,
      this.email,
      this.vehicleNumber,
      this.vehicleColor,
      this.vehicleModel,
      this.deliveryMethod,
      this.online,
      this.name});

  Courier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    photo = json['photo'];
    email = json['email'];
    vehicleNumber = json['vehicle_number'];
    vehicleColor = json['vehicle_color'];
    vehicleModel = json['vehicle_model'];
    deliveryMethod = json['delivery_method'];
    online = json['online'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['photo'] = photo;
    data['email'] = email;
    data['vehicle_number'] = vehicleNumber;
    data['vehicle_color'] = vehicleColor;
    data['vehicle_model'] = vehicleModel;
    data['delivery_method'] = deliveryMethod;
    data['online'] = online;
    data['name'] = name;
    return data;
  }
}
