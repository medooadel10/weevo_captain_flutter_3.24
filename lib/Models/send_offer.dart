import 'send_offer_entity.dart';

class SendOffer {
  String? message;
  Entity? entity;
  bool? alreadyExist;

  SendOffer({this.message, this.entity, this.alreadyExist});

  SendOffer.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    entity = json['entity'] != null ? Entity.fromJson(json['entity']) : null;
    alreadyExist = json['alreadyExist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (entity != null) {
      data['entity'] = entity?.toJson();
    }
    data['alreadyExist'] = alreadyExist;
    return data;
  }
}
