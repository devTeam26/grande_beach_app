import '../../../core/config/images.dart';
import '../models/amenity.dart';
import '../models/chalet.dart';
import '../models/chalet_image.dart';
import '../models/home_banner.dart';

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

  static List<Chalet> getPopularChalets() => [
        _chalet(
          id: 1,
          name: 'Pearl Horizon',
          nameAr: 'أفق اللؤلؤ',
          description:
              'A stunning beachfront chalet with panoramic sea views and private pool.',
          descriptionAr:
              'شاليه ساحر على الشاطئ مع إطلالات بانورامية على البحر وحمام سباحة خاص.',
          location: 'Salwa Beach, Kuwait',
          locationAr: 'شاطئ سلوى، الكويت',
          basePrice: 350,
          weekendPrice: 450,
          currentDynamicPrice: 380,
          masterBedrooms: 2,
          singleBedrooms: 2,
          maxGuests: 10,
          averageRating: 4.9,
          totalReviews: 214,
          imageCount: 4,
          latitude: 28.9784,
          longitude: 48.1000,
          amenityIds: const ['1', '2', '3', '4'],
        ),
        _chalet(
          id: 2,
          name: 'Azure Retreat',
          nameAr: 'ملجأ أزرق',
          description:
              'Elegant chalet nestled among lush gardens with direct beach access.',
          descriptionAr:
              'شاليه أنيق في أحضان الحدائق الخضراء مع وصول مباشر إلى الشاطئ.',
          location: 'Messila Beach, Kuwait',
          locationAr: 'شاطئ مسيلة، الكويت',
          basePrice: 280,
          weekendPrice: 360,
          currentDynamicPrice: 295,
          masterBedrooms: 1,
          singleBedrooms: 3,
          maxGuests: 8,
          averageRating: 4.7,
          totalReviews: 187,
          imageCount: 3,
          latitude: 29.2985,
          longitude: 47.9654,
          amenityIds: const ['1', '3', '5', '6'],
        ),
        _chalet(
          id: 3,
          name: 'Golden Sands Villa',
          nameAr: 'فيلا الرمال الذهبية',
          description:
              'Luxurious villa offering ultimate privacy and modern amenities.',
          descriptionAr: 'فيلا فاخرة توفر أقصى درجات الخصوصية والمرافق الحديثة.',
          location: 'Nuwaiseeb Beach, Kuwait',
          locationAr: 'شاطئ نويصيب، الكويت',
          basePrice: 500,
          weekendPrice: 650,
          currentDynamicPrice: 520,
          masterBedrooms: 3,
          singleBedrooms: 2,
          maxGuests: 14,
          averageRating: 4.8,
          totalReviews: 96,
          imageCount: 5,
          latitude: 28.6784,
          longitude: 48.2000,
          amenityIds: const ['1', '2', '4', '5', '6'],
        ),
        _chalet(
          id: 4,
          name: 'Coral Bay',
          nameAr: 'خليج المرجان',
          description:
              'Cozy beachside chalet perfect for families and small groups.',
          descriptionAr:
              'شاليه دافئ على شاطئ البحر مثالي للعائلات والمجموعات الصغيرة.',
          location: 'Khairan Resort, Kuwait',
          locationAr: 'منتجع الخيران، الكويت',
          basePrice: 150,
          weekendPrice: 200,
          currentDynamicPrice: 165,
          masterBedrooms: 1,
          singleBedrooms: 1,
          maxGuests: 6,
          averageRating: 4.5,
          totalReviews: 312,
          imageCount: 2,
          latitude: 28.7184,
          longitude: 48.3000,
          amenityIds: const ['1', '3', '6'],
        ),
      ];

  static List<Chalet> getRecentlyAdded() => [
        _chalet(
          id: 5,
          name: 'Sunset Palms',
          nameAr: 'نخيل الغروب',
          description:
              'Modern chalet with stunning sunset views and a private terrace.',
          descriptionAr: 'شاليه عصري مع مناظر غروب رائعة وتراس خاص.',
          location: 'Julaiah Beach, Kuwait',
          locationAr: 'شاطئ الجليعة، الكويت',
          basePrice: 220,
          weekendPrice: 290,
          currentDynamicPrice: 240,
          masterBedrooms: 2,
          singleBedrooms: 1,
          maxGuests: 8,
          averageRating: 4.6,
          totalReviews: 42,
          imageCount: 3,
          latitude: 29.0184,
          longitude: 48.0500,
          amenityIds: const ['1', '2', '3'],
        ),
        _chalet(
          id: 6,
          name: 'Marina Escape',
          nameAr: 'هروب المارينا',
          description:
              'Sophisticated waterfront chalet with yacht access and infinity pool.',
          descriptionAr:
              'شاليه راقٍ على الواجهة المائية مع إمكانية الوصول لليخت وحمام السباحة اللانهائي.',
          location: 'Salmiya Marina, Kuwait',
          locationAr: 'مارينا السالمية، الكويت',
          basePrice: 420,
          weekendPrice: 550,
          currentDynamicPrice: 445,
          masterBedrooms: 2,
          singleBedrooms: 2,
          maxGuests: 10,
          averageRating: 4.8,
          totalReviews: 28,
          imageCount: 4,
          latitude: 29.3584,
          longitude: 48.0700,
          amenityIds: const ['1', '2', '4', '5', '6'],
        ),
        _chalet(
          id: 7,
          name: 'Desert Rose Chalet',
          nameAr: 'شاليه وردة الصحراء',
          description:
              'Unique desert-meets-sea experience with traditional Arabic design elements.',
          descriptionAr:
              'تجربة فريدة تجمع الصحراء والبحر مع عناصر التصميم العربي التقليدي.',
          location: 'Doha Beach, Kuwait',
          locationAr: 'شاطئ الدوحة، الكويت',
          basePrice: 190,
          weekendPrice: 250,
          currentDynamicPrice: 205,
          masterBedrooms: 1,
          singleBedrooms: 2,
          maxGuests: 7,
          averageRating: 4.4,
          totalReviews: 17,
          imageCount: 3,
          latitude: 29.4084,
          longitude: 47.9300,
          amenityIds: const ['2', '3', '4'],
        ),
      ];

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static Chalet _chalet({
    required int id,
    required String name,
    required String nameAr,
    required String description,
    required String descriptionAr,
    required String location,
    required String locationAr,
    required double basePrice,
    required double weekendPrice,
    required double currentDynamicPrice,
    required int masterBedrooms,
    required int singleBedrooms,
    required int maxGuests,
    required double averageRating,
    required int totalReviews,
    required int imageCount,
    required double latitude,
    required double longitude,
    required List<String> amenityIds,
  }) {
    return Chalet(
      id: '$id',
      name: name,
      nameAr: nameAr,
      description: description,
      descriptionAr: descriptionAr,
      type: 'beach',
      typeName: 'Beach Chalet',
      masterBedrooms: masterBedrooms,
      singleBedrooms: singleBedrooms,
      bedsPerSingleBedroom: 2,
      maxGuests: maxGuests,
      basePrice: basePrice,
      weekendPrice: weekendPrice,
      currentDynamicPrice: currentDynamicPrice,
      occupancyPercentage: 0.0,
      location: location,
      locationAr: locationAr,
      latitude: latitude,
      longitude: longitude,
      googleMapsUrl: 'https://maps.google.com',
      isActive: true,
      averageRating: averageRating,
      totalReviews: totalReviews,
      images: List.generate(
        imageCount,
        (index) => ChaletImage(
          id: '${id * 100 + index}',
          chaletId: '$id',
          imageUrl: AppImages.chaletPlaceholder,
          isPrimary: index == 0,
          sortOrder: index,
        ),
      ),
      amenities: _allAmenities
          .where((a) => amenityIds.contains(a.id))
          .toList(),
    );
  }

  static const List<Amenity> _allAmenities = [
    Amenity(id: '1', name: 'Private Pool', nameAr: 'حمام سباحة خاص', icon: 'pool'),
    Amenity(id: '2', name: 'Beach Access', nameAr: 'وصول للشاطئ', icon: 'beach'),
    Amenity(id: '3', name: 'BBQ Area', nameAr: 'منطقة الشواء', icon: 'bbq'),
    Amenity(id: '4', name: 'Parking', nameAr: 'موقف سيارات', icon: 'parking'),
    Amenity(id: '5', name: 'WiFi', nameAr: 'إنترنت لاسلكي', icon: 'wifi'),
    Amenity(id: '6', name: 'Air Conditioning', nameAr: 'تكييف هواء', icon: 'ac'),
  ];
}
