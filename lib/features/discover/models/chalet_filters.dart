import 'package:intl/intl.dart';

/// Draft/active search filters for the Discover chalet catalog.
/// Serializes to the exact query parameter names /api/Chalets expects.
class ChaletFilters {
  const ChaletFilters({
    this.checkIn,
    this.checkOut,
    this.chaletType,
    this.guests,
    this.minPrice,
    this.maxPrice,
  });

  const ChaletFilters.empty()
      : checkIn = null,
        checkOut = null,
        chaletType = null,
        guests = null,
        minPrice = null,
        maxPrice = null;

  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? chaletType;
  final int? guests;
  final double? minPrice;
  final double? maxPrice;

  bool get isEmpty =>
      checkIn == null &&
      checkOut == null &&
      chaletType == null &&
      guests == null &&
      minPrice == null &&
      maxPrice == null;

  ChaletFilters copyWith({
    DateTime? checkIn,
    bool clearCheckIn = false,
    DateTime? checkOut,
    bool clearCheckOut = false,
    String? chaletType,
    bool clearChaletType = false,
    int? guests,
    bool clearGuests = false,
    double? minPrice,
    bool clearMinPrice = false,
    double? maxPrice,
    bool clearMaxPrice = false,
  }) {
    return ChaletFilters(
      checkIn: clearCheckIn ? null : (checkIn ?? this.checkIn),
      checkOut: clearCheckOut ? null : (checkOut ?? this.checkOut),
      chaletType: clearChaletType ? null : (chaletType ?? this.chaletType),
      guests: clearGuests ? null : (guests ?? this.guests),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
    );
  }

  /// Only includes parameters that have values — the backend must never
  /// receive nulls.
  Map<String, dynamic> toQueryParameters() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return {
      if (checkIn != null) 'CheckIn': dateFormat.format(checkIn!),
      if (checkOut != null) 'CheckOut': dateFormat.format(checkOut!),
      if (chaletType != null) 'Type': chaletType,
      if (guests != null) 'Guests': guests,
      if (minPrice != null) 'MinPrice': minPrice,
      if (maxPrice != null) 'MaxPrice': maxPrice,
    };
  }
}
