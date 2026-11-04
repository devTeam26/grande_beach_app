import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:grande_beach/core/errors/failure.dart';
import 'package:grande_beach/core/providers/core_providers.dart';
import 'package:grande_beach/core/storage/local_storage_service.dart';
import 'package:grande_beach/core/utils/result.dart';
import 'package:grande_beach/features/authentication/controllers/auth_providers.dart';
import 'package:grande_beach/features/authentication/screens/login_screen.dart';
import 'package:grande_beach/features/authentication/widgets/login_required_dialog.dart';

import '../helpers/fakes.dart';
import '../helpers/test_app.dart';

/// Stands in for the reservation wizard: holds local in-progress state and
/// awaits the pushed login exactly like the real Reserve action does.
class _ReservationStandIn extends StatefulWidget {
  const _ReservationStandIn();

  @override
  State<_ReservationStandIn> createState() => _ReservationStandInState();
}

class _ReservationStandInState extends State<_ReservationStandIn> {
  int _selections = 0;
  String _loginResult = 'none';

  Future<void> _reserve() async {
    final wantsLogin = await LoginRequiredDialog.show(context, message: 'msg');
    if (!wantsLogin || !mounted) return;
    final signedIn = await context.push<bool>('/login');
    if (!mounted) return;
    setState(() => _loginResult = '$signedIn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('selections:$_selections'),
          Text('login:$_loginResult'),
          TextButton(
            onPressed: () => setState(() => _selections++),
            child: const Text('select'),
          ),
          TextButton(onPressed: _reserve, child: const Text('reserve')),
        ],
      ),
    );
  }
}

void main() {
  late FakeAuthRepository auth;

  GoRouter makeRouter(String initial) => GoRouter(
        initialLocation: initial,
        routes: [
          GoRoute(
            path: '/reserve',
            builder: (_, _) => const _ReservationStandIn(),
          ),
          GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
          GoRoute(path: '/home', builder: (_, _) => const Text('HOME')),
        ],
      );

  Future<ProviderContainer> pumpApp(WidgetTester tester, String initial) async {
    auth = FakeAuthRepository();
    // Tall viewport so lazily built list rows and footer buttons are on screen.
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final box = await tester.runAsync(() async {
      await setUpTestHive();
      return Hive.openBox(LocalStorageService.boxName);
    });
    addTearDown(() => tester.runAsync(tearDownTestHive));
    await tester.pumpWidget(
      buildTestApp(
        router: makeRouter(initial),
        overrides: [
          hiveBoxProvider.overrideWithValue(box!),
          authRepositoryProvider.overrideWithValue(auth),
          currentUserProvider.overrideWith((ref) => null),
        ],
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(tester.element(find.byType(Navigator)));
  }

  Future<void> openLoginFromReserve(WidgetTester tester) async {
    await tester.tap(find.text('select'));
    await tester.tap(find.text('select'));
    await tester.pump();
    await tester.tap(find.text('reserve'));
    await tester.pumpAndSettle();
    expect(find.text('Login Required'), findsOneWidget);
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  }

  Future<void> submitEmailLogin(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).at(0), 'sara@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
  }

  testWidgets('Cancel on the login-required dialog keeps the guest in place',
      (tester) async {
    await pumpApp(tester, '/reserve');
    await tester.tap(find.text('select'));
    await tester.pump();
    await tester.tap(find.text('reserve'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsNothing);
    expect(find.text('selections:1'), findsOneWidget);
    expect(auth.loginCalls + auth.googleCalls, 0);
  });

  testWidgets('email login returns to the same screen with state intact',
      (tester) async {
    final container = await pumpApp(tester, '/reserve');
    await openLoginFromReserve(tester);
    await submitEmailLogin(tester);

    expect(find.byType(LoginScreen), findsNothing);
    expect(find.text('HOME'), findsNothing);
    expect(find.text('selections:2'), findsOneWidget);
    expect(find.text('login:true'), findsOneWidget);
    expect(container.read(sessionActiveProvider), isTrue);
  });

  testWidgets('Google login returns to the same screen with state intact',
      (tester) async {
    await pumpApp(tester, '/reserve');
    await openLoginFromReserve(tester);
    await tester.tap(find.textContaining('Google'));
    await tester.pumpAndSettle();

    expect(auth.googleCalls, 1);
    expect(find.text('HOME'), findsNothing);
    expect(find.text('selections:2'), findsOneWidget);
    expect(find.text('login:true'), findsOneWidget);
  });

  testWidgets('failed or cancelled login keeps the guest on login; back '
      'returns to the untouched screen', (tester) async {
    final container = await pumpApp(tester, '/reserve');
    await openLoginFromReserve(tester);

    auth.nextResult = const ResultFailure(ServerFailure('Invalid credentials'));
    await submitEmailLogin(tester);
    expect(find.byType(LoginScreen), findsOneWidget);

    // Google sign-in failing (including a cancelled picker) behaves the same.
    tester
        .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
        .removeCurrentSnackBar();
    await tester.pumpAndSettle();
    auth.nextResult = const ResultFailure(NetworkFailure('offline'));
    await tester.tap(find.textContaining('Google'));
    await tester.pumpAndSettle();
    expect(auth.loginCalls, 1);
    expect(auth.googleCalls, 1);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(container.read(sessionActiveProvider), isFalse);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsNothing);
    expect(find.text('selections:2'), findsOneWidget);
    expect(find.text('login:null'), findsOneWidget);
  });

  testWidgets('login opened as the root route still continues to /home',
      (tester) async {
    await pumpApp(tester, '/login');
    await submitEmailLogin(tester);

    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('closing a root login continues to /home as a guest',
      (tester) async {
    final container = await pumpApp(tester, '/login');
    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
    expect(container.read(sessionActiveProvider), isFalse);
  });
}
