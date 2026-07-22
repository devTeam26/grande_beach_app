import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../network/api_client.dart';
import '../network/connectivity_service.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/localization_interceptor.dart';
import '../network/interceptors/refresh_token_interceptor.dart';
import '../network/network_info.dart';
import '../services/whatsapp_service.dart';
import '../storage/local_storage_service.dart';
import '../storage/secure_storage_service.dart';
import 'locale_provider.dart';

/// Overridden in `main.dart` with the [Box] opened before [runApp].
final hiveBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError('hiveBoxProvider must be overridden in main.dart');
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService(ref.watch(hiveBoxProvider));
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.watch(connectivityProvider));
});

final internetConnectionCheckerProvider = Provider<InternetConnection>((ref) {
  return InternetConnection();
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityServiceImpl(
    ref.watch(connectivityProvider),
    ref.watch(internetConnectionCheckerProvider),
  );
});

final whatsAppServiceProvider = Provider<WhatsAppService>((ref) {
  return const WhatsAppService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return ApiClient(
    authInterceptor: AuthInterceptor(secureStorage),
    refreshTokenInterceptor: RefreshTokenInterceptor(secureStorage),
    localizationInterceptor: LocalizationInterceptor(
      () => ref.read(localeProvider).languageCode,
    ),
  );
});
