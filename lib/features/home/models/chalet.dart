import 'amenity.dart';
import 'chalet_image.dart';

class Chalet {
  const Chalet({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.type,
    required this.typeName,
    required this.masterBedrooms,
    required this.singleBedrooms,
    required this.bedsPerSingleBedroom,
    required this.maxGuests,
    required this.basePrice,
    required this.weekendPrice,
    required this.currentDynamicPrice,
    required this.occupancyPercentage,
    required this.location,
    required this.locationAr,
    required this.latitude,
    required this.longitude,
    required this.googleMapsUrl,
    required this.isActive,
    required this.averageRating,
    required this.totalReviews,
    required this.images,
    required this.amenities,
  });

  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String type;
  final String typeName;
  final int masterBedrooms;
  final int singleBedrooms;
  final int bedsPerSingleBedroom;
  final int maxGuests;
  final double basePrice;
  final double weekendPrice;
  final double currentDynamicPrice;
  final double occupancyPercentage;
  final String location;
  final String? locationAr;
  final double latitude;
  final double longitude;
  final String googleMapsUrl;
  final bool isActive;
  final double averageRating;
  final int totalReviews;
  final List<ChaletImage> images;
  final List<Amenity> amenities;

  factory Chalet.fromJson(Map<String, dynamic> json) => Chalet(
        id: json['id'] as String,
        name: json['name'] as String,
        nameAr: json['nameAr'] as String,
        description: json['description'] as String,
        descriptionAr: json['descriptionAr'] as String,
        type: json['type'] as String,
        typeName: json['typeName'] as String,
        masterBedrooms: json['masterBedrooms'] as int,
        singleBedrooms: json['singleBedrooms'] as int,
        bedsPerSingleBedroom: json['bedsPerSingleBedroom'] as int,
        maxGuests: json['maxGuests'] as int,
        basePrice: (json['basePrice'] as num).toDouble(),
        weekendPrice: (json['weekendPrice'] as num).toDouble(),
        currentDynamicPrice: (json['currentDynamicPrice'] as num).toDouble(),
        occupancyPercentage: (json['occupancyPercentage'] as num).toDouble(),
        location: json['location'] as String,
        locationAr: json['locationAr'] as String?,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        googleMapsUrl: json['googleMapsUrl'] as String,
        isActive: json['isActive'] as bool,
        averageRating: (json['averageRating'] as num).toDouble(),
        totalReviews: json['totalReviews'] as int,
        images: (json['images'] as List<dynamic>)
            .map((e) => ChaletImage.fromJson(e as Map<String, dynamic>))
            .toList(),
        amenities: (json['amenities'] as List<dynamic>)
            .map((e) => Amenity.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameAr': nameAr,
        'description': description,
        'descriptionAr': descriptionAr,
        'type': type,
        'typeName': typeName,
        'masterBedrooms': masterBedrooms,
        'singleBedrooms': singleBedrooms,
        'bedsPerSingleBedroom': bedsPerSingleBedroom,
        'maxGuests': maxGuests,
        'basePrice': basePrice,
        'weekendPrice': weekendPrice,
        'currentDynamicPrice': currentDynamicPrice,
        'occupancyPercentage': occupancyPercentage,
        'location': location,
        'locationAr': locationAr,
        'latitude': latitude,
        'longitude': longitude,
        'googleMapsUrl': googleMapsUrl,
        'isActive': isActive,
        'averageRating': averageRating,
        'totalReviews': totalReviews,
        'images': images.map((e) => e.toJson()).toList(),
        'amenities': amenities.map((e) => e.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Chalet && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
