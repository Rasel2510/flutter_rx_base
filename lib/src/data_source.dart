// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:dio_ansi_logger/dio_ansi_logger.dart';

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
        return const Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS );
      case DataSource.NO_CONTENT:
        return const Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT );
      case DataSource.BAD_REQUEST:
        return const Failure(
            ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST );
      case DataSource.UNAUTORISED:
        return const Failure(
            ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED );
      case DataSource.NOT_FOUND:
        return const Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND );
      case DataSource.INTERNAL_SERVER_ERROR:
        return const Failure(ResponseCode.INTERNAL_SERVER_ERROR,
            ResponseMessage.INTERNAL_SERVER_ERROR );
      case DataSource.CONNECT_TIMEOUT:
        return const Failure(
            ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT );
      case DataSource.CANCEL:
        return const Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL );
      case DataSource.RECIEVE_TIMEOUT:
        return const Failure(
            ResponseCode.RECIEVE_TIMEOUT, ResponseMessage.RECIEVE_TIMEOUT );
      case DataSource.SEND_TIMEOUT:
        return const Failure(
            ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT );
      case DataSource.CACHE_ERROR:
        return const Failure(
            ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR );
      case DataSource.NO_INTERNET_CONNECTION:
        return const Failure(ResponseCode.NO_INTERNET_CONNECTION,
            ResponseMessage.NO_INTERNET_CONNECTION );
      case DataSource.OTP_VERIFY:
        return const Failure(ResponseCode.OTP_VERIFY, ResponseMessage.OTP_VERIFY);
      case DataSource.DEFAULT:
        return const Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT );
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
