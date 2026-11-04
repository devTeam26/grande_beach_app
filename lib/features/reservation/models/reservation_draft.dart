import '../../../core/utils/kuwait_phone.dart';
import 'price_preview_result.dart';
import 'selected_add_on.dart';

/// Returns whether [count] is a valid guest count for a chalet allowing up
/// to [maxGuests] guests.
bool isValidGuestCount(int? count, int maxGuests) =>
    count != null && count >= 1 && count <= maxGuests;


/// The in-progress booking, built up across the reservation wizard's steps.
/// Each step only mutates the fields it owns; submission to a real booking
/// endpoint is out of scope for this wizard.
class ReservationDraft {
  const ReservationDraft({
    required this.chaletId,
    this.checkIn,
    this.checkOut,
    this.guestCount,
    this.selectedAddOns = const [],
    this.pricePreview,
    this.specialRequest,
    this.phoneNumber,
  });

  final String chaletId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? guestCount;
  final List<SelectedAddOn> selectedAddOns;
  final PricePreviewResult? pricePreview;

  /// Optional free-text note from the guest (e.g. early check-in, a specific
  /// unit request). Sent as-is with the booking; never required.
  final String? specialRequest;

  /// Local 8-digit Kuwaiti contact number for this booking, without the
  /// country code. Prefilled from the signed-in user's profile when
  /// available, editable by the guest, and required.
  final String? phoneNumber;

  /// [phoneNumber] with the `+965` country code, as sent to the backend.
  String? get fullPhoneNumber => KuwaitPhone.isValidLocal(phoneNumber)
      ? KuwaitPhone.withCountryCode(phoneNumber!)
      : null;

  bool isStep1Valid(int maxGuests) =>
      checkIn != null &&
      checkOut != null &&
      checkOut!.isAfter(checkIn!) &&
      isValidGuestCount(guestCount, maxGuests) &&
      KuwaitPhone.isValidLocal(phoneNumber);

  ReservationDraft copyWith({
    DateTime? checkIn,
    bool clearCheckIn = false,
    DateTime? checkOut,
    bool clearCheckOut = false,
    int? guestCount,
    List<SelectedAddOn>? selectedAddOns,
    PricePreviewResult? pricePreview,
    String? specialRequest,
    String? phoneNumber,
  }) {
    return ReservationDraft(
      chaletId: chaletId,
      checkIn: clearCheckIn ? null : (checkIn ?? this.checkIn),
      checkOut: clearCheckOut ? null : (checkOut ?? this.checkOut),
      guestCount: guestCount ?? this.guestCount,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
      pricePreview: pricePreview ?? this.pricePreview,
      specialRequest: specialRequest ?? this.specialRequest,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
