// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:dio_ansi_logger/dio_ansi_logger.dart';
import 'package:get/get.dart';

import 'error_response.dart';

/// All possible API and network failure states.
enum DataSource {
  /// 200 — success with data.
  SUCCESS,

  /// 201 — success with no content.
  NO_CONTENT,

  /// 400 — bad request.
  BAD_REQUEST,

  /// 401 — unauthorized.
  UNAUTORISED,

  /// 404 — not found.
  NOT_FOUND,

  /// 500 — internal server error.
  INTERNAL_SERVER_ERROR,

  /// Local — connection timeout.
  CONNECT_TIMEOUT,

  /// Local — request cancelled.
  CANCEL,

  /// Local — receive timeout.
  RECIEVE_TIMEOUT,

  /// Local — send timeout.
  SEND_TIMEOUT,

  /// Local — cache error.
  CACHE_ERROR,

  /// Local — no internet connection.
  NO_INTERNET_CONNECTION,

  /// Local — OTP verification required.
  OTP_VERIFY,

  /// Local — default fallback.
  DEFAULT,
}

/// Extension on [DataSource] to get a [Failure] from each state.
extension DataSourceExtension on DataSource {
  /// Returns the [Failure] associated with this [DataSource].
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS.tr);
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT.tr);
      case DataSource.BAD_REQUEST:
        return Failure(
            ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST.tr);
      case DataSource.UNAUTORISED:
        return Failure(
            ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED.tr);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND.tr);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR,
            ResponseMessage.INTERNAL_SERVER_ERROR.tr);
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
            ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT.tr);
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL.tr);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
            ResponseCode.RECIEVE_TIMEOUT, ResponseMessage.RECIEVE_TIMEOUT.tr);
      case DataSource.SEND_TIMEOUT:
        return Failure(
            ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT.tr);
      case DataSource.CACHE_ERROR:
        return Failure(
            ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR.tr);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION,
            ResponseMessage.NO_INTERNET_CONNECTION.tr);
      case DataSource.OTP_VERIFY:
        return Failure(ResponseCode.OTP_VERIFY, ResponseMessage.OTP_VERIFY);
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT.tr);
    }
  }
}

/// Represents an API or network failure with a code and message.
final class Failure {
  /// The HTTP or local response code.
  final int resonseCode;

  /// The human-readable error message.
  final String responseMessage;

  /// Creates a [Failure] with the given [resonseCode] and [responseMessage].
  const Failure(this.resonseCode, this.responseMessage);
}

/// Handles [DioException] and generic errors, mapping them to [Failure].
///
/// ```dart
/// final failure = ErrorHandler.handle(error).failure;
/// ```
final class ErrorHandler implements Exception {
  /// The resolved [Failure] after handling the error.
  late Failure failure;

  /// Handles [error] — either a [DioException] or a generic error.
  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else {
      AnsiLog.error('Unexpected error', error: error, tag: 'ErrorHandler');
      failure = DataSource.DEFAULT.getFailure();
    }
  }

  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.RECIEVE_TIMEOUT.getFailure();
      case DioExceptionType.badResponse:
        if (error.response != null &&
            error.response?.statusCode != null &&
            error.response?.statusMessage != null) {
          return Failure(
            error.response?.statusCode ?? 0,
            error.response?.statusMessage ?? '',
          );
        } else {
          return DataSource.DEFAULT.getFailure();
        }
      case DioExceptionType.cancel:
        return DataSource.CANCEL.getFailure();
      default:
        return DataSource.DEFAULT.getFailure();
    }
  }
}
