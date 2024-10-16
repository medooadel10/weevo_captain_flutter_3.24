class DataResult<T> {
  final T? data;
  final String error;
  final bool success;
  DataResult({
    this.data,
    required this.error,
    required this.success,
  });

  factory DataResult.success(T data) {
    return DataResult(data: data, success: true, error: '');
  }

  factory DataResult.failure(String error) {
    return DataResult(error: error, success: false);
  }
}
