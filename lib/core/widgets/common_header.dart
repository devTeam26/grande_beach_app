import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Premium gold header shared across the main navigation screens.
///
/// The header sits at the top of the body (not in [Scaffold.appBar]) to allow
/// full control over the rounded bottom corners. Pass an optional [bottom]
/// widget to add extra content below the title row (used by Profile).
class CommonHeader extends StatelessWidget {
  final bool showNotification;
  const CommonHeader({
    super.key,
    required this.title,
    this.trailing,
    this.onNotificationTap,
    this.bottom,
    this.bottomHeight = 0,
    this.showNotification = false,
  });

  final Widget title;

  /// Optional custom widget for the right side (e.g. edit icon on sub-screens).
  /// When provided, replaces the notification bell regardless of [showNotification].
  final Widget? trailing;

  final VoidCallback? onNotificationTap;

  /// Extra content rendered below the title row (e.g. avatar + name).
  final Widget? bottom;

  /// Height of the [bottom] widget. Required when [bottom] is provided so the
  /// header can size itself correctly.
  final double bottomHeight;

  static const double _titleRowHeight = 70;
  static const double _borderRadius = 15;

  @override
  Widget build(BuildContext context) {
    final totalHeight = _titleRowHeight + bottomHeight;

    return Container(
      width: double.infinity,
      // height: totalHeight,
      decoration: const BoxDecoration(
        color: AppColors.headerGold,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(_borderRadius),
          bottomRight: Radius.circular(_borderRadius),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _titleRowHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Expanded(child: title),
                   if (trailing != null)
                      trailing!
                    else if (showNotification)
                      _NotificationButton(onTap: onNotificationTap),
                  ],
                ),
              ),
            ),
            ?bottom,
          ],
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.notifications_outlined,
          color: AppColors.headerGold,
          size: 20,
        ),
      ),
    );
  }
}
