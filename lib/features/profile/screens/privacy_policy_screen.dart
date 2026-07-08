import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/widgets/common_header.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        children: [
          CommonHeader(
            title: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.privacyPolicyTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: _PrivacyPolicyContent(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyPolicyContent extends StatelessWidget {
  const _PrivacyPolicyContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headingStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface,
    );
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last updated: January 1, 2025',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
        const SizedBox(height: 20),
        _Section(
          title: '1. Information We Collect',
          body:
              'We collect information you provide directly to us when you create an account, '
              'make a booking, or contact us for support. This includes your name, email address, '
              'phone number, and payment information. We also collect information automatically '
              'when you use our services, such as log data and device information.',
          headingStyle: headingStyle,
          bodyStyle: bodyStyle,
        ),
        _Section(
          title: '2. How We Use Your Information',
          body:
              'We use the information we collect to provide, maintain, and improve our services, '
              'process transactions, send you technical notices and support messages, and respond '
              'to your comments and questions. We may also use your information to send promotional '
              'communications, such as offers and news about GrandeBeach services.',
          headingStyle: headingStyle,
          bodyStyle: bodyStyle,
        ),
        _Section(
          title: '3. Information Sharing',
          body:
              'We do not share your personal information with third parties except as described '
              'in this policy. We may share information with vendors and service providers who '
              'need access to such information to carry out work on our behalf. We may also '
              'disclose information if we believe disclosure is in accordance with, or required '
              'by, any applicable law or legal process.',
          headingStyle: headingStyle,
          bodyStyle: bodyStyle,
        ),
        _Section(
          title: '4. Data Security',
          body:
              'We take reasonable measures to help protect information about you from loss, '
              'theft, misuse, and unauthorized access, disclosure, alteration, and destruction. '
              'All data is transmitted over secure connections using SSL/TLS encryption. '
              'Your payment information is handled by PCI-DSS compliant processors and is '
              'never stored on our servers.',
          headingStyle: headingStyle,
          bodyStyle: bodyStyle,
        ),
        _Section(
          title: '5. Your Rights',
          body:
              'You have the right to access, update, or delete the information we have on you. '
              'You may update your account information at any time through the Account Information '
              'section of your profile. To request deletion of your account and data, please '
              'contact our support team. You may also opt out of receiving promotional '
              'communications from us at any time.',
          headingStyle: headingStyle,
          bodyStyle: bodyStyle,
        ),
        _Section(
          title: '6. Cookies',
          body:
              'We use cookies and similar tracking technologies to track activity on our service '
              'and hold certain information. You can instruct your browser to refuse all cookies '
              'or to indicate when a cookie is being sent. However, if you do not accept cookies, '
              'you may not be able to use some portions of our service.',
          headingStyle: headingStyle,
          bodyStyle: bodyStyle,
        ),
        _Section(
          title: '7. Contact Us',
          body:
              'If you have any questions about this Privacy Policy, please contact us at '
              'privacy@grandebeach.com or through the support section in the application.',
          headingStyle: headingStyle,
          bodyStyle: bodyStyle,
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.body,
    this.headingStyle,
    this.bodyStyle,
  });

  final String title;
  final String body;
  final TextStyle? headingStyle;
  final TextStyle? bodyStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: headingStyle),
          const SizedBox(height: 8),
          Text(body, style: bodyStyle),
        ],
      ),
    );
  }
}
