import 'product.dart';

class ChildShipment {
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
  String? flags;
  String? shippingCost;
  String? agreedShippingCost;
  String? agreedShippingCostAfterDiscount;
  int? isOfferBased;
  int? merchantId;
  int? courierId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Product>? products;
  ReceivingStateModel? receivingStateModel;
  ReceivingCityModel? receivingCityModel;
  ReceivingStateModel? deliveringStateModel;
  ReceivingCityModel? deliveringCityModel;
  dynamic distanceFromLocationToPickup;
  dynamic distanceFromPickupToDeliver;

  ChildShipment({
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
    this.clientName,
    this.clientPhone,
    this.notes,
    this.paymentMethod,
    this.amount,
    this.shippingCost,
    this.agreedShippingCost,
    this.agreedShippingCostAfterDiscount,
    this.receivingStateModel,
    this.receivingCityModel,
    this.deliveringStateModel,
    this.deliveringCityModel,
    this.isOfferBased,
    this.merchantId,
    this.courierId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.products,
    this.distanceFromLocationToPickup,
    this.distanceFromPickupToDeliver,
  });

  ChildShipment.fromJson(Map<String, dynamic> json) {
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
    flags = json['flags'];
    dateToReceiveShipment = json['date_to_receive_shipment'];
    deliveringState = json['delivering_state'];
    deliveringCity = json['delivering_city'];
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
    deliveringStreet = json['delivering_street'];
    deliveringLandmark = json['delivering_landmark'];
    deliveringBuildingNumber = json['delivering_building_number'];
    deliveringFloor = json['delivering_floor'];
    deliveringApartment = json['delivering_apartment'];
    deliveringLat = json['delivering_lat'];
    deliveringLng = json['delivering_lng'];
    dateToDeliverShipment = json['date_to_deliver_shipment'];
    clientName = json['client_name'];
    clientPhone = json['client_phone'];
    notes = json['notes'];
    distanceFromLocationToPickup = json['distance_from_location_to_pickup'];
    distanceFromPickupToDeliver = json['distance_from_pickup_to_deliver'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    shippingCost = json['expected_shipping_cost'];
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
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Product.fromJson(v));
      });
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
    data['flags'] = flags;
    data['date_to_receive_shipment'] = dateToReceiveShipment;
    data['delivering_state'] = deliveringState;
    data['delivering_city'] = deliveringCity;
    data['distance_from_pickup_to_deliver'] = distanceFromPickupToDeliver;
    data['distance_from_location_to_pickup'] = distanceFromLocationToPickup;
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
    data['delivering_street'] = deliveringStreet;
    data['delivering_landmark'] = deliveringLandmark;
    data['delivering_building_number'] = deliveringBuildingNumber;
    data['delivering_floor'] = deliveringFloor;
    data['delivering_apartment'] = deliveringApartment;
    data['delivering_lat'] = deliveringLat;
    data['delivering_lng'] = deliveringLng;
    data['date_to_deliver_shipment'] = dateToDeliverShipment;
    data['client_name'] = clientName;
    data['client_phone'] = clientPhone;
    data['notes'] = notes;
    data['payment_method'] = paymentMethod;
    data['amount'] = amount;
    data['expected_shipping_cost'] = shippingCost;
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
    if (products != null) {
      data['products'] = products?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'ChildShipment{receivingState: $receivingState, receivingCity: $receivingCity, receivingStreet: $receivingStreet, receivingLandmark: $receivingLandmark, receivingBuildingNumber: $receivingBuildingNumber, receivingFloor: $receivingFloor, receivingApartment: $receivingApartment, receivingLat: $receivingLat, receivingLng: $receivingLng, dateToReceiveShipment: $dateToReceiveShipment, deliveringState: $deliveringState, deliveringCity: $deliveringCity, deliveringStreet: $deliveringStreet, deliveringLandmark: $deliveringLandmark, deliveringBuildingNumber: $deliveringBuildingNumber, deliveringFloor: $deliveringFloor, deliveringApartment: $deliveringApartment, deliveringLat: $deliveringLat, deliveringLng: $deliveringLng, dateToDeliverShipment: $dateToDeliverShipment, clientName: $clientName, clientPhone: $clientPhone, notes: $notes, paymentMethod: $paymentMethod, amount: $amount, shippingCost: $shippingCost, merchantId: $merchantId, courierId: $courierId, status: $status, updatedAt: $updatedAt, createdAt: $createdAt, id: $id, products: $products}';
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
