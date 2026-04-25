import 'package:flutter_rx_base/flutter_rx_base.dart';
import 'package:rxdart/subjects.dart';
import 'package:test/test.dart';

// ─── Concrete test implementation ────────────────────────────────────────────

class TestRx extends RxResponseInt<String> {
  TestRx() : super(empty: '', dataFetcher: BehaviorSubject<String>());
}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  group('RxResponseInt', () {
    test('handleSuccessWithReturn adds data to stream', () async {
      final rx = TestRx();
      rx.handleSuccessWithReturn('hello');
      expect(await rx.dataFetcher.stream.first, equals('hello'));
      rx.dispose();
    });

    test('clean resets stream to empty value', () async {
      final rx = TestRx();
      rx.handleSuccessWithReturn('hello');
      rx.clean();
      expect(await rx.dataFetcher.stream.first, equals(''));
      rx.dispose();
    });

    test('handleErrorWithReturn adds error to stream', () async {
      final rx = TestRx();
      expect(
        () => rx.handleErrorWithReturn(Exception('test error')),
        throwsException,
      );
      rx.dispose();
    });

    test('dispose closes the stream', () {
      final rx = TestRx();
      rx.dispose();
      expect(rx.dataFetcher.isClosed, isTrue);
    });
  });

  group('ResponseCode', () {
    test('SUCCESS is 200', () => expect(ResponseCode.SUCCESS, equals(200)));
    test('NO_CONTENT is 201', () => expect(ResponseCode.NO_CONTENT, equals(201)));
    test('BAD_REQUEST is 400', () => expect(ResponseCode.BAD_REQUEST, equals(400)));
    test('UNAUTORISED is 401', () => expect(ResponseCode.UNAUTORISED, equals(401)));
    test('NOT_FOUND is 404', () => expect(ResponseCode.NOT_FOUND, equals(404)));
    test('INTERNAL_SERVER_ERROR is 500', () => expect(ResponseCode.INTERNAL_SERVER_ERROR, equals(500)));
    test('DEFAULT is -7', () => expect(ResponseCode.DEFAULT, equals(-7)));
  });

  group('ResponseMessage', () {
    test('SUCCESS message', () => expect(ResponseMessage.SUCCESS, equals('Success')));
    test('DEFAULT message', () => expect(ResponseMessage.DEFAULT, equals('Something went wrong')));
    test('NO_INTERNET_CONNECTION message', () {
      expect(ResponseMessage.NO_INTERNET_CONNECTION, equals('Please check your internet connection'));
    });
  });

  group('Failure', () {
    test('stores code and message', () {
      const failure = Failure(404, 'Not found');
      expect(failure.resonseCode, equals(404));
      expect(failure.responseMessage, equals('Not found'));
    });
  });

  group('DataSource', () {
    test('DEFAULT getFailure returns correct code', () {
      final failure = DataSource.DEFAULT.getFailure();
      expect(failure.resonseCode, equals(ResponseCode.DEFAULT));
    });

    test('CONNECT_TIMEOUT getFailure returns correct code', () {
      final failure = DataSource.CONNECT_TIMEOUT.getFailure();
      expect(failure.resonseCode, equals(ResponseCode.CONNECT_TIMEOUT));
    });

    test('UNAUTORISED getFailure returns correct code', () {
      final failure = DataSource.UNAUTORISED.getFailure();
      expect(failure.resonseCode, equals(ResponseCode.UNAUTORISED));
    });
  });
}
