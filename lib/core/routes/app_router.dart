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
    // sessionActiveProvider is synchronous — reacts instantly on login/logout.
    ref.listen(sessionActiveProvider, (_, _) => notifyListeners());
    // Re-run the redirect once the launch-time token refresh resolves.
    ref.listen(appBootstrapDoneProvider, (_, _) => notifyListeners());
  }
}

/// Auth-gated paths that should redirect to /home when a session is active.
const _authPaths = {'/login', '/register', '/forgot-password'};

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
      if (!bootstrapDone) {
        return path == '/' ? null : '/';
      }
      if (path == '/' || path == '/onboarding') {
        return hasSession ? '/home' : '/login';
      }
      // After login succeeds, bounce auth screens to /home.
      if (_authPaths.contains(path) && hasSession) {
        return '/home';
      }
      // Guard /home and any sub-paths from unauthenticated access.
      if (!hasSession && !_authPaths.contains(path) && path != '/') {
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
