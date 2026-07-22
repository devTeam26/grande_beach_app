import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// Mirrors the `status` values returned by `/api/Bookings/my`.
enum BookingStatus { pending, confirmed, checkedIn, checkedOut, cancelled, rejected }

extension BookingStatusX on BookingStatus {
  static BookingStatus fromApi(String value) {
    switch (value) {
      case 'Pending':
        return BookingStatus.pending;
      case 'Confirmed':
        return BookingStatus.confirmed;
      case 'CheckedIn':
        return BookingStatus.checkedIn;
      case 'CheckedOut':
        return BookingStatus.checkedOut;
      case 'Cancelled':
        return BookingStatus.cancelled;
      case 'Rejected':
        return BookingStatus.rejected;
      default:
        return BookingStatus.pending;
    }
  }

  /// Whether this status still allows the booking to be cancelled by the
  /// guest (i.e. it hasn't reached a final state yet).
  bool get isCancellable =>
      this == BookingStatus.pending ||
      this == BookingStatus.confirmed ||
      this == BookingStatus.checkedIn;

  /// Display label — "Completed" is shown instead of "Checked Out", and
  /// "Confirmed" instead of "Checked In" (guests don't need to distinguish
  /// the two once the stay is upcoming/active).
  String label(AppLocalizations l10n) {
    switch (this) {
      case BookingStatus.pending:
        return l10n.bookingStatusPending;
      case BookingStatus.confirmed:
      case BookingStatus.checkedIn:
        return l10n.bookingStatusConfirmed;
      case BookingStatus.checkedOut:
        return l10n.bookingStatusCompleted;
      case BookingStatus.cancelled:
        return l10n.bookingStatusCancelled;
      case BookingStatus.rejected:
        return l10n.bookingStatusRejected;
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return AppColors.statusPending;
      case BookingStatus.confirmed:
      case BookingStatus.checkedIn:
        return AppColors.statusConfirmed;
      case BookingStatus.checkedOut:
        return AppColors.statusCompleted;
      case BookingStatus.cancelled:
        return AppColors.statusCancelled;
      case BookingStatus.rejected:
        return AppColors.statusRejected;
    }
  }
}

/// The four tabs on the Bookings screen.
enum BookingTab { ongoing, completed, cancelled, rejected }

extension BookingTabX on BookingTab {
  String label(AppLocalizations l10n) {
    switch (this) {
      case BookingTab.ongoing:
        return l10n.bookingsOngoingTab;
      case BookingTab.completed:
        return l10n.bookingsCompletedTab;
      case BookingTab.cancelled:
        return l10n.bookingsCancelledTab;
      case BookingTab.rejected:
        return l10n.bookingsRejectedTab;
    }
  }

  bool matches(BookingStatus status) {
    switch (this) {
      case BookingTab.ongoing:
        return status == BookingStatus.pending ||
            status == BookingStatus.confirmed ||
            status == BookingStatus.checkedIn;
      case BookingTab.completed:
        return status == BookingStatus.checkedOut;
      case BookingTab.cancelled:
        return status == BookingStatus.cancelled;
      case BookingTab.rejected:
        return status == BookingStatus.rejected;
    }
  }
}
