import 'package:flutter/material.dart';

/// Maps a backend amenity `icon` key to the matching Material icon.
abstract class AmenityIcons {
  static const Map<String, IconData> _icons = {
    'pool': Icons.pool,
    'beach': Icons.beach_access,
    'bbq': Icons.outdoor_grill,
    'flame': Icons.local_fire_department,
    'parking': Icons.local_parking,
    'car': Icons.directions_car,
    'wifi': Icons.wifi,
    'ac': Icons.ac_unit,
    'snowflake': Icons.ac_unit,
    'kitchen': Icons.kitchen,
    'chair': Icons.chair,
    'gamepad': Icons.sports_esports,
    'hot-tub': Icons.hot_tub,
    'tv': Icons.tv,
    'dumbbell': Icons.fitness_center,
    'concierge-bell': Icons.room_service,
    'spa': Icons.spa,
    'film': Icons.theaters,
  };

  static IconData resolve(String icon) =>
      _icons[icon] ?? Icons.check_circle_outline;
}
