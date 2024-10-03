import '../../../../Models/courier.dart';
import '../../../../Models/merchant_object.dart';
import '../../../../core/data/models/city_model.dart';
import '../../../../core/data/models/state_model.dart';

class WasullyModel {
  final int id;
  final String slug;
  final String title;
  final String image;
  final String description;
  final String price;
  final String amount;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String clientPhone;
  final String phoneUser;
  final String whoPay;
  final int? tip;
  final String paymentMethod;
  final CityModel receivingCityModel;
  final StateModel receivingStateModel;
  final CityModel deliveringCityModel;
  final StateModel deliveringStateModel;
  final String receivingCityCode;
  final String deliveringCityCode;
  final String receivingStateCode;
  final String deliveringStateCode;
  final MerchantObject merchant;
  final String receivingStreet;
  final String deliveringStreet;
  final dynamic distanceFromLocationToPickup;
  final dynamic distanceFromPickupToDeliver;
  final String receivingLng;
  final String receivingLat;
  final String deliveringLng;
  final String deliveringLat;
  final Courier courier;
  final String? handoverQrcodeCourierToCustomer;
  final String? handoverQrcodeMerchantToCourier;
  final String? handoverQrcodeCourierToMerchant;
  final String? handoverCodeCourierToCustomer;
  final String? handoverCodeMerchantToCourier;
  final String? handoverCodeCourierToMerchant;

  WasullyModel(
    this.id,
    this.slug,
    this.title,
    this.image,
    this.description,
    this.price,
    this.amount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.clientPhone,
    this.phoneUser,
    this.whoPay,
    this.tip,
    this.paymentMethod,
    this.receivingCityModel,
    this.receivingStateModel,
    this.deliveringCityModel,
    this.deliveringStateModel,
    this.merchant,
    this.receivingStreet,
    this.deliveringStreet,
    this.distanceFromLocationToPickup,
    this.distanceFromPickupToDeliver,
    this.receivingLng,
    this.receivingLat,
    this.deliveringLng,
    this.deliveringLat,
    this.courier,
    this.receivingCityCode,
    this.deliveringCityCode,
    this.receivingStateCode,
    this.deliveringStateCode,
    this.handoverQrcodeCourierToCustomer,
    this.handoverQrcodeMerchantToCourier,
    this.handoverQrcodeCourierToMerchant,
    this.handoverCodeCourierToCustomer,
    this.handoverCodeMerchantToCourier,
    this.handoverCodeCourierToMerchant,
  );

  factory WasullyModel.fromJson(Map<String, dynamic> json) => WasullyModel(
        json['id'],
        json['slug'],
        json['title'],
        json['image'],
        json['description'],
        json['price'],
        json['amount'],
        json['status'],
        json['created_at'],
        json['updated_at'],
        json['client_phone'],
        json['phone_user'],
        json['who_pay'],
        json['tip'],
        json['payment_method'],
        CityModel.fromJson(json['receiving_city_model']),
        StateModel.fromJson(json['receiving_state_model']),
        CityModel.fromJson(json['delivering_city_model']),
        StateModel.fromJson(json['delivering_state_model']),
        MerchantObject.fromJson(json['merchant']),
        json['receiving_street'],
        json['delivering_street'],
        json['distance_from_location_to_pickup'],
        json['distance_from_pickup_to_deliver'],
        json['receiving_lng'],
        json['receiving_lat'],
        json['delivering_lng'],
        json['delivering_lat'],
        Courier.fromJson(json['courier'] ?? {}),
        json['receiving_city'],
        json['delivering_city'],
        json['receiving_state'],
        json['delivering_state'],
        json['handover_qrcode_courier_to_customer'],
        json['handover_qrcode_merchant_to_courier'],
        json['handover_qrcode_courier_to_merchant'] ?? '',
        json['handover_code_courier_to_customer'],
        json['handover_code_merchant_to_courier'],
        json['handover_code_courier_to_merchant'] ?? '',
      );
}
