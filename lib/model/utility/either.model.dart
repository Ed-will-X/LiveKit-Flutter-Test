

class Response<R, E> {
  final R? success;
  final E? error;

  Response.setSuccess(this.success) : error = null;
  Response.setError(this.error) : success = null;

  bool get isSuccess => success != null;
  bool get isError => error != null;
}