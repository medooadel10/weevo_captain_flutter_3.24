class Img {
  String? token;
  String? message;
  String? filename;
  String? path;

  Img({this.token, this.message, this.filename, this.path});

  Img.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    message = json['message'];
    filename = json['filename'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['message'] = message;
    data['filename'] = filename;
    data['path'] = path;
    return data;
  }

  @override
  String toString() =>
      'Img{token: $token, message: $message, filename: $filename, path: $path}';
}
