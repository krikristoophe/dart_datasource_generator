/// Http method used to make request
enum HttpMethod {
  /// GET
  get,

  /// POST
  post,

  /// PUT
  put,

  /// PATCH
  patch,

  /// DELETE
  delete;

  /// Get [HttpMethod] from value's index
  static HttpMethod fromIndex(int index) {
    return HttpMethod.values[index];
  }
}
