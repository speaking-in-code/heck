class EmulatorException implements Exception {
  final String? message;
  final Exception? cause;

  EmulatorException(this.message, [this.cause]);

  @override
  String toString() {
    String err = 'EmulatorException: $message';
    if (cause != null) {
      err += '. Cause: $cause';
    }
    return err;
  }
}
