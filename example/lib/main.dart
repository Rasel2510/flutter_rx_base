import 'package:flutter/material.dart';
import 'package:flutter_rx_base/flutter_rx_base.dart';
import 'package:rxdart/subjects.dart';

// ─── Example model ────────────────────────────────────────────────────────────

class UserModel {
  final String name;
  final String email;

  const UserModel({this.name = '', this.email = ''});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
      );
}

// ─── Example Rx class ─────────────────────────────────────────────────────────

class GetUserRx extends RxResponseInt<UserModel> {
  GetUserRx({required super.empty, required super.dataFetcher});

  /// Simulates a successful API response.
  Future<void> fetchUser() async {
    try {
      // Simulated API response
      final data = UserModel.fromJson({
        'name': 'Rasel',
        'email': 'rasel@example.com',
      });
      handleSuccessWithReturn(data);
    } catch (error) {
      handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(UserModel data) {
    dataFetcher.sink.add(data);
    return super.handleSuccessWithReturn(data);
  }

  @override
  handleErrorWithReturn(dynamic error) {
    dataFetcher.sink.addError(error);
    return super.handleErrorWithReturn(error);
  }
}

// ─── App ──────────────────────────────────────────────────────────────────────

final GetUserRx getUserRx = GetUserRx(
  empty: const UserModel(),
  dataFetcher: BehaviorSubject<UserModel>(),
);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_rx_base Example',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_rx_base')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<UserModel>(
              stream: getUserRx.dataFetcher.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Press the button to load user'));
                }
                final user = snapshot.data!;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('Name: ${user.name}',
                            style: const TextStyle(fontSize: 18)),
                        Text('Email: ${user.email}',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: getUserRx.fetchUser,
              child: const Text('Fetch User  →  RxResponseInt'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: getUserRx.clean,
              child: const Text('Clean Stream  →  clean()'),
            ),
          ],
        ),
      ),
    );
  }
}
