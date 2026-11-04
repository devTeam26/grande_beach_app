/// Google Cloud OAuth configuration for Google Sign-In (no Firebase).
///
/// OAuth client IDs are public identifiers, not secrets.
abstract class GoogleAuthConfig {
  /// "Web application" OAuth client — the backend's client. Passed as
  /// `serverClientId` so Google issues ID tokens whose audience is the
  /// backend, which verifies them on `/api/Auth/google-login`.
  ///
  /// The Android OAuth client is never referenced in code: Google matches it
  /// by package name (`com.user.grande_beach`) + signing SHA-1. The iOS
  /// client ID lives in `ios/Runner/Info.plist` (`GIDClientID`) alongside its
  /// URL scheme.
  static const String serverClientId =
      '127012976506-oqebthltsu2a3rl2n90o5086lr0flkf0.apps.googleusercontent.com';
}
