Future<void> safeCall<T>({
  required Future<T> Function() function,
  required void Function(T) onSuccess,
  required void Function(Exception?) onError,
}) async {
  try {
    var result = await function();
    onSuccess(result);
  } catch (e) {
    onError(e is Exception ? e : Exception(e.toString()));
  }
}