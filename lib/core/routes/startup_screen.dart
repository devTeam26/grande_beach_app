import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/language/screens/language_selection_sheet.dart';
import '../providers/onboarding_provider.dart';

/// Root route. Presents the language-selection bottom sheet on first
/// launch; once a language is chosen, the router redirect takes over and
/// moves on to onboarding/login/home.
class StartupScreen extends ConsumerStatefulWidget {
  const StartupScreen({super.key});

  @override
  ConsumerState<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends ConsumerState<StartupScreen> {
  bool _sheetShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
