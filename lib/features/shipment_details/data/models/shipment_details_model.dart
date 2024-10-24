import 'package:json_annotation/json_annotation.dart';

import '../../../../core/data/models/city_model.dart';
import '../../../../core/data/models/merchant_model.dart';
import '../../../../core/data/models/state_model.dart';
import 'product_model.dart';

part 'shipment_details_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ShipmentDetailsModel {
  final int id;
  final int? parentId;
  final String? receivingState;
  final String? receivingCity;
  final String? receivingStreet;
  final String? receivingLandmark;
  final String? receivingBuildingNumber;
  final String? receivingFloor;
  final String? receivingApartment;
  final String? receivingLat;
  final String? receivingLng;
  final String? dateToReceiveShipment;
  final String? deliveringState;
  final String? deliveringCity;
  final String? deliveringStreet;
  final String? deliveringLandmark;
  final String? deliveringBuildingNumber;
  final String? deliveringFloor;
  final String? deliveringApartment;
  final String? deliveringLat;
  final String? deliveringLng;
  final String? dateToDeliverShipment;
  final String? clientName;
  final String? clientPhone;
  final String? notes;
  final String? paymentMethod;
  final String? amount;
  final String? expectedShippingCost;
  final String? agreedShippingCost;
  final String? agreedShippingCostAfterDiscount;
  final int? merchantId;
  final int? courierId;
  final String status;
  final String? handoverCodeCourierToMerchant;
  final String? handoverQrcodeCourierToMerchant;
  final String? handoverCodeMerchantToCourier;
  final String? handoverQrcodeMerchantToCourier;
  final String? handoverCodeCourierToCustomer;
  final String? handoverQrcodeCourierToCustomer;
  final int? isOfferBased;
  final int? closed;
  final String flags;
  final StateModel? receivingStateModel;
  final CityModel? receivingCityModel;
  final StateModel? deliveringStateModel;
  final CityModel? deliveringCityModel;
  final String? updatedAt;
  final String? createdAt;
  final List<ProductModel>? products;
  final List<ShipmentDetailsModel>? children;
  final MerchantModel? merchant;
  final dynamic distanceFromLocationToPickup;
  final dynamic distanceFromPickupToDeliver;

  ShipmentDetailsModel(
    this.id,
    this.parentId,
    this.receivingState,
    this.receivingCity,
    this.receivingStreet,
    this.receivingLandmark,
    this.receivingBuildingNumber,
    this.receivingFloor,
    this.receivingApartment,
    this.receivingLat,
    this.receivingLng,
    this.dateToReceiveShipment,
    this.deliveringState,
    this.deliveringCity,
    this.deliveringStreet,
    this.deliveringLandmark,
    this.deliveringBuildingNumber,
    this.deliveringFloor,
    this.deliveringApartment,
    this.deliveringLat,
    this.deliveringLng,
    this.dateToDeliverShipment,
    this.clientName,
    this.clientPhone,
    this.notes,
    this.paymentMethod,
    this.amount,
    this.expectedShippingCost,
    this.agreedShippingCost,
    this.agreedShippingCostAfterDiscount,
    this.merchantId,
    this.courierId,
    this.status,
    this.handoverCodeCourierToMerchant,
    this.handoverQrcodeCourierToMerchant,
    this.handoverCodeMerchantToCourier,
    this.handoverQrcodeMerchantToCourier,
    this.handoverCodeCourierToCustomer,
    this.handoverQrcodeCourierToCustomer,
    this.isOfferBased,
    this.closed,
    this.flags,
    this.receivingStateModel,
    this.receivingCityModel,
    this.deliveringStateModel,
    this.deliveringCityModel,
    this.updatedAt,
    this.createdAt,
    this.products,
    this.children,
    this.merchant,
    this.distanceFromLocationToPickup,
    this.distanceFromPickupToDeliver,
  );

  factory ShipmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => {
        'id': id,
        'parent_id': parentId,
        'receiving_state': receivingState,
        'receiving_city': receivingCity,
        'receiving_street': receivingStreet,
        'receiving_landmark': receivingLandmark,
        'receiving_building_number': receivingBuildingNumber,
        'receiving_floor': receivingFloor,
        'receiving_apartment': receivingApartment,
        'receiving_lat': receivingLat,
        'receiving_lng': receivingLng,
        'date_to_receive_shipment': dateToReceiveShipment,
        'delivering_state': deliveringState,
        'delivering_city': deliveringCity,
        'delivering_street': deliveringStreet,
        'delivering_landmark': deliveringLandmark,
        'delivering_building_number': deliveringBuildingNumber,
        'delivering_floor': deliveringFloor,
        'delivering_apartment': deliveringApartment,
        'delivering_lat': deliveringLat,
        'delivering_lng': deliveringLng,
        'date_to_deliver_shipment': dateToDeliverShipment,
        'client_name': clientName,
        'client_phone': clientPhone,
        'notes': notes,
        'payment_method': paymentMethod,
        'amount': amount,
        'expected_shipping_cost': expectedShippingCost,
        'agreed_shipping_cost': agreedShippingCost,
        'agreed_shipping_cost_after_discount': agreedShippingCostAfterDiscount,
        'merchant_id': merchantId,
        'courier_id': courierId,
        'status': status,
        'handover_code_courier_to_merchant': handoverCodeCourierToMerchant,
        'handover_qrcode_courier_to_merchant': handoverQrcodeCourierToMerchant,
        'handover_code_merchant_to_courier': handoverCodeMerchantToCourier,
        'handover_qrcode_merchant_to_courier': handoverQrcodeMerchantToCourier,
        'handover_code_courier_to_customer': handoverCodeCourierToCustomer,
        'handover_qrcode_courier_to_customer': handoverQrcodeCourierToCustomer,
        'is_offer_based': isOfferBased,
        'closed': closed,
        'flags': flags,
        'receiving_state_model': receivingStateModel?.toJson(),
        'receiving_city_model': receivingCityModel?.toJson(),
        'delivering_state_model': deliveringStateModel?.toJson(),
        'delivering_city_model': deliveringCityModel?.toJson(),
        'updated_at': updatedAt,
        'created_at': createdAt,
        'products': products?.map((e) => e.toJson()).toList(),
        'children': children?.map((e) => e.toJson()).toList(),
        'courier': merchant?.toJson(),
      };
}
