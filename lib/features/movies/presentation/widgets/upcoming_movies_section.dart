import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/entities/movie.dart';
import '../cubit/upcoming_movies_cubit.dart';
import '../cubit/upcoming_movies_state.dart';
import '../navigation/movie_navigation.dart';
import 'movie_card.dart';
import 'section_header.dart';

/// Upcoming movies row with release year subtitles (Step 7).
class UpcomingMoviesSection extends StatelessWidget {
  const UpcomingMoviesSection({super.key});

  void _onMovieTap(BuildContext context, Movie movie) {
    navigateToMovieDetail(context, movie.id);
  }

  String _releaseLabel(Movie movie) {
    return movie.releaseYear ?? 'common.tba'.tr();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'home.upcoming_title'.tr(),
          subtitle: 'home.upcoming_subtitle'.tr(),
        ),
        BlocBuilder<UpcomingMoviesCubit, UpcomingMoviesState>(
          builder: (context, state) {
            return switch (state) {
              UpcomingMoviesInitial() => _loadingRow(),
              UpcomingMoviesLoading() => _loadingRow(showIndicator: true),
              UpcomingMoviesSuccess(:final movies) => _movieRow(
                  context,
                  movies,
                ),
              UpcomingMoviesFailure(:final message) =>
                _errorRow(context, message),
            };
          },
        ),
      ],
    );
  }

  Widget _loadingRow({bool showIndicator = false}) {
    return SizedBox(
      height: AppSpacing.horizontalListHeight,
      child: Center(
        child: showIndicator
            ? Transform.scale(
                scale: 0.7,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.textPrimary,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _movieRow(BuildContext context, List<Movie> movies) {
    if (movies.isEmpty) {
      return SizedBox(
        height: AppSpacing.horizontalListHeight,
        child: Center(
          child: Text(
            'home.upcoming_empty'.tr(),
            style: AppTypography.detailOverview,
          ),
        ),
      );
    }

    return SizedBox(
      height: AppSpacing.horizontalListHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
          left: AppSpacing.horizontalListPadding,
          right: AppSpacing.horizontalListPadding,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCard(
            title: movie.title,
            posterPath: movie.posterPath,
            subtitle: _releaseLabel(movie),
            onTap: () => _onMovieTap(context, movie),
          );
        },
      ),
    );
  }

  Widget _errorRow(BuildContext context, String message) {
    return SizedBox(
      height: AppSpacing.horizontalListHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.detailOverview,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () {
                context.read<UpcomingMoviesCubit>().load();
              },
              child: Text('common.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
