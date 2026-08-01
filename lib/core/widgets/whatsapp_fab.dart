import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_colors.dart';

/// Floating WhatsApp button used on detail screens (chalet, booking) to
/// start a contextual WhatsApp inquiry.
class WhatsAppFab extends StatelessWidget {
  const WhatsAppFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      backgroundColor: AppColors.whatsappGreen,
      foregroundColor: Colors.white,
      child: const Icon(FontAwesomeIcons.whatsapp),
    );
  }
}
