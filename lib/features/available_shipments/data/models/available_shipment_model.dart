import '../../../../Models/merchant_object.dart';
import '../../../../core/data/models/city_model.dart';
import '../../../../core/data/models/state_model.dart';
import '../../../products/data/models/shipment_product_model.dart';

class AvailableShipmentModel {
  final int id;
  final String? slug; // nullable for normal shipment
  final String? title;
  final String? image; // nullable for normal shipment
  final String? description; // nullable for wasully shipment
  final String? price; // Product price
  final String? amount; // Delivery price
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? clientPhone;
  final String? phoneUser;
  final int? tip; // nullable
  final String? paymentMethod;
  final CityModel receivingCityModel;
  final StateModel receivingStateModel;
  final CityModel deliveringCityModel;
  final StateModel deliveringStateModel;
  final String? receivingCity;
  final String? receivingState;
  final String? deliveringCity;
  final String? deliveringState;
  final MerchantObject? merchant;
  final String? receivingStreet;
  final String? deliveringStreet;
  final dynamic distanceFromLocationToPickup;
  final dynamic distanceFromPickupToDeliver;
  final List<ShipmentProductModel>? products; // nullable for wasully shipment
  final String? expectedShippingCost;
  final String? agreedShippingCost;
  final List<AvailableShipmentModel>?
      children; // nullable for normal shipment && wasully
  final int isOfferBased;
  final String? agreedShippingCostAfterDiscount;
  AvailableShipmentModel(
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
    this.tip,
    this.paymentMethod,
    this.receivingCityModel,
    this.receivingStateModel,
    this.deliveringCityModel,
    this.deliveringStateModel,
    this.receivingCity,
    this.receivingState,
    this.deliveringCity,
    this.deliveringState,
    this.merchant,
    this.receivingStreet,
    this.deliveringStreet,
    this.distanceFromLocationToPickup,
    this.distanceFromPickupToDeliver,
    this.products,
    this.expectedShippingCost,
    this.agreedShippingCost,
    this.children,
    this.isOfferBased,
    this.agreedShippingCostAfterDiscount,
  );

  factory AvailableShipmentModel.fromJson(Map<String, dynamic> json) =>
      AvailableShipmentModel(
        json["id"],
        json["slug"],
        json["title"],
        json["image"],
        json["description"],
        json["price"],
        json["amount"],
        json["status"],
        json["created_at"],
        json["updated_at"],
        json["client_phone"],
        json["phone_user"],
        json["tip"],
        json["payment_method"],
        CityModel.fromJson(json["receiving_city_model"]),
        StateModel.fromJson(json["receiving_state_model"]),
        CityModel.fromJson(json["delivering_city_model"]),
        StateModel.fromJson(json["delivering_state_model"]),
        json["receiving_city"],
        json["receiving_state"],
        json["delivering_city"],
        json["delivering_state"],
        MerchantObject.fromJson(json["merchant"]),
        json["receiving_street"],
        json["delivering_street"],
        json["distance_from_location_to_pickup"],
        json["distance_from_pickup_to_deliver"],
        json["products"] == null
            ? []
            : List<ShipmentProductModel>.from((json["products"] as List)
                .map((x) => ShipmentProductModel.fromJson(x))),
        json["expected_shipping_cost"],
        json["agreed_shipping_cost"],
        json["children"] == null
            ? []
            : List<AvailableShipmentModel>.from((json["children"] as List)
                .map((x) => AvailableShipmentModel.fromJson(x))),
        json["is_offer_based"],
        json["agreed_shipping_cost_after_discount"],
      );
}
