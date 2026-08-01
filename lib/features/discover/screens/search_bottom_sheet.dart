import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../controllers/discover_providers.dart';
import '../controllers/filter_controller.dart';
import '../widgets/chalet_type_selector.dart';
import '../widgets/date_range_picker.dart';
import '../widgets/filter_section.dart';
import '../widgets/guests_field.dart';
import '../widgets/price_range_fields.dart';
import '../widgets/search_bottom_actions.dart';

/// The primary filtering interface for the Discover screen.
class SearchBottomSheet extends ConsumerStatefulWidget {
  const SearchBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const SearchBottomSheet(),
    );
  }

  @override
  ConsumerState<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends ConsumerState<SearchBottomSheet> {
  late final TextEditingController _guestsController;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  int _resetGeneration = 0;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(draftChaletFiltersProvider);
    _guestsController = TextEditingController(text: draft.guests?.toString() ?? '');
    _minPriceController =
        TextEditingController(text: draft.minPrice?.toString() ?? '');
    _maxPriceController =
        TextEditingController(text: draft.maxPrice?.toString() ?? '');
  }

  @override
  void dispose() {
    _guestsController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _onReset() {
    ref.read(draftChaletFiltersProvider.notifier).reset();
    _guestsController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();
    setState(() => _resetGeneration++);
  }

  Future<void> _onSearch(String? guestsError, String? priceRangeError) async {
    if (_isSearching || guestsError != null || priceRangeError != null) return;

    setState(() => _isSearching = true);
    final draft = ref.read(draftChaletFiltersProvider);
    ref.read(activeChaletFiltersProvider.notifier).apply(draft);
    ref.read(discoverChaletsProvider.notifier).applyFilters(draft);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final draft = ref.watch(draftChaletFiltersProvider);
    final draftNotifier = ref.read(draftChaletFiltersProvider.notifier);

    final guests = int.tryParse(_guestsController.text);
    final guestsError = _guestsController.text.isNotEmpty && (guests == null || guests < 1)
        ? l10n.guestsMinError
        : null;

    final priceRangeError =
        (draft.minPrice != null && draft.maxPrice != null && draft.minPrice! > draft.maxPrice!)
            ? l10n.priceRangeInvalid
            : null;

    final typeOptions = <ChaletTypeOption>[
      (value: 'Standard', label: l10n.chaletTypeStandard),
      (value: 'Superior', label: l10n.chaletTypeSuperior),
      (value: 'VIP', label: l10n.chaletTypeVip),
    ];

    return DraggableScrollableSheet(
      
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  key: ValueKey(_resetGeneration),
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
                  children: [
                    Text(
                      l10n.searchSheetTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.searchSheetSubtitle,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    // Divider(color: theme.dividerColor),
                    FilterSection(
                      title: l10n.filterWhenTitle,
                      initiallyExpanded: true,
                      child: DateRangePicker(
                        checkIn: draft.checkIn,
                        checkOut: draft.checkOut,
                        onCheckInChanged: draftNotifier.setCheckIn,
                        onCheckOutChanged: draftNotifier.setCheckOut,
                      ),
                    ),
                    FilterSection(
                      title: l10n.filterChaletTypeTitle,
                      child: ChaletTypeSelector(
                        options: typeOptions,
                        selected: draft.chaletType,
                        onChanged: draftNotifier.setChaletType,
                      ),
                    ),
                    FilterSection(
                      title: l10n.filterGuestsTitle,
                      child: GuestsField(
                        controller: _guestsController,
                        errorText: guestsError,
                        onChanged: (value) => draftNotifier.setGuests(int.tryParse(value)),
                      ),
                    ),
                    FilterSection(
                      title: l10n.filterPriceRangeTitle,
                      child: PriceRangeFields(
                        minController: _minPriceController,
                        maxController: _maxPriceController,
                        errorText: priceRangeError,
                        onMinChanged: (value) =>
                            draftNotifier.setMinPrice(double.tryParse(value)),
                        onMaxChanged: (value) =>
                            draftNotifier.setMaxPrice(double.tryParse(value)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: SearchBottomActions(
                  onReset: _onReset,
                  onSearch: () => _onSearch(guestsError, priceRangeError),
                  isSearching: _isSearching,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
