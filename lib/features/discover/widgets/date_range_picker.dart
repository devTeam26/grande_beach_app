import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../reservation/models/chalet_availability.dart';

enum _RangeFocus { checkIn, checkOut }

/// Inline monthly calendar for selecting a check-in/check-out range, plus the
/// two read-only fields shown below it.
///
/// The picker optionally renders backend availability for the visible month:
/// daily prices, weekend highlighting, and blocked/booked days that cannot be
/// selected. Passing [onMonthChanged] switches on "availability mode"; without
/// it the picker behaves as a plain range calendar (e.g. the Discover search
/// sheet).
class DateRangePicker extends StatefulWidget {
  const DateRangePicker({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.onCheckInChanged,
    required this.onCheckOutChanged,
    this.availability,
    this.isLoadingAvailability = false,
    this.availabilityError,
    this.onRetry,
    this.onMonthChanged,
    this.onBlockedSelection,
  });

  final DateTime? checkIn;
  final DateTime? checkOut;
  final ValueChanged<DateTime?> onCheckInChanged;
  final ValueChanged<DateTime?> onCheckOutChanged;

  /// Availability + daily pricing for the currently visible month. Null while
  /// loading, on error, or when not in availability mode.
  final ChaletAvailability? availability;

  /// Whether the visible month's availability is currently being fetched.
  final bool isLoadingAvailability;

  /// Message to show in place of the grid when availability failed to load.
  final String? availabilityError;

  /// Called when the user retries a failed availability load.
  final VoidCallback? onRetry;

  /// Called with the first day of the visible month on first build and on
  /// every month change. Presence of this callback enables availability mode.
  final ValueChanged<DateTime>? onMonthChanged;

  /// Called when the user attempts to pick a blocked day, or a range that
  /// would span one. Lets the parent surface a message.
  final VoidCallback? onBlockedSelection;

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late DateTime _visibleMonth;
  _RangeFocus _focus = _RangeFocus.checkIn;

  bool get _availabilityMode => widget.onMonthChanged != null;

  @override
  void initState() {
    super.initState();
    final base = widget.checkIn ?? DateTime.now();
    _visibleMonth = DateTime(base.year, base.month);
    // Report the initial month so the parent can load its availability.
    if (widget.onMonthChanged != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onMonthChanged!(_visibleMonth);
      });
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isBeforeToday(DateTime day) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    return day.isBefore(todayOnly);
  }

  bool _isUnavailable(DateTime day) =>
      widget.availability?.isUnavailable(day) ?? false;

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
    widget.onMonthChanged?.call(_visibleMonth);
  }

  void _selectDay(DateTime day) {
    // Blocked/booked days can never be selected.
    if (_isUnavailable(day)) {
      widget.onBlockedSelection?.call();
      return;
    }

    final checkIn = widget.checkIn;
    final checkOut = widget.checkOut;

    // Editing check-out specifically (user tapped the Check-out field):
    // only touch check-out, so an already-valid check-in stays put.
    if (_focus == _RangeFocus.checkOut && checkIn != null) {
      if (day.isAfter(checkIn)) {
        // The whole selected range must stay clear of blocked nights.
        if (widget.availability?.rangeHasUnavailable(checkIn, day) ?? false) {
          widget.onBlockedSelection?.call();
          return;
        }
        widget.onCheckOutChanged(day);
        setState(() => _focus = _RangeFocus.checkIn);
        return;
      }
      // Picked a day at/before check-in while editing check-out: it can't
      // be a valid check-out, so restart the range from this new day
      // instead of leaving the old check-out stuck in place.
    }

    // Starting or restarting a range: set check-in and drop any stale
    // check-out so the picker doesn't get stuck on a mismatched old date.
    widget.onCheckInChanged(day);
    if (checkOut != null) widget.onCheckOutChanged(null);
    setState(() => _focus = _RangeFocus.checkOut);
  }

  List<DateTime?> _buildGridDays(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = firstDayOfMonth.weekday % 7;

    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var d = 1; d <= daysInMonth; d++) DateTime(month.year, month.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final weekdayReference = DateTime(2023, 1, 1); // a Sunday

    final hasRange = widget.checkIn != null && widget.checkOut != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Calendars are always laid out left-to-right (Sun→Sat), regardless
        // of app locale, matching common hotel-booking UIs.
        Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => _changeMonth(-1),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text(
                      DateFormat.yMMMM(locale).format(_visibleMonth),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _changeMonth(1),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              Row(
                children: List.generate(7, (i) {
                  final label = DateFormat.E(locale)
                      .format(weekdayReference.add(Duration(days: i)));
                  return Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 4),
              _buildCalendarBody(theme, l10n, hasRange),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _DateField(
                label: l10n.checkInLabel,
                value: widget.checkIn,
                isActive: _focus == _RangeFocus.checkIn,
                onTap: () => setState(() => _focus = _RangeFocus.checkIn),
                locale: locale,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DateField(
                label: l10n.checkOutLabel,
                value: widget.checkOut,
                isActive: _focus == _RangeFocus.checkOut,
                onTap: () => setState(() => _focus = _RangeFocus.checkOut),
                locale: locale,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarBody(
    ThemeData theme,
    AppLocalizations l10n,
    bool hasRange,
  ) {
    if (_availabilityMode && widget.isLoadingAvailability) {
      return const _CalendarSkeleton();
    }
    if (_availabilityMode &&
        widget.availabilityError != null &&
        widget.availability == null) {
      return _AvailabilityError(
        message: widget.availabilityError!,
        onRetry: widget.onRetry,
      );
    }
    return _buildGrid(theme, l10n, hasRange);
  }

  Widget _buildGrid(ThemeData theme, AppLocalizations l10n, bool hasRange) {
    final days = _buildGridDays(_visibleMonth);
    final availability = widget.availability;

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: _availabilityMode ? 0.74 : 1.2,
      children: days.map((day) {
        if (day == null) return const SizedBox.shrink();

        final isCheckIn =
            widget.checkIn != null && _isSameDay(day, widget.checkIn!);
        final isCheckOut =
            widget.checkOut != null && _isSameDay(day, widget.checkOut!);
        final inRange = hasRange &&
            day.isAfter(widget.checkIn!) &&
            day.isBefore(widget.checkOut!);
        final unavailable = _isUnavailable(day);
        final past = _isBeforeToday(day);
        final disabled = past || unavailable;

        final dayInfo = availability?.dayFor(day);
        final showPrice = _availabilityMode &&
            !disabled &&
            !isCheckIn &&
            !isCheckOut &&
            dayInfo != null;

        return _DayCell(
          day: day,
          isCheckIn: isCheckIn,
          isCheckOut: isCheckOut,
          inRange: inRange,
          hasRange: hasRange,
          disabled: disabled,
          unavailable: unavailable,
          isWeekend: dayInfo?.isWeekend ?? false,
          priceLabel: showPrice
              ? '${l10n.kwdCurrency} ${dayInfo.price.toStringAsFixed(0)}'
              : null,
          // Past days are truly inert; blocked days stay tappable so the tap
          // can explain (via onBlockedSelection) why they can't be selected.
          onTap: past ? null : () => _selectDay(day),
        );
      }).toList(),
    );
  }
}

/// A single day cell, shared by the plain and availability-aware layouts.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isCheckIn,
    required this.isCheckOut,
    required this.inRange,
    required this.hasRange,
    required this.disabled,
    required this.unavailable,
    required this.isWeekend,
    required this.priceLabel,
    required this.onTap,
  });

  final DateTime day;
  final bool isCheckIn;
  final bool isCheckOut;
  final bool inRange;
  final bool hasRange;
  final bool disabled;
  final bool unavailable;
  final bool isWeekend;
  final String? priceLabel;
  final VoidCallback? onTap;

  static const Color _unavailableColor = Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = isCheckIn || isCheckOut;

    // The number circle: gold when selected, a soft red when unavailable, a
    // soft gold/yellow when it's an available weekend, otherwise transparent.
    // Unavailable always wins over the weekend highlight.
    final Color? circleColor;
    if (isSelected) {
      circleColor = AppColors.primaryGold;
    } else if (unavailable) {
      circleColor = _unavailableColor.withValues(alpha: 0.12);
    } else if (isWeekend) {
      circleColor = AppColors.primaryGold.withValues(alpha: 0.18);
    } else {
      circleColor = null;
    }

    final Color numberColor;
    if (isSelected) {
      numberColor = Colors.white;
    } else if (unavailable) {
      numberColor = _unavailableColor;
    } else if (disabled) {
      numberColor = theme.colorScheme.onSurface.withValues(alpha: 0.25);
    } else {
      numberColor = theme.colorScheme.onSurface;
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (inRange)
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  color: AppColors.primaryGold.withValues(alpha: 0.15),
                ),
              ),
            if (hasRange && isCheckIn)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold.withValues(alpha: 0.15),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (hasRange && isCheckOut)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold.withValues(alpha: 0.15),
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : null,
                      color: numberColor,
                      decoration:
                          unavailable ? TextDecoration.lineThrough : null,
                      decorationColor: _unavailableColor,
                    ),
                  ),
                ),
                if (priceLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        priceLabel!,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer placeholder shown while a month's availability is loading. Matches
/// the 7-column grid so the layout doesn't jump when data arrives.
class _CalendarSkeleton extends StatelessWidget {
  const _CalendarSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.74,
        children: List.generate(
          35,
          (_) => const Center(
            child: SkeletonBox(height: 44, width: 30, borderRadius: 8),
          ),
        ),
      ),
    );
  }
}

/// Compact inline error for a failed availability load, sized to sit inside
/// the calendar area rather than take over the screen.
class _AvailabilityError extends StatelessWidget {
  const _AvailabilityError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 40,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          if (onRetry != null)
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryGold,
                side: const BorderSide(color: AppColors.primaryGold),
              ),
              child: Text(l10n.retry),
            ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.isActive,
    required this.onTap,
    required this.locale,
  });

  final String label;
  final DateTime? value;
  final bool isActive;
  final VoidCallback onTap;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.inputFill(theme.brightness),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.primaryGold : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value != null ? DateFormat.MMMd(locale).format(value!) : '—',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
