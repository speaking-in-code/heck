class EmulatorException implements Exception {
  final String? message;
  final Error? error;
  final Exception? exception;

  EmulatorException(this.message, [this.exception]) : error = null;
  EmulatorException.fromError(this.message, [this.error]) : exception = null;

  @override
  String toString() {
    String err = 'EmulatorException: $message';
    if (error != null) {
      err += '. Error: $error';
    }
    if (exception != null) {
      err += '. Exception: $exception';
    }
    return err;
  }
}
