/// A lightweight base package for reactive API data layers in Flutter apps.
///
/// Provides [RxResponseInt], [ErrorHandler], [DataSource], [Failure],
/// [ResponseCode], and [ResponseMessage] — the boilerplate you copy into
/// every project, now in one dependency.
///
/// ## Quick Start
/// ```dart
/// import 'package:flutter_rx_base/flutter_rx_base.dart';
///
/// class GetProfileRx extends RxResponseInt<ProfileModel> {
///   GetProfileRx({required super.empty, required super.dataFetcher});
///
///   Future<void> getProfile() async {
///     try {
///       final data = await api.getProfile();
///       handleSuccessWithReturn(data);
///     } catch (e) {
///       handleErrorWithReturn(e);
///     }
///   }
/// }
/// ```
library flutter_rx_base;

export 'src/rx_response_int.dart';
export 'src/data_source.dart';
export 'src/error_response.dart';
