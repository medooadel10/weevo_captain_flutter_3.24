import '../../../../core/data/models/city_model.dart';
import '../../../../core/data/models/state_model.dart';
import '../../../products/data/models/shipment_product_model.dart';

class ShipmentModel {
  final int id;
  final StateModel? receivingStateModel; // nullable for bulk shipment
  final CityModel? receivingCityModel; // nullable for bulk shipment
  final String? receivingCity;
  final String? receivingState;
  final String? receivingStreet;
  final StateModel? deliveringStateModel;
  final CityModel? deliveringCityModel;
  final String? deliveringCity;
  final String? deliveringState;
  final String? deliveringStreet;
  final String? paymentMethod;
  final String? amount; // Product Price
  final String? price; // Shipment price // nullable for normal shipment
  final String? createdAt;
  final List<ShipmentProductModel>? products; // nullable for wasully shipment
  final String? image; // nullable for normal shipment
  final String? slug; // nullable for normal shipment
  final String? title; // nullable for normal shipment
  final int? tip;
  final String? expectedShippingCost;
  final String? agreedShippingCost;
  final List<ShipmentModel>?
      children; // nullable for normal shipment && wasully
  final String? status;
  final int? isOfferBased;
  final String? agreedShippingCostAfterDiscount;
  final String? flags;
  ShipmentModel({
    required this.id,
    required this.receivingStateModel,
    required this.receivingCityModel,
    required this.receivingStreet,
    required this.deliveringStateModel,
    required this.deliveringCityModel,
    required this.deliveringStreet,
    required this.paymentMethod,
    required this.amount,
    required this.price,
    required this.createdAt,
    required this.products,
    required this.image,
    required this.slug,
    required this.title,
    required this.tip,
    required this.expectedShippingCost,
    required this.agreedShippingCost,
    required this.children,
    required this.status,
    required this.isOfferBased,
    required this.receivingCity,
    required this.receivingState,
    required this.deliveringCity,
    required this.deliveringState,
    required this.agreedShippingCostAfterDiscount,
    required this.flags,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) => ShipmentModel(
        id: json["id"],
        receivingStateModel: StateModel.fromJson(json["receiving_state_model"]),
        receivingCityModel: CityModel.fromJson(json["receiving_city_model"]),
        receivingStreet: json["receiving_street"],
        deliveringStateModel:
            StateModel.fromJson(json["delivering_state_model"]),
        deliveringCityModel: CityModel.fromJson(json["delivering_city_model"]),
        deliveringStreet: json["delivering_street"],
        paymentMethod: json["payment_method"],
        amount: json["amount"],
        price: json["price"],
        createdAt: json["created_at"],
        products: json["products"] == null
            ? null
            : List<ShipmentProductModel>.from(
                json["products"].map((e) => ShipmentProductModel.fromJson(e)),
              ),
        image: json["image"],
        slug: json["slug"],
        title: json["title"],
        tip: json["tip"],
        expectedShippingCost: json["expected_shipping_cost"],
        agreedShippingCost: json["agreed_shipping_cost"],
        children: json["children"] == null
            ? null
            : List<ShipmentModel>.from(
                json["children"].map((e) => ShipmentModel.fromJson(e)),
              ),
        status: json["status"],
        isOfferBased: json["is_offer_based"],
        receivingCity: json["receiving_city"],
        receivingState: json["receiving_state"],
        deliveringCity: json["delivering_city"],
        deliveringState: json["delivering_state"],
        agreedShippingCostAfterDiscount:
            json["agreed_shipping_cost_after_discount"],
        flags: json["flags"],
      );

  ShipmentModel copyWith({
    int? id,
    StateModel? receivingStateModel,
    CityModel? receivingCityModel,
    String? receivingStreet,
    StateModel? deliveringStateModel,
    CityModel? deliveringCityModel,
    String? deliveringStreet,
    String? paymentMethod,
    String? amount,
    String? price,
    String? createdAt,
    List<ShipmentProductModel>? products,
    String? image,
    String? slug,
    String? title,
    int? tip,
    String? expectedShippingCost,
    String? agreedShippingCost,
    List<ShipmentModel>? children,
    String? status,
    int? isOfferBased,
    String? agreedShippingCostAfterDiscount,
    String? receivingCity,
    String? receivingState,
    String? deliveringCity,
    String? deliveringState,
  }) =>
      ShipmentModel(
        id: id ?? this.id,
        receivingStateModel: receivingStateModel ?? this.receivingStateModel,
        receivingCityModel: receivingCityModel ?? this.receivingCityModel,
        receivingStreet: receivingStreet ?? this.receivingStreet,
        deliveringStateModel: deliveringStateModel ?? this.deliveringStateModel,
        deliveringCityModel: deliveringCityModel ?? this.deliveringCityModel,
        deliveringStreet: deliveringStreet ?? this.deliveringStreet,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        amount: amount ?? this.amount,
        price: price ?? this.price,
        createdAt: createdAt ?? this.createdAt,
        products: products ?? this.products,
        image: image ?? this.image,
        slug: slug ?? this.slug,
        title: title ?? this.title,
        tip: tip ?? this.tip,
        expectedShippingCost: expectedShippingCost ?? this.expectedShippingCost,
        agreedShippingCost: agreedShippingCost ?? this.agreedShippingCost,
        children: children ?? children,
        status: status ?? this.status,
        isOfferBased: isOfferBased ?? this.isOfferBased,
        agreedShippingCostAfterDiscount: agreedShippingCostAfterDiscount ??
            this.agreedShippingCostAfterDiscount,
        receivingCity: receivingCity ?? this.receivingCity,
        receivingState: receivingState ?? this.receivingState,
        deliveringCity: deliveringCity ?? this.deliveringCity,
        deliveringState: deliveringState ?? this.deliveringState,
        flags: flags ?? flags,
      );
}
