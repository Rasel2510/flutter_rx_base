// ignore_for_file: constant_identifier_names

/// HTTP and local response messages used across the app.
final class ResponseMessage {
  ResponseMessage._();

  /// Success with data.
  static const String SUCCESS = 'Success';

  /// Success with no data.
  static const String NO_CONTENT = 'Success with no content';

  /// Failure — API rejected request.
  static const String BAD_REQUEST = 'Bad request. Try again later';

  /// Failure — user is not authorized.
  static const String UNAUTORISED = 'User unauthorized. Try again later';

  /// Failure — forbidden request.
  static const String FORBIDDEN = 'Forbidden request. Try again later';

  /// Failure — crash on the server side.
  static const String INTERNAL_SERVER_ERROR =
      'Something went wrong. Try again later';

  /// Failure — resource not found.
  static const String NOT_FOUND = 'URL not found. Try again later';

  /// Local — connection timed out.
  static const String CONNECT_TIMEOUT = 'Timeout. Try again later';

  /// Local — request was cancelled.
  static const String CANCEL = 'Request canceled';

  /// Local — receive timed out.
  static const String RECIEVE_TIMEOUT = 'Timeout. Try again later';

  /// Local — send timed out.
  static const String SEND_TIMEOUT = 'Timeout. Try again later';

  /// Local — cache error.
  static const String CACHE_ERROR = 'Cache error. Try again later';

  /// Local — no internet connection.
  static const String NO_INTERNET_CONNECTION =
      'Please check your internet connection';

  /// Local — default fallback.
  static const String DEFAULT = 'Something went wrong';

  /// Local — OTP verification required.
  static const String OTP_VERIFY = 'Verify OTP';
}

/// HTTP and local response codes used across the app.
final class ResponseCode {
  ResponseCode._();

  /// 200 — success with data.
  static const int SUCCESS = 200;

  /// 201 — success with no data.
  static const int NO_CONTENT = 201;

  /// 400 — API rejected request.
  static const int BAD_REQUEST = 400;

  /// 401 — user is not authorised.
  static const int UNAUTORISED = 401;

  /// 403 — OTP verification required.
  static const int OTP_VERIFY = 403;

  /// 404 — resource not found.
  static const int NOT_FOUND = 404;

  /// 500 — crash on server side.
  static const int INTERNAL_SERVER_ERROR = 500;

  // ─── Local codes ────────────────────────────────────────────────────────────

  /// -1 — connection timeout.
  static const int CONNECT_TIMEOUT = -1;

  /// -2 — request cancelled.
  static const int CANCEL = -2;

  /// -3 — receive timeout.
  static const int RECIEVE_TIMEOUT = -3;

  /// -4 — send timeout.
  static const int SEND_TIMEOUT = -4;

  /// -5 — cache error.
  static const int CACHE_ERROR = -5;

  /// -6 — no internet connection.
  static const int NO_INTERNET_CONNECTION = -6;

  /// -7 — default fallback.
  static const int DEFAULT = -7;
}
