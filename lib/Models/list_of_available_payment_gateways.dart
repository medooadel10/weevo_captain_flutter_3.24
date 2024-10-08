// To parse this JSON data, do
//
//     final listOfAvailablePaymentGateways = listOfAvailablePaymentGatewaysFromJson(jsonString?);

import 'dart:convert';

List<ListOfAvailablePaymentGateways> listOfAvailablePaymentGatewaysFromJson(
        String? str) =>
    List<ListOfAvailablePaymentGateways>.from(json
        .decode(str ?? "[]")
        .map((x) => ListOfAvailablePaymentGateways.fromJson(x)));

String? listOfAvailablePaymentGatewaysToJson(
        List<ListOfAvailablePaymentGateways> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListOfAvailablePaymentGateways {
  ListOfAvailablePaymentGateways({
    this.paymentMethod,
    this.paymentGatewayHandler,
    this.depositionBankChargePercentageOrFixedFlag,
    this.depositionBankChargeValue,
    this.depositionAlwaysAppliedFixedBankChargeAmount,
    this.depositionBankChargeMessage,
    this.depositionBankChargeSecondMessage,
  });

  String? paymentMethod;
  String? paymentGatewayHandler;
  String? depositionBankChargePercentageOrFixedFlag;
  double? depositionBankChargeValue;
  double? depositionAlwaysAppliedFixedBankChargeAmount;
  String? depositionBankChargeMessage;
  String? depositionBankChargeSecondMessage;

  factory ListOfAvailablePaymentGateways.fromJson(Map<String, dynamic> json) =>
      ListOfAvailablePaymentGateways(
        paymentMethod: json["payment_method"],
        paymentGatewayHandler: json["payment_gateway_handler"],
        depositionBankChargePercentageOrFixedFlag:
            json["deposition_bank_charge_percentage_or_fixed_flag"],
        depositionBankChargeValue:
            json["deposition_bank_charge_value"].toDouble(),
        depositionAlwaysAppliedFixedBankChargeAmount:
            json["deposition_always_applied_fixed_bank_charge_amount"]
                .toDouble(),
        depositionBankChargeMessage: json["deposition_bank_charge_message"],
        depositionBankChargeSecondMessage:
            json["deposition_bank_charge_second_message"],
      );

  Map<String, dynamic> toJson() => {
        "payment_method": paymentMethod,
        "payment_gateway_handler": paymentGatewayHandler,
        "deposition_bank_charge_percentage_or_fixed_flag":
            depositionBankChargePercentageOrFixedFlag,
        "deposition_bank_charge_value": depositionBankChargeValue,
        "deposition_always_applied_fixed_bank_charge_amount":
            depositionAlwaysAppliedFixedBankChargeAmount,
        "deposition_bank_charge_message": depositionBankChargeMessage,
        "deposition_bank_charge_second_message":
            depositionBankChargeSecondMessage,
      };
}
