import 'booking_status.dart';

/// A single booking returned by `/api/Bookings/my`.
class Booking {
  const Booking({
    required this.id,
    required this.bookingNumber,
    required this.chaletId,
    required this.chaletName,
    required this.chaletType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.nights,
    required this.guestCount,
    required this.guestFirstName,
    required this.guestLastName,
    required this.guestEmail,
    required this.guestPhone,
    required this.baseAmount,
    required this.addOnsAmount,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.status,
    this.chaletImageUrl,
    this.chaletLocation,
  });

  final String id;
  final String bookingNumber;
  final String chaletId;
  final String chaletName;
  final String chaletType;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int nights;
  final int guestCount;
  final String guestFirstName;
  final String guestLastName;
  final String guestEmail;
  final String guestPhone;
  final double baseAmount;
  final double addOnsAmount;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final BookingStatus status;

  /// Not returned by the current API payload; kept nullable so a future
  /// backend addition (chalet image/location) is picked up without a model
  /// change.
  final String? chaletImageUrl;
  final String? chaletLocation;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as String,
        bookingNumber: json['bookingNumber'] as String,
        chaletId: json['chaletId'] as String,
        chaletName: json['chaletName'] as String,
        chaletType: json['chaletType'] as String,
        checkInDate: DateTime.parse(json['checkInDate'] as String),
        checkOutDate: DateTime.parse(json['checkOutDate'] as String),
        nights: json['nights'] as int,
        guestCount: json['guestCount'] as int,
        guestFirstName: json['guestFirstName'] as String? ?? '',
        guestLastName: json['guestLastName'] as String? ?? '',
        guestEmail: json['guestEmail'] as String? ?? '',
        guestPhone: json['guestPhone'] as String? ?? '',
        baseAmount: (json['baseAmount'] as num).toDouble(),
        addOnsAmount: (json['addOnsAmount'] as num?)?.toDouble() ?? 0,
        discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
        taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0,
        totalAmount: (json['totalAmount'] as num).toDouble(),
        status: BookingStatusX.fromApi(json['status'] as String),
        chaletImageUrl: json['chaletImageUrl'] as String?,
        chaletLocation: json['chaletLocation'] as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Booking && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
