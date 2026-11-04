import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/whatsapp_fab.dart';
import '../../home/models/chalet.dart';
import '../controllers/chalet_details_providers.dart';
import '../widgets/chalet_amenities_section.dart';
import '../widgets/chalet_cancellation_policy_section.dart';
import '../widgets/chalet_description_section.dart';
import '../widgets/chalet_details_section.dart';
import '../widgets/chalet_details_skeleton.dart';
import '../widgets/chalet_image_gallery.dart';
import '../widgets/chalet_reservation_bar.dart';
import '../widgets/chalet_reviews_row.dart';
import '../widgets/chalet_title_section.dart';

/// Reusable chalet details screen — reached from Home, Discover, Wishlist,
/// Search, or any future chalet card, always via `/chalet-details/:id`.
class ChaletDetailsScreen extends ConsumerWidget {
  const ChaletDetailsScreen({super.key, required this.chaletId});

  final String chaletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaletAsync = ref.watch(chaletDetailsProvider(chaletId));
    final l10n = AppLocalizations.of(context);
    final isArabic = ref.watch(localeProvider).languageCode == 'ar';

    return Scaffold(
      extendBodyBehindAppBar: true,

      floatingActionButton: chaletAsync.maybeWhen(
        data: (chalet) => WhatsAppFab(
          onPressed: () => ref.read(whatsAppServiceProvider).openChaletInquiry(
                l10n,
                chaletName: isArabic ? chalet.nameAr : chalet.name,
              ),
        ),
        orElse: () => null,
      ),
      bottomNavigationBar: chaletAsync.maybeWhen(
        data: (chalet) => ChaletReservationBar(
          price: chalet.basePrice,
          onReserve: () =>
              context.push('/chalet-details/${chalet.id}/reserve'),
        ),
        orElse: () => null,
      ),
      body: chaletAsync.when(
        loading: () => const ChaletDetailsSkeleton(),
        error: (_, _) => Stack(
          children: [
            Center(
              child: ErrorState(
                message: l10n.errorLoadingChalets,
                onRetry: () => ref.invalidate(chaletDetailsProvider(chaletId)),
              ),
            ),
            _BackButton(topPadding: MediaQuery.of(context).padding.top),
          ],
        ),
        data: (chalet) => _ChaletDetailsContent(chalet: chalet),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.topPadding});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPadding + 12,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              size: 16, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}

class _ChaletDetailsContent extends ConsumerWidget {
  const _ChaletDetailsContent({required this.chalet});

  final Chalet chalet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = ref.watch(localeProvider).languageCode == 'ar';
    final name = isArabic ? chalet.nameAr : chalet.name;
    final location = (isArabic ? chalet.locationAr : chalet.location) ?? chalet.location;
    final description = isArabic ? chalet.descriptionAr : chalet.description;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChaletImageGallery(
            chaletId: chalet.id,
            imageUrls: chalet.galleryImageUrls,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChaletTitleSection(
                  name: name,
                  location: location,
                  type: chalet.type,
                  typeName: chalet.typeName,
                ),
                const SizedBox(height: 16),
                ChaletReviewsRow(
                  rating: chalet.averageRating,
                  totalReviews: chalet.totalReviews,
                  onTap: () =>
                      context.push('/chalet-details/${chalet.id}/reviews'),
                ),
                const SizedBox(height: 24),
                ChaletDetailsSection(
                  masterBedrooms: chalet.masterBedrooms,
                  singleBedrooms: chalet.singleBedrooms,
                  bathrooms: chalet.bathrooms,
                  hasServantRoom: chalet.hasServantRoom,
                  maxGuests: chalet.maxGuests,
                ),
                const SizedBox(height: 24),
                ChaletDescriptionSection(description: description),
                                const SizedBox(height: 24),
                ChaletCancellationPolicySection(
                  chaletName: name,
                ),
                const SizedBox(height: 24),
                ChaletAmenitiesSection(
                  amenities: chalet.amenities,
                  isArabic: isArabic,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
