import 'package:dio/dio.dart';

import '../../../core/config/api_strings.dart';
import '../models/booking.dart';
import '../models/bookings_page.dart';
import 'bookings_api_exception.dart';
import 'bookings_service.dart';

class BookingsServiceImpl implements BookingsService {
  BookingsServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<BookingsPage> fetchMyBookings({
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiStrings.myBookings,
      queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw BookingsApiException(
        body['message'] as String? ?? 'Failed to load bookings.',
      );
    }

    final data = body['data'] as Map<String, dynamic>;
    final bookings = (data['items'] as List<dynamic>)
        .map((e) => Booking.fromJson(e as Map<String, dynamic>))
        .toList();

    return BookingsPage(
      bookings: bookings,
      page: data['page'] as int? ?? pageNumber,
      pageSize: data['pageSize'] as int? ?? pageSize,
      totalCount: data['totalCount'] as int? ?? bookings.length,
      totalPages: data['totalPages'] as int? ?? 1,
      hasMore: data['hasNextPage'] as bool? ?? false,
    );
  }

  @override
  Future<Booking> fetchBookingById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiStrings.bookingById(id),
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw BookingsApiException(
        body['message'] as String? ?? 'Failed to load booking.',
      );
    }

    return Booking.fromJson(body['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> cancelBooking({required String id, required String reason}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiStrings.cancelBooking(id),
      data: {'reason': reason},
    );

    final body = response.data!;
    final success = body['success'] as bool? ?? false;
    if (!success) {
      throw BookingsApiException(
        body['message'] as String? ?? 'Failed to cancel booking.',
      );
    }
  }
}
