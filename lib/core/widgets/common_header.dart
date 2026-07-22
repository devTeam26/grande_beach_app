import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'whatsapp_header_button.dart';

/// Premium gold header shared across the main navigation screens.
///
/// The header sits at the top of the body (not in [Scaffold.appBar]) to allow
/// full control over the rounded bottom corners. Pass an optional [bottom]
/// widget to add extra content below the title row (used by Profile).
class CommonHeader extends StatelessWidget {
  const CommonHeader({
    super.key,
    required this.title,
    this.trailing,
    this.bottom,
    this.bottomHeight = 0,
    this.showBackButton = false,
    this.onBackPressed,
  });

  final Widget title;

  /// Optional custom widget for the right side (e.g. edit icon on sub-screens).
  /// When provided, replaces the WhatsApp button.
  final Widget? trailing;

  /// Extra content rendered below the title row (e.g. avatar + name).
  final Widget? bottom;

  /// Height of the [bottom] widget. Required when [bottom] is provided so the
  /// header can size itself correctly.
  final double bottomHeight;

  /// Shows a platform-appropriate back button before [title] — a chevron on
  /// iOS, a Material arrow on Android — instead of every sub-screen building
  /// its own.
  final bool showBackButton;

  /// Defaults to popping the current route.
  final VoidCallback? onBackPressed;

  static const double _titleRowHeight = 70;
  static const double _borderRadius = 15;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                    if (showBackButton) ...[
                      _BackButton(
                        onPressed: onBackPressed ??
                            () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(child: title),
                   if (trailing != null)
                      trailing!
                    else
                      const WhatsAppHeaderButton(),
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

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;

    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        isAndroid ? Icons.arrow_back : Icons.arrow_back_ios_new,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
