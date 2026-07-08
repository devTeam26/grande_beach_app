import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../home/widgets/chalet_card.dart';
import '../../home/widgets/home_skeletons.dart';
import '../../home/widgets/section_header.dart';
import '../controllers/discover_providers.dart';

class DiscoverChaletList extends ConsumerStatefulWidget {
  const DiscoverChaletList({super.key, required this.isArabic});

  final bool isArabic;

  @override
  ConsumerState<DiscoverChaletList> createState() => _DiscoverChaletListState();
}

class _DiscoverChaletListState extends ConsumerState<DiscoverChaletList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(discoverChaletsProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chaletsAsync = ref.watch(discoverChaletsProvider);

    return chaletsAsync.when(
      loading: () => ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          SectionHeader(title: l10n.discoverChaletsTitle),
          const SizedBox(height: 14),
          const VerticalChaletListSkeleton(),
        ],
      ),
      error: (_, _) => ErrorState(
        message: l10n.errorLoadingChalets,
        onRetry: () => ref.read(discoverChaletsProvider.notifier).retry(),
      ),
      data: (state) {
        if (state.chalets.isEmpty) {
          return EmptyState(
            title: l10n.noChaletsFound,
            subtitle: l10n.noChaletsFoundSubtitle,
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          itemCount: state.chalets.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SectionHeader(title: l10n.discoverChaletsTitle),
              );
            }

            final chaletIndex = index - 1;
            if (chaletIndex == state.chalets.length) {
              return state.isLoadingMore
                  ? const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: VerticalChaletListSkeleton(itemCount: 1),
                    )
                  : const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ChaletCard(
                chalet: state.chalets[chaletIndex],
                isArabic: widget.isArabic,
                isFullWidth: true,
                onTap: () => context
                    .push('/chalet-details/${state.chalets[chaletIndex].id}'),
              ),
            );
          },
        );
      },
    );
  }
}
