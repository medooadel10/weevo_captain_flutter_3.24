class CourierCriticalUpdate {
  String? message;
  bool? shouldUpdate;

  CourierCriticalUpdate({
    this.message,
    this.shouldUpdate,
  });

  factory CourierCriticalUpdate.fromJson(Map<String, dynamic> map) =>
      CourierCriticalUpdate(
          message: map['message'], shouldUpdate: map['should_update']);

  Map<String, dynamic> tojson() => {
        'message': message,
        'should_update': shouldUpdate,
      };
}
