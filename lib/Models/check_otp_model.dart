class CheckOtpModel {
  String? message;
  int? userId;

  CheckOtpModel({this.message, this.userId});

  CheckOtpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['user_id'] = userId;
    return data;
  }
}
