import 'package:dio/dio.dart';

import '../../../core/config/api_strings.dart';
import '../models/add_on.dart';
import '../models/chalet_availability.dart';
import '../models/price_preview_result.dart';
import '../models/selected_add_on.dart';
import 'reservation_api_exception.dart';
import 'reservation_service.dart';

class ReservationServiceImpl implements ReservationService {
  ReservationServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<AddOn>> fetchAddOns() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiStrings.addOns);

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw ReservationApiException(
        body['message'] as String? ?? 'Failed to load add-ons.',
      );
    }

    final data = body['data'];
    final items = data is Map<String, dynamic> ? data['items'] : data;

    return (items as List<dynamic>)
        .map((e) => AddOn.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ChaletAvailability> fetchAvailability({
    required String chaletId,
    required DateTime from,
    required DateTime to,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiStrings.chaletAvailability(chaletId),
      queryParameters: {
        'from': _dateOnly(from),
        'to': _dateOnly(to),
      },
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw ReservationApiException(
        body['message'] as String? ?? 'Failed to load availability.',
      );
    }

    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw const ReservationApiException('Failed to load availability.');
    }

    return ChaletAvailability.fromJson(data);
  }

  @override
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
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.pricePreview,
      data: {
        'chaletId': chaletId,
        'guestFirstName': guestFirstName,
        'guestLastName': guestLastName,
        'guestEmail': guestEmail,
        'guestPhone': guestPhone,
        'checkInDate': _noonIso(checkInDate),
        'checkOutDate': _noonIso(checkOutDate),
        'guestCount': guestCount,
        'paymentType': 'Full',
        'preferredPaymentProvider': 'Tap',
        'addOns': addOns.map((e) => e.toJson()).toList(),
      },
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw ReservationApiException(
        body['message'] as String? ?? 'Failed to load price preview.',
      );
    }

    return PricePreviewResult.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
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
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.bookings,
      data: {
        'chaletId': chaletId,
        'guestFirstName': guestFirstName,
        'guestLastName': guestLastName,
        'guestEmail': guestEmail,
        'guestPhone': guestPhone,
        'checkInDate': _noonIso(checkInDate),
        'checkOutDate': _noonIso(checkOutDate),
        'guestCount': guestCount,
        'paymentType': 'Full',
        'preferredPaymentProvider': 'Tap',
        'addOns': addOns.map((e) => e.toJson()).toList(),
        if (specialRequests != null && specialRequests.trim().isNotEmpty)
          'specialRequests': specialRequests.trim(),
      },
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw ReservationApiException(
        body['message'] as String? ?? 'Failed to create booking.',
        errors: (body['errors'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
      );
    }
  }

  /// Formats [date] as `yyyy-MM-ddT12:00:00`, matching the API contract's
  /// example payload (date-only pickers default to midnight, which the
  /// backend does not expect).
  String _noonIso(DateTime date) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${pad(date.month)}-${pad(date.day)}T12:00:00';
  }

  /// Formats [date] as `yyyy-MM-dd` for the availability `from`/`to` query
  /// parameters (e.g. `2026-07-01`).
  String _dateOnly(DateTime date) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${pad(date.month)}-${pad(date.day)}';
  }
}
