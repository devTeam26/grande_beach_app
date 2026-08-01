import 'package:url_launcher/url_launcher.dart';

import '../localization/generated/app_localizations.dart';

/// Opens WhatsApp deep links (`https://wa.me/...`) for support and inquiry
/// flows. We don't use the WhatsApp Business API — this only builds
/// pre-filled `wa.me` links and hands them to the OS via [url_launcher].
class WhatsAppService {
  const WhatsAppService();

  /// Support number without the leading `+`, as required by `wa.me`.
  static const String _supportPhoneNumber = '96590976666';

  Future<void> openSupportChat(AppLocalizations l10n) {
    return _launch(l10n.whatsappSupportMessage);
  }

  Future<void> openChaletInquiry(
    AppLocalizations l10n, {
    required String chaletName,
  }) {
    return _launch(l10n.whatsappChaletInquiryMessage(chaletName));
  }

  Future<void> openChaletCancelationPolicyInquiry(
    AppLocalizations l10n, {
    required String chaletName,
  }) {
    return _launch(
      l10n.whatsappChaletCancelationPolicyInquiryMessage(chaletName),
    );
  }

  Future<void> openBookingSupport(
    AppLocalizations l10n, {
    String? bookingNumber,
  }) {
    final message = bookingNumber == null || bookingNumber.isEmpty
        ? l10n.whatsappBookingSupportMessage
        : l10n.whatsappBookingSupportMessageWithNumber(bookingNumber);
    return _launch(message);
  }

  Future<void> _launch(String message) async {
    final uri = Uri.https('wa.me', _supportPhoneNumber, {'text': message});
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
