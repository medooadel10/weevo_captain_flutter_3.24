class SignUpData {
  String? firstName;
  String? lastName;
  String? email;
  String? photo;
  String? phone;
  String? gender;
  String? vehicleColor;
  String? vehicleModel;
  String? vehiclePlate;
  String? deliveryMethod;
  String? password;
  String? nationalIdFront;
  String? nationalIdBack;
  String? userFirebaseToken;
  String? userFirebaseId;
  String? nationalIdNumber;
  List<String?>? cityIdList;

  SignUpData({
    this.firstName,
    this.lastName,
    this.email,
    this.photo,
    this.phone,
    this.gender,
    this.password,
    this.vehicleColor,
    this.userFirebaseToken,
    this.userFirebaseId,
    this.vehicleModel,
    this.vehiclePlate,
    this.deliveryMethod,
    this.nationalIdFront,
    this.nationalIdBack,
    this.nationalIdNumber,
    this.cityIdList,
  });

  @override
  String toString() {
    return 'SignUpData{firstName: $firstName, lastName: $lastName, email: $email, photo: $photo, phone: $phone, gender: $gender, vehicleColor: $vehicleColor, vehicleModel: $vehicleModel, vehiclePlate: $vehiclePlate, deliveryMethod: $deliveryMethod, password: $password, nationalIdFront: $nationalIdFront, nationalIdBack: $nationalIdBack, userFirebaseToken: $userFirebaseToken, userFirebaseId: $userFirebaseId, nationalIdNumber: $nationalIdNumber, cityIdList: $cityIdList}';
  }
}
