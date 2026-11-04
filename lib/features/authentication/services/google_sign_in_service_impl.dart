import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/errors/failure.dart';
import 'google_auth_exception.dart';
import 'google_sign_in_service.dart';

/// [GoogleSignInService] backed by the official `google_sign_in` (v7) plugin.
///
/// [_serverClientId] (the Web OAuth client) is passed explicitly to
/// `initialize`, so Android never falls back to looking up a
/// google-services/`default_web_client_id` resource. The Android client is
/// matched by package name + signing SHA-1; the iOS client comes from
/// `GIDClientID` in `Info.plist`.
class GoogleSignInServiceImpl implements GoogleSignInService {
  GoogleSignInServiceImpl(this._googleSignIn, {required String serverClientId})
    : _serverClientId = serverClientId;

  final GoogleSignIn _googleSignIn;
  final String _serverClientId;

  /// `initialize` must run exactly once per app session.
  Future<void>? _initialization;

  Future<void> _ensureInitialized() {
    return _initialization ??= _googleSignIn
        .initialize(serverClientId: _serverClientId)
        .catchError((Object error) {
          // Allow a retry on the next attempt instead of caching the failure.
          _initialization = null;
          throw error;
        });
  }

  @override
  Future<String> getIdToken() async {
    try {
      await _ensureInitialized();

      if (!_googleSignIn.supportsAuthenticate()) {
        throw const GoogleAuthException(
          GoogleSignInFailureReason.unavailable,
          'authenticate() is not supported on this platform',
        );
      }

      final account = await _googleSignIn.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const GoogleAuthException(
          GoogleSignInFailureReason.failed,
          'Google returned no ID token',
        );
      }
      return idToken;
    } on GoogleAuthException {
      rethrow;
    } on GoogleSignInException catch (e) {
      throw GoogleAuthException(
        _mapReason(e.code),
        '${e.code.name}: ${e.description}',
      );
    } on PlatformException catch (e) {
      // Raised by the platform channel itself rather than the Google SDK —
      // typically `channel-error` when the native plugin isn't registered
      // (added without a full rebuild) or a native exception.
      throw GoogleAuthException(
        e.code == 'channel-error'
            ? GoogleSignInFailureReason.unavailable
            : GoogleSignInFailureReason.failed,
        'PlatformException(${e.code}): ${e.message}',
      );
    } catch (e) {
      throw GoogleAuthException(
        GoogleSignInFailureReason.failed,
        e.runtimeType.toString(),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _ensureInitialized();
      await _googleSignIn.signOut();
    } catch (_) {
      // Nothing to clear, or the plugin is unavailable — not actionable.
    }
  }

  GoogleSignInFailureReason _mapReason(GoogleSignInExceptionCode code) {
    return switch (code) {
      GoogleSignInExceptionCode.canceled => GoogleSignInFailureReason.cancelled,
      GoogleSignInExceptionCode.clientConfigurationError ||
      GoogleSignInExceptionCode.providerConfigurationError ||
      GoogleSignInExceptionCode.uiUnavailable =>
        GoogleSignInFailureReason.unavailable,
      GoogleSignInExceptionCode.interrupted ||
      GoogleSignInExceptionCode.userMismatch ||
      GoogleSignInExceptionCode.unknownError =>
        GoogleSignInFailureReason.failed,
    };
  }
}
