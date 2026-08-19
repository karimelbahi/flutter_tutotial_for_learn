import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/entities/movie.dart';
import '../cubit/top_rated_movies_cubit.dart';
import '../cubit/top_rated_movies_state.dart';
import '../navigation/movie_navigation.dart';
import 'movie_card.dart';
import 'section_header.dart';

/// Top-rated movies row with section header (Step 6).
class TopRatedMoviesSection extends StatelessWidget {
  const TopRatedMoviesSection({super.key});

  void _onMovieTap(BuildContext context, Movie movie) {
    navigateToMovieDetail(context, movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'home.top_rated_title'.tr(),
          subtitle: 'home.top_rated_subtitle'.tr(),
        ),
        BlocBuilder<TopRatedMoviesCubit, TopRatedMoviesState>(
          builder: (context, state) {
            return switch (state) {
              TopRatedMoviesInitial() => _loadingRow(),
              TopRatedMoviesLoading() => _loadingRow(showIndicator: true),
              TopRatedMoviesSuccess(:final movies) => _movieRow(
                  context,
                  movies,
                ),
              TopRatedMoviesFailure(:final message) =>
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
            'home.top_rated_empty'.tr(),
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
            rating: movie.voteAverage,
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
                context.read<TopRatedMoviesCubit>().load();
              },
              child: Text('common.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
