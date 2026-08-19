import 'package:flutter/material.dart';

/// Design tokens matched to the reference TMDB movie app.
abstract final class AppColors {
  static const Color primary = Color(0xFF1D1D27);
  static const Color amethystSmoke = Color(0xFF9E9EBC);
  static const Color mandy = Color(0xFFE15050);
  static const Color martinique = Color(0xFF2D2D33);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color divider = Colors.white12;
  static const Color placeholder = Colors.white24;

  static const Color rating = Colors.amber;
  static const Color revenue = Colors.green;
  static const Color status = Colors.redAccent;

  static const Color carouselDotActive = Colors.white;
  static const Color carouselDotInactive = Color.fromRGBO(255, 255, 255, 0.4);

  static const Color inkSplash = Color.fromRGBO(0, 0, 0, 0.3);
  static const Color inkHighlight = Color.fromRGBO(0, 0, 0, 0.1);
}
