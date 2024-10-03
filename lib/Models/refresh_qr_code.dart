class RefreshQrcode {
  String? filename;
  String? path;
  int? code;

  RefreshQrcode({this.filename, this.path, this.code});

  RefreshQrcode.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    path = json['path'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filename'] = filename;
    data['path'] = path;
    data['code'] = code;
    return data;
  }
}
