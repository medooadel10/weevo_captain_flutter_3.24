class WasullyApplyShipmentResponse {
  final int id;
  final String description;
  final String title;
  final String slug;
  final CaptainModel captainModel;
  final int merchantId;
  final String status;

  WasullyApplyShipmentResponse(
    this.id,
    this.description,
    this.title,
    this.slug,
    this.status,
    this.captainModel,
    this.merchantId,
  );

  factory WasullyApplyShipmentResponse.fromJson(Map<String, dynamic> json) =>
      WasullyApplyShipmentResponse(
        json['id'] as int,
        json['description'] as String,
        json['title'] as String,
        json['slug'] as String,
        json['status'] as String,
        CaptainModel.fromJson(json['courier'] as Map<String, dynamic>),
        json['merchant_id'] as int,
      );
}

class CaptainModel {
  final int id;
  final String name;
  final String email;
  final String? photo;
  final String gender;

  CaptainModel(this.id, this.name, this.email, this.photo, this.gender);

  factory CaptainModel.fromJson(Map<String, dynamic> json) => CaptainModel(
        json['id'],
        json['name'],
        json['email'],
        json['photo'],
        json['gender'],
      );
}
