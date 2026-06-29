import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import 'package:grande_beach/core/providers/core_providers.dart';
import 'package:grande_beach/core/storage/local_storage_service.dart';
import 'package:grande_beach/features/authentication/controllers/auth_providers.dart';
import 'package:grande_beach/main.dart';

void main() {
  testWidgets('App boots to the language selection sheet on first launch', (
    WidgetTester tester,
  ) async {
    await setUpTestHive();
    final box = await Hive.openBox(LocalStorageService.boxName);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hiveBoxProvider.overrideWithValue(box),
          // Avoid touching the real flutter_secure_storage plugin channel,
          // which has no implementation registered in the test environment.
          hasActiveSessionProvider.overrideWith((ref) async => false),
        ],
        child: const GrandeBeachApp(),
      ),
    );
    // Avoid pumpAndSettle: StartupScreen shows an indeterminate
    // CircularProgressIndicator, whose animation never settles.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Choose your language'), findsOneWidget);
  });
}
