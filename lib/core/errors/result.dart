import 'error_model.dart';

abstract class Result<T> {
  Result._();

  factory Result.success(T data) = Success<T>;

  factory Result.error(Object e) = Error<T>;

  dynamic when({
    required Function(T data) onSuccess,
    required Function(ErrorModel error) onError,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else if (this is Error<T>) {
      final error = (this as Error<T>).error;
      if (error is ErrorModel) {
        return onError(error);
      } else {
        return onError(ErrorModel(error.toString()));
      }
    }
  }
}

class Success<T> extends Result<T> {
  final T data;

  Success(this.data) : super._();
}

class Error<T> extends Result<T> {
  final Object error;

  Error(this.error) : super._();
}
