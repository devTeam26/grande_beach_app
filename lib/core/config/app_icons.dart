import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Icons used across the app, sourced from the `lucide_icons` package
/// (brand logos from `font_awesome_flutter`).
abstract class AppIcons {
  static const IconData email = LucideIcons.mail;
  static const IconData lock = LucideIcons.lock;
  static const IconData eye = LucideIcons.eye;
  static const IconData eyeOff = LucideIcons.eyeOff;
  static const IconData google = FontAwesomeIcons.google;

  static const IconData home = LucideIcons.home;
  static const IconData discover = LucideIcons.compass;
  static const IconData booking = LucideIcons.receipt;
  static const IconData profile = LucideIcons.user;

  static const IconData masterRoom = LucideIcons.bedDouble;
  static const IconData singleRoom = LucideIcons.bedSingle;
  static const IconData guest = LucideIcons.users;
  static const IconData bathroom = LucideIcons.bath;
  static const IconData servantRoom = LucideIcons.conciergeBell;
}
