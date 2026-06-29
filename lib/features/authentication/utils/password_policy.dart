import '../../../core/localization/generated/app_localizations.dart';

/// A single password rule shown in the requirements checklist and enforced
/// by [PasswordPolicy.isValid].
class PasswordRequirement {
  const PasswordRequirement({required this.isSatisfied, required this.label});

  final bool Function(String password) isSatisfied;
  final String Function(AppLocalizations l10n) label;
}

/// Single source of truth for the registration password policy, shared by
/// the live requirements checklist UI and [RegisterController]'s validation
/// so the two can never drift apart.
abstract class PasswordPolicy {
  static const List<PasswordRequirement> requirements = [
    PasswordRequirement(
      isSatisfied: _hasMinLength,
      label: _minLengthLabel,
    ),
    PasswordRequirement(
      isSatisfied: _hasUppercase,
      label: _uppercaseLabel,
    ),
    PasswordRequirement(
      isSatisfied: _hasLowercase,
      label: _lowercaseLabel,
    ),
    PasswordRequirement(
      isSatisfied: _hasNumber,
      label: _numberLabel,
    ),
    PasswordRequirement(
      isSatisfied: _hasSpecialChar,
      label: _specialCharLabel,
    ),
  ];

  static bool isValid(String password) =>
      requirements.every((requirement) => requirement.isSatisfied(password));

  static bool _hasMinLength(String password) => password.length >= 8;

  static bool _hasUppercase(String password) =>
      RegExp(r'[A-Z]').hasMatch(password);

  static bool _hasLowercase(String password) =>
      RegExp(r'[a-z]').hasMatch(password);

  static bool _hasNumber(String password) =>
      RegExp(r'[0-9]').hasMatch(password);

  static bool _hasSpecialChar(String password) =>
      RegExp(r'''[!@#$%^&*(),.?":{}|<>_\-+=\[\];'`~\\/]''').hasMatch(password);

  static String _minLengthLabel(AppLocalizations l10n) =>
      l10n.passwordReqMinLength;

  static String _uppercaseLabel(AppLocalizations l10n) =>
      l10n.passwordReqUppercase;

  static String _lowercaseLabel(AppLocalizations l10n) =>
      l10n.passwordReqLowercase;

  static String _numberLabel(AppLocalizations l10n) => l10n.passwordReqNumber;

  static String _specialCharLabel(AppLocalizations l10n) =>
      l10n.passwordReqSpecialChar;
}
