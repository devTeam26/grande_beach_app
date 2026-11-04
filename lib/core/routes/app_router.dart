import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/controllers/auth_providers.dart';
import '../../features/authentication/screens/forgot_password_screen.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/register_screen.dart';
import '../../features/booking/screens/booking_details_screen.dart';
import '../../features/booking/screens/verification_screen.dart';
import '../../features/chalet_details/screens/chalet_details_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/profile/screens/account_info_screen.dart';
import '../../features/profile/screens/change_password_screen.dart';
import '../../features/profile/screens/privacy_policy_screen.dart';
import '../../features/reservation/screens/reservation_wizard_screen.dart';
import '../../features/reviews/screens/reviews_screen.dart';
import '../../features/shared/models/result_screen_args.dart';
import '../../features/shared/screens/main_shell.dart';
import '../../features/shared/screens/result_screen.dart';
import '../../features/wishlist/screens/wishlist_screen.dart';
import '../providers/onboarding_provider.dart';
import 'startup_screen.dart';

/// Bridges Riverpod state changes into a [Listenable] go_router can watch
/// to re-run its redirect logic.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(languageSelectedProvider, (_, _) => notifyListeners());
    ref.listen(onboardingProvider, (_, _) => notifyListeners());
    // sessionActiveProvider is synchronous — reacts instantly on logout so
    // protected routes are guarded again. Signing in deliberately does NOT
    // refresh the router: LoginScreen pops itself on success, and a refresh
    // scheduled at the same moment would re-parse the stale location (which
    // still contains /login) on the next frame and push Login back on top of
    // the reservation wizard. No redirect depends on a session starting.
    ref.listen(sessionActiveProvider, (previous, next) {
      if (previous == true && !next) notifyListeners();
    });
    // Re-run the redirect once the launch-time token refresh resolves.
    ref.listen(appBootstrapDoneProvider, (_, _) => notifyListeners());
  }
}

/// Paths that need an authenticated account. Everything else (Home,
/// Discover, chalet details, the reservation wizard, auth screens) is open to
/// guests; the final Reserve action is gated inside the wizard itself.
const _protectedPaths = {'/account-info', '/change-password'};
const _protectedPrefixes = {'/booking-details/', '/booking-verification/'};

bool _requiresSession(String path) =>
    _protectedPaths.contains(path) || _protectedPrefixes.any(path.startsWith);

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final languageSelected = ref.read(languageSelectedProvider);
      final onboardingDone = ref.read(onboardingProvider);
      final bootstrapDone = ref.read(appBootstrapDoneProvider);
      final hasSession = ref.read(sessionActiveProvider);
      final path = state.matchedLocation;

      if (!languageSelected) {
        return path == '/' ? null : '/';
      }
      if (!onboardingDone) {
        return path == '/onboarding' ? null : '/onboarding';
      }
      // Language + onboarding done: hold on the splash until the launch-time
      // token refresh has resolved, so we route to the correct destination.
      // An explicit request for /login (the onboarding "Login to your account"
      // button) is carried through the hold so it isn't lost.
      if (!bootstrapDone) {
        if (path == '/') return null;
        return path == '/login' ? '/?from=/login' : '/';
      }
      // Guests enter the app at /home too; login is only shown on request.
      if (path == '/' || path == '/onboarding') {
        if (hasSession) return '/home';
        return state.uri.queryParameters['from'] == '/login'
            ? '/login'
            : '/home';
      }
      // Auth screens are NOT bounced to /home on login here: LoginScreen
      // handles its own success navigation so that a login pushed over the
      // reservation wizard can pop straight back to it with state intact.
      if (!hasSession && _requiresSession(path)) {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const StartupScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainShell(),
      ),
      GoRoute(
        path: '/account-info',
        builder: (context, state) => const AccountInfoScreen(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: '/chalet-details/:id',
        builder: (context, state) => ChaletDetailsScreen(
          chaletId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/booking-details/:id',
        builder: (context, state) => BookingDetailsScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/booking-verification/:id',
        builder: (context, state) => VerificationScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/chalet-details/:id/reviews',
        builder: (context, state) => ReviewsScreen(
          chaletId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/chalet-details/:id/reserve',
        builder: (context, state) => ReservationWizardScreen(
          chaletId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) => ResultScreen(
          args: state.extra as ResultScreenArgs,
        ),
      ),
    ],
  );
});
