/// An exception thrown by Heck.
class HeckException implements Exception {
  final String? message;
  final Error? error;
  final Exception? exception;

  // Create a heck exception with an optional cause.
  HeckException(this.message, [this.exception]) : error = null;

  // Create a heck exception from an error.
  HeckException.fromError(this.message, [this.error]) : exception = null;

  @override
  String toString() {
    String err = 'HeckException: $message';
    if (error != null) {
      err += '. Error: $error';
    }
    if (exception != null) {
      err += '. Exception: $exception';
    }
    return err;
  }
}
