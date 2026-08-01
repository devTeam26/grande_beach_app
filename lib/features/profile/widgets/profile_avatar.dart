import 'package:flutter/material.dart';
import 'package:grande_beach/core/theme/app_colors.dart';
import 'package:grande_beach/features/authentication/models/user_model.dart';

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({super.key, required this.user, required this.avatarHeight});

  final UserModel? user;
  final double avatarHeight;

  @override
  Widget build(BuildContext context) {
    final firstName = user?.firstName ?? '';
    final lastName = user?.lastName ?? '';
    final fullName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
    final avatarLetter =
        firstName.isNotEmpty ? firstName[0].toUpperCase() : '?';
    final theme = Theme.of(context);    

    return SizedBox(
      height: avatarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.headerAvatarGold,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              avatarLetter,
              style:  TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (fullName.isNotEmpty)
            Text(
              fullName,
              style:  TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (user?.email != null) ...[
            const SizedBox(height: 2),
            Text(
              user!.email,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
