import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Network transport currently reported by the OS, independent of whether
/// it actually has internet access.
enum ConnectionType { wifi, mobile, ethernet, other, none }

/// Reactive, real-world connectivity state: the transport in use and
/// whether it can actually reach the internet. A device can be joined to
/// Wi-Fi (or mobile data) with no upstream access, so [isOnline] is only
/// ever true once a real internet probe has succeeded.
class ConnectivityState {
  const ConnectivityState({required this.type, required this.isOnline});

  final ConnectionType type;
  final bool isOnline;

  @override
  bool operator ==(Object other) =>
      other is ConnectivityState &&
      other.type == type &&
      other.isOnline == isOnline;

  @override
  int get hashCode => Object.hash(type, isOnline);
}

/// Abstraction over device connectivity + real internet reachability so
/// features never depend on `connectivity_plus`/
/// `internet_connection_checker_plus` directly.
abstract class ConnectivityService {
  /// Emits every time the transport or real internet reachability changes.
  Stream<ConnectivityState> get onStateChange;

  /// Runs an immediate, one-off check (used for manual retry).
  Future<ConnectivityState> checkNow();
}

class ConnectivityServiceImpl implements ConnectivityService {
  ConnectivityServiceImpl(this._connectivity, this._internetChecker);

  final Connectivity _connectivity;
  final InternetConnection _internetChecker;

  @override
  Stream<ConnectivityState> get onStateChange =>
      _connectivity.onConnectivityChanged.asyncMap(_resolve).distinct();

  @override
  Future<ConnectivityState> checkNow() async {
    final results = await _connectivity.checkConnectivity();
    return _resolve(results);
  }

  Future<ConnectivityState> _resolve(List<ConnectivityResult> results) async {
    final type = _mapType(results);
    if (type == ConnectionType.none) {
      return const ConnectivityState(
        type: ConnectionType.none,
        isOnline: false,
      );
    }
    final hasInternet = await _internetChecker.hasInternetAccess;
    return ConnectivityState(type: type, isOnline: hasInternet);
  }

  ConnectionType _mapType(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) return ConnectionType.wifi;
    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectionType.mobile;
    }
    if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectionType.ethernet;
    }
    if (results.any((r) => r != ConnectivityResult.none)) {
      return ConnectionType.other;
    }
    return ConnectionType.none;
  }
}
