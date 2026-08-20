import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/genre_movies_cubit.dart';
import '../cubit/genre_movies_state.dart';
import '../cubit/popular_movies_cubit.dart';
import '../cubit/popular_movies_state.dart';
import '../cubit/top_rated_movies_cubit.dart';
import '../cubit/top_rated_movies_state.dart';
import '../cubit/upcoming_movies_cubit.dart';
import '../cubit/upcoming_movies_state.dart';
import 'cache_stale_banner.dart';

/// Shows one banner for the whole home feed when **any** section is stale.
///
/// Uses [context.select] so we rebuild only when a cubit's stale flag changes,
/// not on every unrelated state emission.
class HomeCacheStaleBanner extends StatelessWidget {
  const HomeCacheStaleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final popularStale = context.select<PopularMoviesCubit, bool>(
      (cubit) => _isStale(cubit.state),
    );
    final genreStale = context.select<GenreMoviesCubit, bool>(
      (cubit) => _isGenreStale(cubit.state),
    );
    final topRatedStale = context.select<TopRatedMoviesCubit, bool>(
      (cubit) => _isTopRatedStale(cubit.state),
    );
    final upcomingStale = context.select<UpcomingMoviesCubit, bool>(
      (cubit) => _isUpcomingStale(cubit.state),
    );

    final showBanner =
        popularStale || genreStale || topRatedStale || upcomingStale;

    if (!showBanner) {
      return const SizedBox.shrink();
    }

    return const CacheStaleBanner();
  }

  static bool _isStale(PopularMoviesState state) {
    return state is PopularMoviesSuccess && state.isStale;
  }

  static bool _isGenreStale(GenreMoviesState state) {
    return state is GenreMoviesSuccess && state.isStale;
  }

  static bool _isTopRatedStale(TopRatedMoviesState state) {
    return state is TopRatedMoviesSuccess && state.isStale;
  }

  static bool _isUpcomingStale(UpcomingMoviesState state) {
    return state is UpcomingMoviesSuccess && state.isStale;
  }
}
