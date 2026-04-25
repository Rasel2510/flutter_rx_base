# Changelog

## 1.0.0

- Initial release 🎉
- `RxResponseInt<T>` — abstract base class for all reactive API layers
  - `handleSuccessWithReturn()` — adds data to stream and returns it
  - `handleErrorWithReturn()` — logs error with `AnsiLog`, adds to error stream
  - `clean()` — resets stream to empty value
  - `dispose()` — closes the stream
- `ErrorHandler` — maps `DioException` and generic errors to `Failure`
- `DataSource` — enum of all possible API/network failure states
- `Failure` — simple model with `resonseCode` and `responseMessage`
- `ResponseCode` — HTTP and local response code constants
- `ResponseMessage` — HTTP and local response message constants
- Uses `AnsiLog` from `dio_ansi_logger` for colored error logging
- Pure Dart — no Flutter SDK dependency
