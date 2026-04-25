# flutter_rx_base

A lightweight base package for reactive API data layers in Flutter apps.

Provides `RxResponseInt`, `ErrorHandler`, `DataSource`, `Failure`, `ResponseCode`, and `ResponseMessage` — the boilerplate you copy into every project, now in one dependency.

## Installation

```yaml
dependencies:
  flutter_rx_base: ^1.0.0
```

## Usage

### 1. Extend `RxResponseInt`

```dart
import 'package:flutter_rx_base/flutter_rx_base.dart';

class GetProfileRx extends RxResponseInt<ProfileModel> {
  final api = GetProfileApi.instance;

  GetProfileRx({required super.empty, required super.dataFetcher});

  ValueStream get streamData => dataFetcher.stream;

  Future<void> getProfile() async {
    try {
      final data = await api.getProfileApi();
      handleSuccessWithReturn(data);
    } catch (error) {
      handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(ProfileModel data) {
    AnsiLog.success('Profile loaded', tag: 'GetProfileRx');
    dataFetcher.sink.add(data);
    return super.handleSuccessWithReturn(data);
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      ToastUtil.showShortToast(error.response?.data['message'] ?? 'Error');
    }
    dataFetcher.sink.addError(error);
    return super.handleErrorWithReturn(error);
  }
}
```

### 2. Register in `api_access.dart`

```dart
GetProfileRx getProfileRxObj = GetProfileRx(
  empty: ProfileModel(),
  dataFetcher: BehaviorSubject<ProfileModel>(),
);
```

### 3. Use `ErrorHandler` in your API files

```dart
} catch (error) {
  ErrorHandler.handle(error).failure;
  rethrow;
}
```

### 4. Use `DataSource` for failure states

```dart
if (response.statusCode == 200) {
  return ProfileModel.fromJson(response.data);
} else {
  throw DataSource.DEFAULT.getFailure();
}
```

## What's included

| Class | Description |
|---|---|
| `RxResponseInt<T>` | Abstract base class for reactive API layers |
| `ErrorHandler` | Maps `DioException` to `Failure` |
| `DataSource` | Enum of all failure states |
| `Failure` | Model with `resonseCode` and `responseMessage` |
| `ResponseCode` | HTTP and local response code constants |
| `ResponseMessage` | HTTP and local response message constants |

## Dependencies

- [`rxdart`](https://pub.dev/packages/rxdart) — `BehaviorSubject`, `ValueStream`
- [`dio`](https://pub.dev/packages/dio) — `DioException` handling
- [`get`](https://pub.dev/packages/get) — `.tr` localization
- [`dio_ansi_logger`](https://pub.dev/packages/dio_ansi_logger) — colored error logging
