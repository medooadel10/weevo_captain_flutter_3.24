import 'package:json_annotation/json_annotation.dart';

part 'merchant_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MerchantModel {
  final int id;
  final String name;
  final String? photo;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? gender;
  final int online;
  final String? cachedAverageRating;

  MerchantModel(
      this.id,
      this.name,
      this.photo,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.gender,
      this.online,
      this.cachedAverageRating);

  factory MerchantModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantModelFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantModelToJson(this);
}
