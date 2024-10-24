// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipmentDetailsModel _$ShipmentDetailsModelFromJson(
        Map<String, dynamic> json) =>
    ShipmentDetailsModel(
      (json['id'] as num).toInt(),
      (json['parent_id'] as num?)?.toInt(),
      json['receiving_state'] as String?,
      json['receiving_city'] as String?,
      json['receiving_street'] as String?,
      json['receiving_landmark'] as String?,
      json['receiving_building_number'] as String?,
      json['receiving_floor'] as String?,
      json['receiving_apartment'] as String?,
      json['receiving_lat'] as String?,
      json['receiving_lng'] as String?,
      json['date_to_receive_shipment'] as String?,
      json['delivering_state'] as String?,
      json['delivering_city'] as String?,
      json['delivering_street'] as String?,
      json['delivering_landmark'] as String?,
      json['delivering_building_number'] as String?,
      json['delivering_floor'] as String?,
      json['delivering_apartment'] as String?,
      json['delivering_lat'] as String?,
      json['delivering_lng'] as String?,
      json['date_to_deliver_shipment'] as String?,
      json['client_name'] as String?,
      json['client_phone'] as String?,
      json['notes'] as String?,
      json['payment_method'] as String?,
      json['amount'] as String?,
      json['expected_shipping_cost'] as String?,
      json['agreed_shipping_cost'] as String?,
      json['agreed_shipping_cost_after_discount'] as String?,
      (json['merchant_id'] as num?)?.toInt(),
      (json['courier_id'] as num?)?.toInt(),
      json['status'] as String,
      json['handover_code_courier_to_merchant'] as String?,
      json['handover_qrcode_courier_to_merchant'] as String?,
      json['handover_code_merchant_to_courier'] as String?,
      json['handover_qrcode_merchant_to_courier'] as String?,
      json['handover_code_courier_to_customer'] as String?,
      json['handover_qrcode_courier_to_customer'] as String?,
      (json['is_offer_based'] as num?)?.toInt(),
      (json['closed'] as num?)?.toInt(),
      json['flags'] as String,
      json['receiving_state_model'] == null
          ? null
          : StateModel.fromJson(
              json['receiving_state_model'] as Map<String, dynamic>?),
      json['receiving_city_model'] == null
          ? null
          : CityModel.fromJson(
              json['receiving_city_model'] as Map<String, dynamic>?),
      json['delivering_state_model'] == null
          ? null
          : StateModel.fromJson(
              json['delivering_state_model'] as Map<String, dynamic>?),
      json['delivering_city_model'] == null
          ? null
          : CityModel.fromJson(
              json['delivering_city_model'] as Map<String, dynamic>?),
      json['updated_at'] as String?,
      json['created_at'] as String?,
      (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['children'] as List<dynamic>?)
          ?.map((e) => ShipmentDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['merchant'] == null
          ? null
          : MerchantModel.fromJson(json['merchant'] as Map<String, dynamic>),
      json['distance_from_location_to_pickup'],
      json['distance_from_pickup_to_deliver'],
    );

Map<String, dynamic> _$ShipmentDetailsModelToJson(
        ShipmentDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'receiving_state': instance.receivingState,
      'receiving_city': instance.receivingCity,
      'receiving_street': instance.receivingStreet,
      'receiving_landmark': instance.receivingLandmark,
      'receiving_building_number': instance.receivingBuildingNumber,
      'receiving_floor': instance.receivingFloor,
      'receiving_apartment': instance.receivingApartment,
      'receiving_lat': instance.receivingLat,
      'receiving_lng': instance.receivingLng,
      'date_to_receive_shipment': instance.dateToReceiveShipment,
      'delivering_state': instance.deliveringState,
      'delivering_city': instance.deliveringCity,
      'delivering_street': instance.deliveringStreet,
      'delivering_landmark': instance.deliveringLandmark,
      'delivering_building_number': instance.deliveringBuildingNumber,
      'delivering_floor': instance.deliveringFloor,
      'delivering_apartment': instance.deliveringApartment,
      'delivering_lat': instance.deliveringLat,
      'delivering_lng': instance.deliveringLng,
      'date_to_deliver_shipment': instance.dateToDeliverShipment,
      'client_name': instance.clientName,
      'client_phone': instance.clientPhone,
      'notes': instance.notes,
      'payment_method': instance.paymentMethod,
      'amount': instance.amount,
      'expected_shipping_cost': instance.expectedShippingCost,
      'agreed_shipping_cost': instance.agreedShippingCost,
      'agreed_shipping_cost_after_discount':
          instance.agreedShippingCostAfterDiscount,
      'merchant_id': instance.merchantId,
      'courier_id': instance.courierId,
      'status': instance.status,
      'handover_code_courier_to_merchant':
          instance.handoverCodeCourierToMerchant,
      'handover_qrcode_courier_to_merchant':
          instance.handoverQrcodeCourierToMerchant,
      'handover_code_merchant_to_courier':
          instance.handoverCodeMerchantToCourier,
      'handover_qrcode_merchant_to_courier':
          instance.handoverQrcodeMerchantToCourier,
      'handover_code_courier_to_customer':
          instance.handoverCodeCourierToCustomer,
      'handover_qrcode_courier_to_customer':
          instance.handoverQrcodeCourierToCustomer,
      'is_offer_based': instance.isOfferBased,
      'closed': instance.closed,
      'flags': instance.flags,
      'receiving_state_model': instance.receivingStateModel,
      'receiving_city_model': instance.receivingCityModel,
      'delivering_state_model': instance.deliveringStateModel,
      'delivering_city_model': instance.deliveringCityModel,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
      'products': instance.products,
      'children': instance.children,
      'merchant': instance.merchant,
      'distance_from_location_to_pickup': instance.distanceFromLocationToPickup,
      'distance_from_pickup_to_deliver': instance.distanceFromPickupToDeliver,
    };
