class UpdateUserData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? photo;
  String? gender;
  String? brandName;
  String? dateOfBirth;
  int? currentAddressId;

  UpdateUserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.photo,
    this.dateOfBirth,
    this.brandName,
    this.currentAddressId,
    this.gender,
  });

  factory UpdateUserData.fromJson(Map<String, dynamic> map) {
    return UpdateUserData(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      phone: map['phone'],
      gender: map['gender'],
      dateOfBirth: map['date_of_birth'],
      brandName: map['brand_name'],
      currentAddressId: map['address_book_default_id'],
      photo: map['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'address_book_default_id': currentAddressId,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'brand_name': brandName,
      'photo': photo,
    };
  }
}
