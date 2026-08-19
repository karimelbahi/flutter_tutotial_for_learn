import 'package:flutter/material.dart';

import '../../features/movies/presentation/screens/movie_home_screen.dart';
import '../../features/movies/presentation/screens/search_placeholder_screen.dart';
import '../../features/movies/presentation/screens/widget_preview_screen.dart';
import '../core/constants/app_routes.dart';

/// Central route table — keeps navigation names in one place.
abstract final class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const MovieHomeScreen(),
        );
      case AppRoutes.search:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SearchPlaceholderScreen(),
        );
      case AppRoutes.widgetPreview:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const WidgetPreviewScreen(),
        );
      default:
        return null;
    }
  }
}
