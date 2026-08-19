import 'package:flutter/material.dart';

import '../../../../core/constants/app_routes.dart';

/// Shared navigation helpers for the movies feature presentation layer.
void navigateToMovieDetail(BuildContext context, int movieId) {
  Navigator.pushNamed(
    context,
    AppRoutes.movieDetail,
    arguments: movieId,
  );
}
