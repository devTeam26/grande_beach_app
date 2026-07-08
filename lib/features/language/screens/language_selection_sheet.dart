import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../controllers/language_selection_controller.dart';
import '../models/language_option.dart';
import '../widgets/language_continue_button.dart';
import '../widgets/language_option_card.dart';

/// Modal bottom sheet shown on first launch, before onboarding, asking the
/// user to pick a preferred language.
class LanguageSelectionSheet extends ConsumerStatefulWidget {
  const LanguageSelectionSheet({super.key, required this.onConfirmed});

  final VoidCallback onConfirmed;

  static Future<void> show(BuildContext context, {required VoidCallback onConfirmed}) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => LanguageSelectionSheet(onConfirmed: onConfirmed),
    );
  }

  @override
  ConsumerState<LanguageSelectionSheet> createState() => _LanguageSelectionSheetState();
}

class _LanguageSelectionSheetState extends ConsumerState<LanguageSelectionSheet> {
  Locale? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = [
      LanguageOption(locale: const Locale('en'), label: l10n.english),
      LanguageOption(locale: const Locale('ar'), label: l10n.arabic),
    ];

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.chooseYourLanguage,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.languageChangeHint,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Column(
            children: options
                .map(
                  (option) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: SizedBox(
                      width: double.infinity,
                      child: LanguageOptionCard(
                        option: option,
                        isSelected: _selected == option.locale,
                        onTap: () => setState(() => _selected = option.locale),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          LanguageContinueButton(
            enabled: _selected != null,
            onPressed: () async {
              await ref
                  .read(languageSelectionControllerProvider.notifier)
                  .confirm(_selected!);
              if (context.mounted) {
                Navigator.of(context).pop();
                widget.onConfirmed();
              }
            },
          ),
        ],
      ),
    );
  }
}
