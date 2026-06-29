import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/controllers/auth_providers.dart';
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../providers/onboarding_provider.dart';
import 'startup_screen.dart';

/// Bridges Riverpod state changes into a [Listenable] go_router can watch
/// to re-run its redirect logic.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(languageSelectedProvider, (_, _) => notifyListeners());
    ref.listen(onboardingProvider, (_, _) => notifyListeners());
    ref.listen(hasActiveSessionProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final languageSelected = ref.read(languageSelectedProvider);
      final onboardingDone = ref.read(onboardingProvider);
      final hasSession = ref.read(hasActiveSessionProvider).valueOrNull ?? false;
      final path = state.matchedLocation;

      if (!languageSelected) {
        return path == '/' ? null : '/';
      }
      if (!onboardingDone) {
        return path == '/onboarding' ? null : '/onboarding';
      }
      if (path == '/' || path == '/onboarding') {
        return hasSession ? '/home' : '/login';
      }
      if (path == '/home' && !hasSession) {
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
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
