class WeevoUser {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? emailAddress;
  String? gender;
  String? password;
  String? imageUrl;
  String? nationalIdPhotoBack;
  String? nationalIdPhotoFront;
  String? nationalIdNumber;
  String? vehicleColor;
  String? vehicleModel;
  String? deliveryMethod;
  String? userFirebaseId;
  String? vehiclePlate;
  String? firebaseNotificationToken;
  List<int>? citiesIds;

  WeevoUser({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.gender,
    required this.password,
    required this.nationalIdPhotoBack,
    required this.nationalIdPhotoFront,
    required this.nationalIdNumber,
    required this.citiesIds,
    required this.userFirebaseId,
    required this.vehicleColor,
    required this.vehicleModel,
    required this.vehiclePlate,
    required this.firebaseNotificationToken,
    required this.deliveryMethod,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": emailAddress,
      "password": password,
      "phone": phoneNumber,
      "gender": gender,
      "photo": imageUrl,
      "delivery_method": deliveryMethod,
      "vehicle_number": vehiclePlate,
      "vehicle_color": vehicleColor,
      "vehicle_model": vehicleModel,
      "firebase_notification_token": firebaseNotificationToken,
      "firebase_uid": userFirebaseId,
      "national_id_photo_back": nationalIdPhotoBack,
      "national_id_photo_front": nationalIdPhotoFront,
      "national_id_number": nationalIdNumber,
      "cities": citiesIds,
    };
  }

  factory WeevoUser.fromMap(Map<String, dynamic> map) {
    return WeevoUser(
      firstName: map["first_name"],
      lastName: map["last_name"],
      phoneNumber: map["phone"],
      emailAddress: map["email"],
      gender: map["gender"],
      password: map["password"],
      userFirebaseId: map["firebase_uid"],
      imageUrl: map["photo"],
      deliveryMethod: map["delivery_method"],
      firebaseNotificationToken: map["firebase_notification_token"],
      vehiclePlate: map["vehicle_number"],
      vehicleColor: map["vehicle_color"],
      vehicleModel: map["vehicle_model"],
      nationalIdPhotoBack: map["national_id_photo_back"],
      nationalIdPhotoFront: map["national_id_photo_front"],
      nationalIdNumber: map["national_id_number"],
      citiesIds: map["cities"],
    );
  }

  @override
  String toString() {
    return "WeevoUser{firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, emailAddress: $emailAddress, gender: $gender, password: $password, imageUrl: $imageUrl, nationalIdPhotoBack: $nationalIdPhotoBack, nationalIdPhotoFront: $nationalIdPhotoFront, nationalIdNumber: $nationalIdNumber, vehicleColor: $vehicleColor, vehicleModel: $vehicleModel, deliveryMethod: $deliveryMethod, userFirebaseId: $userFirebaseId, vehiclePlate: $vehiclePlate, firebaseNotificationToken: $firebaseNotificationToken, citiesIds: $citiesIds}";
  }
}
