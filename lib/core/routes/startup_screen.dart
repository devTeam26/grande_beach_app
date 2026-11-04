import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/controllers/auth_providers.dart';
import '../../features/language/screens/language_selection_sheet.dart';
import '../providers/core_providers.dart';
import '../providers/onboarding_provider.dart';

/// Root route / splash. On first launch it presents the language-selection
/// bottom sheet; once language and onboarding are done it runs the launch-time
/// session bootstrap (refreshes the stored token) before the router redirect
/// moves the user on to /home (as an authenticated user or a guest).
class StartupScreen extends ConsumerStatefulWidget {
  const StartupScreen({super.key});

  @override
  ConsumerState<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends ConsumerState<StartupScreen> {
  bool _sheetShown = false;
  bool _bootstrapStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeShowLanguageSheet();
    _maybeBootstrap();
  }

  void _maybeShowLanguageSheet() {
    final languageSelected = ref.read(languageSelectedProvider);
    if (!languageSelected && !_sheetShown) {
      _sheetShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          LanguageSelectionSheet.show(context, onConfirmed: () {});
        }
      });
    }
  }

  void _maybeBootstrap() {
    if (_bootstrapStarted) return;

    // The bootstrap only runs once the first-time flow (language + onboarding)
    // is complete — new users have no token to refresh and continue to /home
    // as guests through the router redirect.
    final languageSelected = ref.read(languageSelectedProvider);
    final onboardingDone = ref.read(onboardingProvider);
    final bootstrapDone = ref.read(appBootstrapDoneProvider);
    if (!languageSelected || !onboardingDone || bootstrapDone) {
      debugPrint(
        '[AUTH] StartupScreen: bootstrap skipped '
        '(languageSelected=$languageSelected, onboardingDone=$onboardingDone, '
        'bootstrapDone=$bootstrapDone)',
      );
      return;
    }

    _bootstrapStarted = true;
    debugPrint('[AUTH] StartupScreen: starting launch-time session bootstrap');
    WidgetsBinding.instance.addPostFrameCallback((_) => _runBootstrap());
  }

  Future<void> _runBootstrap() async {
    // Attempt to refresh the stored session. On success the rotated tokens are
    // persisted; on an invalid/expired token the local session is cleared.
    final result = await ref.read(authRepositoryProvider).refreshSession();
    result.fold(
      (failure) => debugPrint(
        '[AUTH] StartupScreen: refreshSession failed -> ${failure.message}',
      ),
      (_) => debugPrint('[AUTH] StartupScreen: refreshSession succeeded'),
    );

    final active =
        await ref.read(secureStorageServiceProvider).hasValidSession();
    debugPrint(
      '[AUTH] StartupScreen: bootstrap complete, hasValidSession=$active -> '
      'routing to /home as ${active ? 'authenticated user' : 'guest'}',
    );

    if (!mounted) return;
    ref.read(sessionActiveProvider.notifier).state = active;
    ref.read(appBootstrapDoneProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
