import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grande_beach/features/authentication/controllers/auth_providers.dart';
import 'package:grande_beach/features/reservation/controllers/reservation_providers.dart';
import 'package:grande_beach/features/reservation/models/reservation_draft.dart';

import '../helpers/fakes.dart';

void main() {
  final draft = ReservationDraft(
    chaletId: 'c1',
    checkIn: DateTime(2026, 12, 10),
    checkOut: DateTime(2026, 12, 12),
    guestCount: 2,
  );

  ProviderContainer makeContainer({
    required bool hasSession,
    required FakeReservationRepository repo,
  }) {
    final container = ProviderContainer(
      overrides: [
        sessionActiveProvider.overrideWith((ref) => hasSession),
        currentUserProvider.overrideWith((ref) => hasSession ? testUser : null),
        reservationRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('Guest reservation', () {
    test('price preview is fetched for a guest with empty contact fields',
        () async {
      final repo = FakeReservationRepository();
      final container = makeContainer(hasSession: false, repo: repo);
      container.listen(reservationWizardControllerProvider('c1'), (_, _) {});
      await container.read(reservationWizardControllerProvider('c1').future);

      await container
          .read(pricePreviewControllerProvider('c1').notifier)
          .fetch(draft);

      expect(repo.previewCalls, hasLength(1));
      expect(repo.previewCalls.single['guestFirstName'], '');
      expect(repo.previewCalls.single['guestEmail'], '');
      expect(
        container.read(pricePreviewControllerProvider('c1')).valueOrNull,
        testPreview,
      );
      expect(
        container
            .read(reservationWizardControllerProvider('c1'))
            .valueOrNull
            ?.pricePreview,
        testPreview,
      );
    });

    test('booking submission never reaches the API for a guest', () async {
      final repo = FakeReservationRepository();
      final container = makeContainer(hasSession: false, repo: repo);
      await container.read(bookingSubmitControllerProvider.future);

      await container.read(bookingSubmitControllerProvider.notifier).submit(
            draft,
          );

      expect(repo.createBookingCalls, 0);
      expect(container.read(bookingSubmitControllerProvider).valueOrNull,
          isFalse);
    });
  });

  group('Authenticated reservation', () {
    test('price preview uses the signed-in user', () async {
      final repo = FakeReservationRepository();
      final container = makeContainer(hasSession: true, repo: repo);

      await container
          .read(pricePreviewControllerProvider('c1').notifier)
          .fetch(draft);

      expect(repo.previewCalls.single['guestEmail'], testUser.email);
    });

    test('booking is submitted exactly once', () async {
      final repo = FakeReservationRepository();
      final container = makeContainer(hasSession: true, repo: repo);
      await container.read(bookingSubmitControllerProvider.future);
      final notifier = container.read(bookingSubmitControllerProvider.notifier);

      await Future.wait([notifier.submit(draft), notifier.submit(draft)]);

      expect(repo.createBookingCalls, 1);
      expect(container.read(bookingSubmitControllerProvider).valueOrNull,
          isTrue);
    });
  });
}
