class SendOtpModel {
  String? message;
  String? name;
  int? otp;
  String? otpToken;
  num? retryAfter;

  SendOtpModel({this.message, this.name, this.otp, this.otpToken});

  SendOtpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    name = json['name'];
    otp = json['otp'];
    otpToken = json['otp_token'];
    retryAfter = json['retry_after'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['name'] = name;
    data['otp'] = otp;
    data['otp_token'] = otpToken;
    data['retry_after'] = retryAfter;
    return data;
  }
}

class ResendOtpModel {
  String? message;
  String? otpToken;
  num? retryAfter;

  ResendOtpModel({this.message, this.otpToken});

  ResendOtpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    otpToken = json['otp_token'];
    retryAfter = json['retry_after'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['otp_token'] = otpToken;
    data['retry_after'] = retryAfter;
    return data;
  }
}
