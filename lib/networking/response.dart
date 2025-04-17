class BetterAuthClientResponse<T, E extends Exception> {
  final T? data;
  final E? error;

  BetterAuthClientResponse({this.data, this.error});

  bool get isSuccess => error == null;

  bool get isError => error != null;
}
