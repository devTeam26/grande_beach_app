import '../../../core/config/images.dart';
import '../models/home_banner.dart';

/// Mock data for the home banner carousel. Chalet sections now come from the
/// backend (see [homeRepositoryProvider]); only banners remain mocked until a
/// banners endpoint is available.
abstract class HomeMockData {
  static List<HomeBanner> getBanners() => const [
        HomeBanner(
          id: 1,
          imageUrl: AppImages.banner,
          badge: 'GrandeBeach',
          badgeAr: 'غراند بيتش',
          headline: 'Moments that stay with you forever',
          headlineAr: 'لحظات تبقى معك إلى الأبد',
          description: 'Discover exclusive chalets with breathtaking ocean views',
          descriptionAr: 'اكتشف شاليهات حصرية مع إطلالات خلابة على المحيط',
        ),
      ];
}
