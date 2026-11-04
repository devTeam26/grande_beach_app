import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:grande_beach/core/providers/core_providers.dart';
import 'package:grande_beach/core/storage/local_storage_service.dart';
import 'package:grande_beach/features/authentication/controllers/auth_providers.dart';
import 'package:grande_beach/features/authentication/widgets/sign_in_required_state.dart';
import 'package:grande_beach/features/booking/controllers/bookings_providers.dart';
import 'package:grande_beach/features/booking/screens/bookings_screen.dart';
import 'package:grande_beach/features/profile/screens/profile_screen.dart';

import '../helpers/fakes.dart';
import '../helpers/test_app.dart';

void main() {
  late FakeBookingsRepository bookings;

  Future<ProviderContainer> pumpScreen(
    WidgetTester tester,
    Widget screen, {
    required bool hasSession,
  }) async {
    bookings = FakeBookingsRepository();
    // Tall viewport so lazily built list rows and footer buttons are on screen.
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final box = await tester.runAsync(() async {
      await setUpTestHive();
      return Hive.openBox(LocalStorageService.boxName);
    });
    addTearDown(() => tester.runAsync(tearDownTestHive));

    final router = GoRouter(
      initialLocation: '/screen',
      routes: [
        GoRoute(path: '/screen', builder: (_, _) => screen),
        GoRoute(path: '/login', builder: (_, _) => const Text('LOGIN')),
      ],
    );
    await tester.pumpWidget(
      buildTestApp(
        router: router,
        overrides: [
          hiveBoxProvider.overrideWithValue(box!),
          sessionActiveProvider.overrideWith((ref) => hasSession),
          currentUserProvider.overrideWith((ref) => hasSession ? testUser : null),
          bookingsRepositoryProvider.overrideWithValue(bookings),
        ],
      ),
    );
    await tester.pump();
    return ProviderScope.containerOf(tester.element(find.byType(Navigator)));
  }

  group('Bookings', () {
    testWidgets('guest sees the sign-in state and no bookings request is made',
        (tester) async {
      await pumpScreen(tester, const BookingsScreen(), hasSession: false);

      expect(find.byType(SignInRequiredState), findsOneWidget);
      expect(
        find.text('You need to sign in to view your bookings.'),
        findsOneWidget,
      );
      expect(bookings.fetchCalls, 0);

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(find.text('LOGIN'), findsOneWidget);
    });

    testWidgets('authenticated user gets the bookings list', (tester) async {
      await pumpScreen(tester, const BookingsScreen(), hasSession: true);

      expect(find.byType(SignInRequiredState), findsNothing);
      expect(bookings.fetchCalls, 1);
    });

    testWidgets('signing in switches the guest state to bookings',
        (tester) async {
      final container =
          await pumpScreen(tester, const BookingsScreen(), hasSession: false);
      container.read(sessionActiveProvider.notifier).state = true;
      await tester.pump();

      expect(find.byType(SignInRequiredState), findsNothing);
      expect(bookings.fetchCalls, 1);
    });
  });

  group('Profile', () {
    testWidgets('guest sees Guest User, settings and Login (no Logout)',
        (tester) async {
      await pumpScreen(tester, const ProfileScreen(), hasSession: false);

      expect(find.text('Guest User'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Logout'), findsNothing);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text(testUser.email), findsNothing);

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(find.text('LOGIN'), findsOneWidget);
    });

    testWidgets('authenticated user sees their profile and Logout',
        (tester) async {
      await pumpScreen(tester, const ProfileScreen(), hasSession: true);

      expect(find.text('Sara Ali'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.text('Guest User'), findsNothing);
    });

    testWidgets('logging out (session ends) shows the guest profile',
        (tester) async {
      final container =
          await pumpScreen(tester, const ProfileScreen(), hasSession: true);
      container.read(sessionActiveProvider.notifier).state = false;
      await tester.pump();

      expect(find.text('Guest User'), findsOneWidget);
      expect(find.text('Sara Ali'), findsNothing);
      expect(find.text('Logout'), findsNothing);
    });
  });
}
