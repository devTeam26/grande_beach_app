/// Google account authentication. Its only job is to return a Google ID token
/// for the backend to verify — it never talks to the backend, stores tokens
/// or touches app auth state.
abstract class GoogleSignInService {
  /// Shows the native Google account picker and returns the selected
  /// account's ID token.
  ///
  /// Throws [GoogleAuthException] when the user cancels, authentication
  /// fails, or no ID token is returned.
  Future<String> getIdToken();

  /// Clears the cached Google account so the next sign-in shows the picker
  /// again. Safe to call when nobody is signed in.
  Future<void> signOut();
}
