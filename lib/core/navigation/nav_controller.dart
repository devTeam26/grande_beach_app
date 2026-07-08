import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the currently active tab in the main application shell.
/// 0 = Home, 1 = Discover, 2 = Bookings, 3 = Profile.
class NavController extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) => state = index;

  void goHome() => state = 0;
}

final navControllerProvider =
    NotifierProvider<NavController, int>(NavController.new);
