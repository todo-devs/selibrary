class IException implements Exception {
  final String message;

  IException(this.message);
}

class CommunicationException extends IException {
  CommunicationException(String message) : super(message);
}

class OperationException extends IException {
  OperationException(String message) : super(message);
}

class CodeException extends IException {
  CodeException(String message) : super(message);
}
