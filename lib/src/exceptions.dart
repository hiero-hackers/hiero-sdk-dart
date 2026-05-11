import 'package:hiero_sdk_dart/src/response_code.dart';

class PrecheckError implements Exception {
  final int statusCode;

  final dynamic transactionId;

  final String message;

  PrecheckError({dynamic statusOrCode, this.transactionId, String? message})
    : statusCode = statusOrCode is int
          ? statusOrCode
          : (statusOrCode as ResponseCode).code,
      message = message ?? _buildPrecheckMessage(statusOrCode, transactionId);

  static String _buildPrecheckMessage(
    dynamic statusOrCode,
    dynamic transactionId,
  ) {
    final int code = statusOrCode is int
        ? statusOrCode
        : (statusOrCode as ResponseCode).code;
    final String statusName = statusOrCode is ResponseCode
        ? statusOrCode.name
        : 'UNKNOWN';
    String msg = 'Transaction failed precheck with status: $statusName ($code)';
    if (transactionId != null) {
      msg += ', transaction ID: $transactionId';
    }
    return msg;
  }

  String get status => ResponseCode.knownNames[statusCode] ?? 'UNKNOWN';

  @override
  String toString() => message;
}

class MaxAttemptsError implements Exception {
  final String nodeId;

  final Exception? lastError;

  final String message;

  MaxAttemptsError(String message, this.nodeId, this.lastError)
    : message = lastError != null
          ? '$message; last error: ${lastError.toString()}'
          : message;

  @override
  String toString() => message;
}

class ReceiptStatusError implements Exception {
  final int statusCode;

  final dynamic transactionId;

  final dynamic transactionReceipt;

  final String message;

  ReceiptStatusError(
    dynamic statusOrCode,
    this.transactionId,
    this.transactionReceipt,
    String? message,
  ) : statusCode = statusOrCode is int
          ? statusOrCode
          : (statusOrCode as ResponseCode).code,
      message = message ?? _buildReceiptMessage(statusOrCode, transactionId);

  static String _buildReceiptMessage(
    dynamic statusOrCode,
    dynamic transactionId,
  ) {
    final int code = statusOrCode is int
        ? statusOrCode
        : (statusOrCode as ResponseCode).code;
    if (transactionId != null) {
      return 'Receipt for transaction $transactionId contained error status: ${ResponseCode.knownNames[code] ?? "UNKNOWN"} ($code)';
    } else {
      return 'Receipt contained error status: ${ResponseCode.knownNames[code] ?? "UNKNOWN"} ($code)';
    }
  }

  @override
  String toString() => message;
}
