class UserDataByToken {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? emailVerifiedAt;
  String? photo;
  String? phone;
  String? gender;
  String? stateId;
  String? cityId;
  String? street;
  String? buildingNumber;
  String? floor;
  String? apartment;
  String? vehicleNumber;
  String? vehicleColor;
  String? vehicleModel;
  String? deliveryMethod;
  String? nationalIdPhotoBack;
  String? nationalIdPhotoFront;
  int? active;
  int? banned;
  String? lastSeen;
  int? receiveNotification;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? name;
  List<DeliveryAreas>? deliveryAreas;

  UserDataByToken(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.emailVerifiedAt,
      this.photo,
      this.phone,
      this.gender,
      this.stateId,
      this.cityId,
      this.street,
      this.buildingNumber,
      this.floor,
      this.apartment,
      this.vehicleNumber,
      this.vehicleColor,
      this.vehicleModel,
      this.deliveryMethod,
      this.nationalIdPhotoBack,
      this.nationalIdPhotoFront,
      this.active,
      this.banned,
      this.lastSeen,
      this.receiveNotification,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.name,
      this.deliveryAreas});

  UserDataByToken.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    photo = json['photo'];
    phone = json['phone'];
    gender = json['gender'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    street = json['street'];
    buildingNumber = json['building_number'];
    floor = json['floor'];
    apartment = json['apartment'];
    vehicleNumber = json['vehicle_number'];
    vehicleColor = json['vehicle_color'];
    vehicleModel = json['vehicle_model'];
    deliveryMethod = json['delivery_method'];
    nationalIdPhotoBack = json['national_id_photo_back'];
    nationalIdPhotoFront = json['national_id_photo_front'];
    active = json['active'];
    banned = json['banned'];
    lastSeen = json['last_seen'];
    receiveNotification = json['receive_notifications'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    name = json['name'];
    if (json['delivery_areas'] != null) {
      deliveryAreas = [];
      json['delivery_areas'].forEach((v) {
        deliveryAreas?.add(DeliveryAreas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['photo'] = photo;
    data['phone'] = phone;
    data['gender'] = gender;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['street'] = street;
    data['building_number'] = buildingNumber;
    data['floor'] = floor;
    data['apartment'] = apartment;
    data['vehicle_number'] = vehicleNumber;
    data['vehicle_color'] = vehicleColor;
    data['vehicle_model'] = vehicleModel;
    data['delivery_method'] = deliveryMethod;
    data['national_id_photo_back'] = nationalIdPhotoBack;
    data['national_id_photo_front'] = nationalIdPhotoFront;
    data['active'] = active;
    data['banned'] = banned;
    data['last_seen'] = lastSeen;
    data['receive_notifications'] = receiveNotification;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['name'] = name;
    if (deliveryAreas != null) {
      data['delivery_areas'] = deliveryAreas?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'UserDataByToken{id: $id, firstName: $firstName, lastName: $lastName, email: $email, emailVerifiedAt: $emailVerifiedAt, photo: $photo, phone: $phone, gender: $gender, stateId: $stateId, cityId: $cityId, street: $street, buildingNumber: $buildingNumber, floor: $floor, apartment: $apartment, vehicleNumber: $vehicleNumber, vehicleColor: $vehicleColor, vehicleModel: $vehicleModel, deliveryMethod: $deliveryMethod, nationalIdPhotoBack: $nationalIdPhotoBack, nationalIdPhotoFront: $nationalIdPhotoFront, active: $active, banned: $banned, lastSeen: $lastSeen, receiveNotification: $receiveNotification, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, name: $name, deliveryAreas: $deliveryAreas}';
  }
}

class DeliveryAreas {
  int? id;
  int? driverId;
  int? cityId;
  String? createdAt;
  String? updatedAt;

  DeliveryAreas(
      {this.id, this.driverId, this.cityId, this.createdAt, this.updatedAt});

  DeliveryAreas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    cityId = json['city_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['driver_id'] = driverId;
    data['city_id'] = cityId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
