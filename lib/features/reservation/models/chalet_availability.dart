/// A single blocked/booked date range returned by the availability endpoint.
/// Both [from] and [to] are inclusive.
class BlockedDate {
  const BlockedDate({required this.from, required this.to});

  final DateTime from;
  final DateTime to;

  factory BlockedDate.fromJson(Map<String, dynamic> json) => BlockedDate(
        from: DateTime.parse(json['from'] as String),
        to: DateTime.parse(json['to'] as String),
      );

  /// Whether [day] falls within this blocked range (date-only comparison).
  bool contains(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    return !d.isBefore(start) && !d.isAfter(end);
  }
}

/// One day of the price calendar: its nightly price plus availability and
/// weekend flags, as returned by the backend.
class PriceCalendarDay {
  const PriceCalendarDay({
    required this.date,
    required this.price,
    required this.isAvailable,
    required this.isWeekend,
  });

  final DateTime date;
  final double price;
  final bool isAvailable;
  final bool isWeekend;

  factory PriceCalendarDay.fromJson(Map<String, dynamic> json) =>
      PriceCalendarDay(
        date: DateTime.parse(json['date'] as String),
        price: (json['price'] as num?)?.toDouble() ?? 0,
        isAvailable: json['isAvailable'] as bool? ?? true,
        isWeekend: json['isWeekend'] as bool? ?? false,
      );
}

/// Availability and daily pricing for a chalet over a single displayed month,
/// mapped from `GET /api/Chalets/{id}/availability`.
class ChaletAvailability {
  ChaletAvailability({
    required this.chaletId,
    required this.blockedDates,
    required this.priceCalendar,
  });

  final String chaletId;
  final List<BlockedDate> blockedDates;
  final List<PriceCalendarDay> priceCalendar;

  /// Day-keyed index of the price calendar, built once for O(1) cell lookups.
  late final Map<String, PriceCalendarDay> _byDay = {
    for (final d in priceCalendar) _key(d.date): d,
  };

  factory ChaletAvailability.fromJson(Map<String, dynamic> json) =>
      ChaletAvailability(
        chaletId: json['chaletId'] as String? ?? '',
        blockedDates: (json['blockedDates'] as List<dynamic>? ?? [])
            .map((e) => BlockedDate.fromJson(e as Map<String, dynamic>))
            .toList(),
        priceCalendar: (json['priceCalendar'] as List<dynamic>? ?? [])
            .map((e) => PriceCalendarDay.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// The price-calendar entry for [day], or null if not present in this month.
  PriceCalendarDay? dayFor(DateTime day) => _byDay[_key(day)];

  /// Whether [day] is unavailable — either covered by a [blockedDates] range
  /// or flagged `isAvailable: false` in the price calendar.
  bool isUnavailable(DateTime day) {
    if (blockedDates.any((b) => b.contains(day))) return true;
    final info = dayFor(day);
    return info != null && !info.isAvailable;
  }

  /// Whether [day] is flagged as a weekend in the price calendar.
  bool isWeekend(DateTime day) => dayFor(day)?.isWeekend ?? false;

  /// Whether any night in the range [checkIn, checkOut) is unavailable.
  /// The check-out day itself is a departure day, so it is not included.
  bool rangeHasUnavailable(DateTime checkIn, DateTime checkOut) {
    var cursor = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final end = DateTime(checkOut.year, checkOut.month, checkOut.day);
    while (cursor.isBefore(end)) {
      if (isUnavailable(cursor)) return true;
      cursor = cursor.add(const Duration(days: 1));
    }
    return false;
  }
}
