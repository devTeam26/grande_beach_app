import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

enum _RangeFocus { checkIn, checkOut }

/// Inline monthly calendar for selecting a check-in/check-out range, plus the
/// two read-only fields shown below it.
class DateRangePicker extends StatefulWidget {
  const DateRangePicker({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.onCheckInChanged,
    required this.onCheckOutChanged,
  });

  final DateTime? checkIn;
  final DateTime? checkOut;
  final ValueChanged<DateTime?> onCheckInChanged;
  final ValueChanged<DateTime?> onCheckOutChanged;

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late DateTime _visibleMonth;
  _RangeFocus _focus = _RangeFocus.checkIn;

  @override
  void initState() {
    super.initState();
    final base = widget.checkIn ?? DateTime.now();
    _visibleMonth = DateTime(base.year, base.month);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isBeforeToday(DateTime day) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    return day.isBefore(todayOnly);
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  void _selectDay(DateTime day) {
    final checkIn = widget.checkIn;
    final checkOut = widget.checkOut;

    if (_focus == _RangeFocus.checkIn || checkIn == null || checkOut != null) {
      widget.onCheckInChanged(day);
      setState(() => _focus = _RangeFocus.checkOut);
      return;
    }

    if (!day.isAfter(checkIn)) {
      widget.onCheckInChanged(day);
      return;
    }

    widget.onCheckOutChanged(day);
    setState(() => _focus = _RangeFocus.checkIn);
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
    final days = _buildGridDays(_visibleMonth);

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
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                children: days.map((day) {
                  if (day == null) return const SizedBox.shrink();

                  final isCheckIn =
                      widget.checkIn != null && _isSameDay(day, widget.checkIn!);
                  final isCheckOut =
                      widget.checkOut != null && _isSameDay(day, widget.checkOut!);
                  final inRange = hasRange &&
                      day.isAfter(widget.checkIn!) &&
                      day.isBefore(widget.checkOut!);
                  final disabled = _isBeforeToday(day);

                  return GestureDetector(
                    onTap: disabled ? null : () => _selectDay(day),
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
                                  widthFactor: 0.5,
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
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (isCheckIn || isCheckOut)
                                  ? AppColors.primaryGold
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    (isCheckIn || isCheckOut) ? FontWeight.w700 : null,
                                color: disabled
                                    ? theme.colorScheme.onSurface.withValues(alpha: 0.25)
                                    : (isCheckIn || isCheckOut)
                                        ? Colors.white
                                        : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
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
