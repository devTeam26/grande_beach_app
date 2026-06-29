import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/localization/generated/app_localizations.dart';
import 'core/providers/core_providers.dart';
import 'core/providers/locale_provider.dart';
import 'core/routes/app_router.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await LocalStorageService.openBox();

  runApp(
    ProviderScope(
      overrides: [hiveBoxProvider.overrideWithValue(box)],
      child: const GrandeBeachApp(),
    ),
  );
}

class GrandeBeachApp extends ConsumerWidget {
  const GrandeBeachApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'GrandeBeach',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
    );
  }
}
