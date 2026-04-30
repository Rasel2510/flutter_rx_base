import 'package:dio_ansi_logger/dio_ansi_logger.dart';
import 'package:rxdart/subjects.dart';

/// Abstract base class for all reactive API data layers.
///
/// Extend this class for every API call in your app:
///
/// ```dart
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
abstract class RxResponseInt<T> {
  /// The empty/default value emitted on [clean].
  T empty;

  /// The primary [BehaviorSubject] stream for this data.
  BehaviorSubject<T> dataFetcher;

  /// Optional secondary map stream for extra data.
  Map? map;

  /// Optional secondary [BehaviorSubject] for extra stream data.
  BehaviorSubject? dataFetcher2;

  /// Creates an [RxResponseInt] with required [empty] and [dataFetcher].
  RxResponseInt({
    required this.empty,
    required this.dataFetcher,
    this.map,
    this.dataFetcher2,
  });

  /// Adds [data] to the stream and returns it.
  ///
  /// Override to add custom success handling.
  dynamic handleSuccessWithReturn(T data) {
    dataFetcher.sink.add(data);
    return data;
  }

  /// Logs [error], adds it to the stream error channel, and rethrows.
  ///
  /// Override to add custom error handling.
  dynamic handleErrorWithReturn(dynamic error) {
    AnsiLog.error(
      'Stream error in ${runtimeType.toString()}',
      error: error,
      tag: runtimeType.toString(),
    );
    dataFetcher.sink.addError(error);
    return false;
  }

  /// Resets the stream to the [empty] value.
  void clean() {
    dataFetcher.sink.add(empty);
  }

  /// Closes the stream. Call this in your widget's dispose method.
  void dispose() {
    dataFetcher.close();
  }
}
