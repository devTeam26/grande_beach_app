import '../models/add_on.dart';
import '../models/chalet_availability.dart';
import '../models/price_preview_result.dart';
import '../models/selected_add_on.dart';

abstract class ReservationService {
  Future<List<AddOn>> fetchAddOns();

  /// Availability and daily pricing for [chaletId] between [from] and [to]
  /// (the visible month's first and last day).
  Future<ChaletAvailability> fetchAvailability({
    required String chaletId,
    required DateTime from,
    required DateTime to,
  });

  Future<PricePreviewResult> fetchPricePreview({
    required String chaletId,
    required String guestFirstName,
    required String guestLastName,
    required String guestEmail,
    required String guestPhone,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int guestCount,
    required List<SelectedAddOn> addOns,
  });

  Future<void> createBooking({
    required String chaletId,
    required String guestFirstName,
    required String guestLastName,
    required String guestEmail,
    required String guestPhone,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int guestCount,
    required List<SelectedAddOn> addOns,
    String? specialRequests,
  });
}
