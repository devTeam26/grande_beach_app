import 'package:flutter/material.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// Mirrors the `status` values returned by `/api/Bookings/my`.
enum BookingStatus { pending, confirmed, checkedIn, checkedOut, cancelled }

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
      default:
        return BookingStatus.pending;
    }
  }

  /// Display label — "Completed" is shown instead of "Checked Out".
  String label(AppLocalizations l10n) {
    switch (this) {
      case BookingStatus.pending:
        return l10n.bookingStatusPending;
      case BookingStatus.confirmed:
        return l10n.bookingStatusConfirmed;
      case BookingStatus.checkedIn:
        return l10n.bookingStatusCheckedIn;
      case BookingStatus.checkedOut:
        return l10n.bookingStatusCompleted;
      case BookingStatus.cancelled:
        return l10n.bookingStatusCancelled;
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return AppColors.statusPending;
      case BookingStatus.confirmed:
        return AppColors.statusConfirmed;
      case BookingStatus.checkedIn:
        return AppColors.statusCheckedIn;
      case BookingStatus.checkedOut:
        return AppColors.statusCompleted;
      case BookingStatus.cancelled:
        return AppColors.statusCancelled;
    }
  }
}

/// The three tabs on the Bookings screen.
enum BookingTab { ongoing, completed, cancelled }

extension BookingTabX on BookingTab {
  String label(AppLocalizations l10n) {
    switch (this) {
      case BookingTab.ongoing:
        return l10n.bookingsOngoingTab;
      case BookingTab.completed:
        return l10n.bookingsCompletedTab;
      case BookingTab.cancelled:
        return l10n.bookingsCancelledTab;
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
    }
  }
}
