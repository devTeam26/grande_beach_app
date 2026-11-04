import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:grande_beach/core/errors/failure.dart';
import 'package:grande_beach/core/localization/generated/app_localizations.dart';
import 'package:grande_beach/core/network/network_info.dart';
import 'package:grande_beach/core/providers/core_providers.dart';
import 'package:grande_beach/core/routes/app_router.dart';
import 'package:grande_beach/core/storage/local_storage_service.dart';
import 'package:grande_beach/core/utils/result.dart';
import 'package:grande_beach/features/authentication/controllers/auth_providers.dart';
import 'package:grande_beach/features/authentication/screens/login_screen.dart';
import 'package:grande_beach/features/chalet_details/controllers/chalet_details_providers.dart';
import 'package:grande_beach/features/home/models/chalet.dart';
import 'package:grande_beach/features/reservation/controllers/reservation_providers.dart';
import 'package:grande_beach/features/reservation/screens/reservation_wizard_screen.dart';

import '../helpers/fakes.dart';

/// Keeps every repository offline so the shell's tabs never hit the network.
class _OfflineNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => false;
}

final _chalet = Chalet.fromJson({
  'id': 'c1',
  'name': 'A2',
  'nameAr': 'A2',
  'description': '',
  'descriptionAr': '',
  'type': 'Standard',
  'typeName': 'Standard',
  'masterBedrooms': 2,
  'singleBedrooms': 2,
  'bedsPerSingleBedroom': 2,
  'bathrooms': 5,
  'hasServantRoom': true,
  'maxGuests': 15,
  'basePrice': 350,
  'weekendPrice': 420,
  'currentDynamicPrice': 350,
  'occupancyPercentage': 0,
  'location': 'x',
  'locationAr': 'x',
  'latitude': 0,
  'longitude': 0,
  'googleMapsUrl': '',
  'isActive': true,
  'averageRating': 0,
  'totalReviews': 0,
  'images': [],
  'amenities': [],
});

/// Exercises the production [routerProvider] (redirects + refreshListenable),
/// which is where a pushed Login used to be re-added after a successful
/// sign-in.
void main() {
  late ProviderContainer container;
  late GoRouter router;
  late FakeAuthRepository auth;
  late FakeReservationRepository reservations;

  Future<void> frames(WidgetTester tester) async {
    // The shell shows looping shimmer animations, so pumpAndSettle never
    // settles; pump enough frames for route transitions to complete.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  List<String> stack() => router.routerDelegate.currentConfiguration.matches
      .map((m) => m.matchedLocation)
      .toList();

  Future<void> pumpGuestApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final box = (await tester.runAsync(() async {
      await setUpTestHive();
      final box = await Hive.openBox(LocalStorageService.boxName);
      final storage = LocalStorageService(box);
      await storage.setLanguageCode('en');
      await storage.setOnboardingComplete();
      return box;
    }))!;
    addTearDown(() => tester.runAsync(tearDownTestHive));

    auth = FakeAuthRepository();
    reservations = FakeReservationRepository();
    container = ProviderContainer(
      overrides: [
        hiveBoxProvider.overrideWithValue(box),
        sessionActiveProvider.overrideWith((ref) => false),
        appBootstrapDoneProvider.overrideWith((ref) => true),
        networkInfoProvider.overrideWithValue(_OfflineNetworkInfo()),
        authRepositoryProvider.overrideWithValue(auth),
        reservationRepositoryProvider.overrideWithValue(reservations),
        chaletDetailsProvider('c1').overrideWith((ref) async => _chalet),
      ],
    );
    addTearDown(container.dispose);
    router = container.read(routerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: router,
        ),
      ),
    );
    await frames(tester);
  }

  /// Opens the wizard and fills Step 1 (dates + guests), then moves to the
  /// Price Preview step where Reserve is shown.
  Future<void> reachReserveStep(WidgetTester tester) async {
    router.push('/chalet-details/c1/reserve');
    await frames(tester);
    container.read(reservationWizardControllerProvider('c1').notifier)
      ..updateCheckIn(DateTime(2026, 12, 10))
      ..updateCheckOut(DateTime(2026, 12, 12))
      ..updateGuestCount(2);
    await frames(tester);
    await tester.tap(find.text('Next'));
    await frames(tester);
    await tester.tap(find.text('Next'));
    await frames(tester);
  }

  Future<void> openLoginFromReserve(WidgetTester tester) async {
    await tester.tap(find.text('Reserve'));
    await frames(tester);
    await tester.tap(find.text('Login'));
    await frames(tester);
    expect(find.byType(LoginScreen), findsOneWidget);
  }

  Future<void> submitEmailLogin(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).at(0), 'sara@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret123');
    await tester.tap(find.text('Sign In'));
    await frames(tester);
  }

  testWidgets('guest lands on Home greeted as Guest', (tester) async {
    await pumpGuestApp(tester);

    expect(stack(), ['/home']);
    expect(find.text('Hey, Guest👋'), findsWidgets);
  });

  testWidgets('back from a Login opened by Reserve returns to the wizard',
      (tester) async {
    await pumpGuestApp(tester);
    await reachReserveStep(tester);
    // The guest reached the Price Preview step without signing in.
    expect(reservations.previewCalls, hasLength(1));

    await openLoginFromReserve(tester);
    await tester.tap(find.byType(BackButton));
    await frames(tester);

    expect(find.byType(LoginScreen), findsNothing);
    expect(stack(), ['/home', '/chalet-details/c1/reserve']);
    expect(find.text('Reserve'), findsOneWidget);
  });

  testWidgets('back still works after a failed login', (tester) async {
    await pumpGuestApp(tester);
    await reachReserveStep(tester);
    await openLoginFromReserve(tester);

    auth.nextResult = const ResultFailure(ServerFailure('Invalid credentials'));
    await submitEmailLogin(tester);
    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await frames(tester);

    expect(find.byType(LoginScreen), findsNothing);
    expect(stack(), ['/home', '/chalet-details/c1/reserve']);
  });

  testWidgets('successful login returns to the wizard and stays there',
      (tester) async {
    await pumpGuestApp(tester);
    await reachReserveStep(tester);
    await openLoginFromReserve(tester);

    await submitEmailLogin(tester);

    expect(container.read(sessionActiveProvider), isTrue);
    expect(find.byType(LoginScreen), findsNothing);
    expect(stack(), ['/home', '/chalet-details/c1/reserve']);
    expect(find.byType(ReservationWizardScreen), findsOneWidget);
    // Still on the Price Preview step with the same draft.
    expect(find.text('Reserve'), findsOneWidget);
    final draft = container
        .read(reservationWizardControllerProvider('c1'))
        .valueOrNull!;
    expect(draft.checkIn, DateTime(2026, 12, 10));
    expect(draft.checkOut, DateTime(2026, 12, 12));
    expect(draft.guestCount, 2);
    // Price refreshed from the backend for the signed-in account.
    expect(reservations.previewCalls, hasLength(2));
    // Nothing was submitted automatically.
    expect(reservations.createBookingCalls, 0);
  });

  testWidgets('Google login returns to the wizard and stays there',
      (tester) async {
    await pumpGuestApp(tester);
    await reachReserveStep(tester);
    await openLoginFromReserve(tester);

    await tester.tap(find.textContaining('Google'));
    await frames(tester);

    expect(auth.googleCalls, 1);
    expect(find.byType(LoginScreen), findsNothing);
    expect(stack(), ['/home', '/chalet-details/c1/reserve']);
  });
}
