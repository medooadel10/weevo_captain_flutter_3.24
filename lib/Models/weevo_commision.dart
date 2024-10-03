// To parse this JSON data, do
//
//     final weevoCommision = weevoCommisionFromJson(jsonString);

import 'dart:convert';

WeevoCommision weevoCommisionFromJson(String str) =>
    WeevoCommision.fromJson(json.decode(str));

String weevoCommisionToJson(WeevoCommision data) => json.encode(data.toJson());

class WeevoCommision {
  WeevoCommision({
    this.fixedOrPercentage,
    this.commissionRate,
  });

  String? fixedOrPercentage;
  int? commissionRate;

  factory WeevoCommision.fromJson(Map<String, dynamic> json) => WeevoCommision(
        fixedOrPercentage: json["fixed_or_percentage"],
        commissionRate: json["commission_rate"],
      );

  Map<String, dynamic> toJson() => {
        "fixed_or_percentage": fixedOrPercentage,
        "commission_rate": commissionRate,
      };
}
