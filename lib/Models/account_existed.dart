class AccountExisted {
  final String message;
  final bool existed;

  AccountExisted({
    required this.message,
    required this.existed,
  });

  factory AccountExisted.fromJson(Map<String, dynamic> map) => AccountExisted(
        message: map['message'],
        existed: map['existed'],
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'existed': existed,
      };
}
