import 'package:grande_beach/core/errors/failure.dart';
import 'package:grande_beach/core/utils/result.dart';
import 'package:grande_beach/features/authentication/models/user_model.dart';
import 'package:grande_beach/features/authentication/repositories/auth_repository.dart';
import 'package:grande_beach/features/booking/models/booking.dart';
import 'package:grande_beach/features/booking/models/bookings_page.dart';
import 'package:grande_beach/features/booking/repositories/bookings_repository.dart';
import 'package:grande_beach/features/reservation/models/add_on.dart';
import 'package:grande_beach/features/reservation/models/chalet_availability.dart';
import 'package:grande_beach/features/reservation/models/price_preview_result.dart';
import 'package:grande_beach/features/reservation/models/selected_add_on.dart';
import 'package:grande_beach/features/reservation/repositories/reservation_repository.dart';

const testUser = UserModel(
  id: 'u1',
  firstName: 'Sara',
  lastName: 'Ali',
  email: 'sara@example.com',
  phoneNumber: '+96550000000',
  preferredLanguage: 'en',
  loyaltyPoints: 0,
  totalBookings: 0,
  roles: ['Customer'],
);

const testPreview = PricePreviewResult(
  baseAmount: 840,
  addOnsAmount: 0,
  taxAmount: 126,
  totalAmount: 966,
  breakdown: [],
);

/// Auth repository whose sign-in outcome is configured per test.
class FakeAuthRepository implements AuthRepository {
  Result<UserModel> nextResult = const Success(testUser);
  int loginCalls = 0;
  int googleCalls = 0;

  @override
  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) async {
    loginCalls++;
    return nextResult;
  }

  @override
  Future<Result<UserModel>> loginWithGoogle() async {
    googleCalls++;
    return nextResult;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Records every reservation call so tests can assert what reached the API.
class FakeReservationRepository implements ReservationRepository {
  final previewCalls = <Map<String, Object?>>[];
  int createBookingCalls = 0;

  @override
  Future<Result<List<AddOn>>> fetchAddOns() async => const Success([]);

  @override
  Future<Result<ChaletAvailability>> fetchAvailability({
    required String chaletId,
    required DateTime from,
    required DateTime to,
  }) async =>
      const ResultFailure(NetworkFailure('offline'));

  @override
  Future<Result<PricePreviewResult>> fetchPricePreview({
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
    previewCalls.add({
      'chaletId': chaletId,
      'guestFirstName': guestFirstName,
      'guestEmail': guestEmail,
      'guestCount': guestCount,
    });
    return const Success(testPreview);
  }

  @override
  Future<Result<void>> createBooking({
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
    createBookingCalls++;
    return const Success(null);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Counts authenticated bookings requests; a guest must never trigger one.
class FakeBookingsRepository implements BookingsRepository {
  int fetchCalls = 0;

  @override
  Future<Result<BookingsPage>> fetchMyBookings({
    required int pageNumber,
    required int pageSize,
  }) async {
    fetchCalls++;
    return const ResultFailure(UnauthorizedFailure('unauthorized'));
  }

  @override
  Future<Result<Booking>> fetchBookingById(String id) async =>
      const ResultFailure(UnauthorizedFailure('unauthorized'));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
