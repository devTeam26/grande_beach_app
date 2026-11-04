/// Kuwait phone number rules. Numbers are entered locally as 8 digits and
/// sent to the backend with the `+965` country code.
abstract final class KuwaitPhone {
  static const countryCode = '+965';
  static const localLength = 8;

  /// Mobile numbers start with 4, 5, 6 or 9; landlines start with 2.
  static final _localPattern = RegExp(r'^[24569][0-9]{7}$');

  /// Strips any `+965`, `00965` or `965` prefix and returns the local
  /// 8-digit part (as far as it can be recovered), or `null` if empty.
  static String? toLocal(String? phone) {
    if (phone == null) return null;
    var digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    for (final prefix in ['00965', '965']) {
      if (digits.length > localLength && digits.startsWith(prefix)) {
        digits = digits.substring(prefix.length);
        break;
      }
    }
    return digits.isEmpty ? null : digits;
  }

  static bool isValidLocal(String? local) =>
      local != null && _localPattern.hasMatch(local.trim());

  /// Formats a valid local number as `+965XXXXXXXX`.
  static String withCountryCode(String local) => '$countryCode${local.trim()}';
}
