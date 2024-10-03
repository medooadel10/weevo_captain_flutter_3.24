class DataResult<T> {
  T? data;
  String? error;
  bool? success;
  DataResult({
    this.data,
    this.error,
    this.success,
  });

  factory DataResult.success(T data) {
    return DataResult(data: data, success: true);
  }

  factory DataResult.failure(String error) {
    return DataResult(error: error, success: false);
  }
}
