import 'child_shipment.dart';
import 'merchant_object.dart';
import 'product.dart';

class BulkShipment {
  int? id;
  int? parentId;
  String? receivingState;
  String? receivingCity;
  String? receivingStreet;
  String? receivingLandmark;
  String? receivingBuildingNumber;
  String? receivingFloor;
  String? receivingApartment;
  String? receivingLat;
  String? receivingLng;
  String? dateToReceiveShipment;
  String? deliveringState;
  String? deliveringCity;
  String? deliveringStreet;
  String? deliveringLandmark;
  String? deliveringBuildingNumber;
  String? deliveringFloor;
  String? deliveringApartment;
  String? deliveringLat;
  String? deliveringLng;
  String? dateToDeliverShipment;
  String? clientName;
  String? clientPhone;
  String? notes;
  String? paymentMethod;
  String? amount;
  String? expectedShippingCost;
  String? agreedShippingCost;
  String? agreedShippingCostAfterDiscount;
  int? isOfferBased;
  int? merchantId;
  ReceivingStateModel? receivingStateModel;
  ReceivingCityModel? receivingCityModel;
  ReceivingStateModel? deliveringStateModel;
  ReceivingCityModel? deliveringCityModel;
  int? courierId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? handoverCodeCourierToMerchant;
  String? handoverQrcodeCourierToMerchant;
  String? handoverCodeMerchantToCourier;
  String? handoverQrcodeMerchantToCourier;
  String? handoverCodeCourierToCustomer;
  String? handoverQrcodeCourierToCustomer;
  String? flags;
  List<ChildShipment>? children;
  List<Product>? products;
  MerchantObject? merchant;
  dynamic distanceFromLocationPickup;
  dynamic distanceFromPickupToDeliver;

  /*
    "handover_code_courier_to_merchant": null,
    "handover_qrcode_courier_to_merchant": null,
    "handover_code_merchant_to_courier": null,
    "handover_qrcode_merchant_to_courier": null,
    "handover_code_courier_to_customer": null,
    "handover_qrcode_courier_to_customer": null,*/

  BulkShipment({
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
    this.flags,
    this.deliveringApartment,
    this.deliveringLat,
    this.deliveringLng,
    this.dateToDeliverShipment,
    this.receivingStateModel,
    this.receivingCityModel,
    this.deliveringStateModel,
    this.deliveringCityModel,
    this.clientName,
    this.clientPhone,
    this.notes,
    this.paymentMethod,
    this.amount,
    this.expectedShippingCost,
    this.agreedShippingCost,
    this.agreedShippingCostAfterDiscount,
    this.isOfferBased,
    this.merchantId,
    this.courierId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.children,
    this.products,
    this.distanceFromLocationPickup,
    this.distanceFromPickupToDeliver,
  });

  BulkShipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    receivingState = json['receiving_state'];
    receivingCity = json['receiving_city'];
    receivingStreet = json['receiving_street'];
    receivingLandmark = json['receiving_landmark'];
    receivingBuildingNumber = json['receiving_building_number'];
    receivingFloor = json['receiving_floor'];
    receivingApartment = json['receiving_apartment'];
    receivingLat = json['receiving_lat'];
    receivingLng = json['receiving_lng'];
    dateToReceiveShipment = json['date_to_receive_shipment'];
    deliveringState = json['delivering_state'];
    deliveringCity = json['delivering_city'];
    deliveringStreet = json['delivering_street'];
    deliveringLandmark = json['delivering_landmark'];
    deliveringBuildingNumber = json['delivering_building_number'];
    deliveringFloor = json['delivering_floor'];
    deliveringApartment = json['delivering_apartment'];
    deliveringLat = json['delivering_lat'];
    deliveringLng = json['delivering_lng'];
    dateToDeliverShipment = json['date_to_deliver_shipment'];
    handoverCodeCourierToMerchant = json["handover_code_courier_to_merchant"];
    handoverQrcodeCourierToMerchant =
        json["handover_qrcode_courier_to_merchant"];
    handoverCodeMerchantToCourier = json["handover_code_merchant_to_courier"];
    handoverQrcodeMerchantToCourier =
        json["handover_qrcode_merchant_to_courier"];
    handoverCodeCourierToCustomer = json["handover_code_courier_to_customer"];
    handoverQrcodeCourierToCustomer =
        json["handover_qrcode_courier_to_customer"];
    clientName = json['client_name'];
    clientPhone = json['client_phone'];
    notes = json['notes'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    flags = json['flags'];
    expectedShippingCost = json['expected_shipping_cost'];
    agreedShippingCost = json['agreed_shipping_cost'];
    agreedShippingCostAfterDiscount =
        json['agreed_shipping_cost_after_discount'];
    isOfferBased = json['is_offer_based'];
    merchantId = json['merchant_id'];
    courierId = json['courier_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    distanceFromLocationPickup = json['distance_from_location_to_pickup'];
    distanceFromPickupToDeliver = json['distance_from_pickup_to_deliver'];
    receivingStateModel = json['receiving_state_model'] != null
        ? ReceivingStateModel.fromJson(json['receiving_state_model'])
        : null;
    receivingCityModel = json['receiving_city_model'] != null
        ? ReceivingCityModel.fromJson(json['receiving_city_model'])
        : null;
    deliveringStateModel = json['delivering_state_model'] != null
        ? ReceivingStateModel.fromJson(json['delivering_state_model'])
        : null;
    deliveringCityModel = json['delivering_city_model'] != null
        ? ReceivingCityModel.fromJson(json['delivering_city_model'])
        : null;
    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        children?.add(ChildShipment.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Product.fromJson(v));
      });
    }
    if (json['merchant'] != null) {
      merchant = MerchantObject.fromJson(json['merchant']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['receiving_state'] = receivingState;
    data['receiving_city'] = receivingCity;
    data['receiving_street'] = receivingStreet;
    data['receiving_landmark'] = receivingLandmark;
    data['receiving_building_number'] = receivingBuildingNumber;
    data['receiving_floor'] = receivingFloor;
    data['receiving_apartment'] = receivingApartment;
    data['receiving_lat'] = receivingLat;
    data['receiving_lng'] = receivingLng;
    data['date_to_receive_shipment'] = dateToReceiveShipment;
    data['delivering_state'] = deliveringState;
    data['delivering_city'] = deliveringCity;
    data['delivering_street'] = deliveringStreet;
    data['delivering_landmark'] = deliveringLandmark;
    data['delivering_building_number'] = deliveringBuildingNumber;
    data['delivering_floor'] = deliveringFloor;
    data['delivering_apartment'] = deliveringApartment;
    data['delivering_lat'] = deliveringLat;
    data['delivering_lng'] = deliveringLng;
    data['flags'] = flags;
    data['date_to_deliver_shipment'] = dateToDeliverShipment;
    data["handover_code_courier_to_merchant"] = handoverCodeCourierToMerchant;
    data["handover_qrcode_courier_to_merchant"] =
        handoverQrcodeCourierToMerchant;
    data["handover_code_merchant_to_courier"] = handoverCodeMerchantToCourier;
    data["handover_qrcode_merchant_to_courier"] =
        handoverQrcodeMerchantToCourier;
    data["handover_code_courier_to_customer"] = handoverCodeCourierToCustomer;
    data["handover_qrcode_courier_to_customer"] =
        handoverQrcodeCourierToCustomer;
    data['client_name'] = clientName;
    data['client_phone'] = clientPhone;
    data['notes'] = notes;
    data['payment_method'] = paymentMethod;
    data['amount'] = amount;
    data['expected_shipping_cost'] = expectedShippingCost;
    data['agreed_shipping_cost'] = agreedShippingCost;
    data['agreed_shipping_cost_after_discount'] =
        agreedShippingCostAfterDiscount;
    data['is_offer_based'] = isOfferBased;
    data['merchant_id'] = merchantId;
    data['courier_id'] = courierId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['distance_from_pickup_to_deliver'] = distanceFromPickupToDeliver;
    data['distance_from_location_to_pickup'] = distanceFromLocationPickup;
    if (receivingStateModel != null) {
      data['receiving_state_model'] = receivingStateModel?.toJson();
    }
    if (receivingCityModel != null) {
      data['receiving_city_model'] = receivingCityModel?.toJson();
    }
    if (deliveringStateModel != null) {
      data['delivering_state_model'] = deliveringStateModel?.toJson();
    }
    if (deliveringCityModel != null) {
      data['delivering_city_model'] = deliveringCityModel?.toJson();
    }
    if (children != null) {
      data['children'] = children?.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      data['products'] = products?.map((v) => v.toJson()).toList();
    }
    if (merchant != null) {
      data['merchant'] = merchant?.toJson();
    }
    return data;
  }
}

class ReceivingStateModel {
  int? id;
  String? name;
  int? countryId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ReceivingStateModel(
      {this.id,
      this.name,
      this.countryId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ReceivingStateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['country_id'] = countryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class ReceivingCityModel {
  int? id;
  String? name;
  int? stateId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ReceivingCityModel(
      {this.id,
      this.name,
      this.stateId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ReceivingCityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['state_id'] = stateId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
