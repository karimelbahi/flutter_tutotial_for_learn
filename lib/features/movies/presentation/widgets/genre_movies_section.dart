import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../cubit/genre_movies_cubit.dart';
import '../cubit/genre_movies_state.dart';
import 'movie_card.dart';

/// Genre TabBar + horizontal movie row (Step 5).
class GenreMoviesSection extends StatefulWidget {
  const GenreMoviesSection({super.key});

  @override
  State<GenreMoviesSection> createState() => _GenreMoviesSectionState();
}

class _GenreMoviesSectionState extends State<GenreMoviesSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: kMovieGenres.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onGenreTabSelected(int index) {
    final genre = kMovieGenres[index];
    context.read<GenreMoviesCubit>().load(genre.id);
  }

  void _onMovieTap(Movie movie) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${movie.title} (${movie.id})')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          onTap: _onGenreTabSelected,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: const EdgeInsets.only(
            left: AppSpacing.horizontalListPadding,
          ),
          labelPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          tabs: kMovieGenres
              .map(
                (genre) => Tab(text: genre.name.toUpperCase()),
              )
              .toList(),
        ),
        BlocBuilder<GenreMoviesCubit, GenreMoviesState>(
          buildWhen: (previous, current) {
            // Rebuild when the visible tab's genre data changes.
            final selectedGenreId = kMovieGenres[_tabController.index].id;
            return current.genreId == selectedGenreId ||
                previous.genreId == selectedGenreId;
          },
          builder: (context, state) {
            final selectedGenreId = kMovieGenres[_tabController.index].id;

            if (state.genreId != selectedGenreId) {
              return _loadingRow();
            }

            return switch (state) {
              GenreMoviesInitial() => _loadingRow(),
              GenreMoviesLoading() => _loadingRow(showIndicator: true),
              GenreMoviesSuccess(:final movies) => _movieRow(movies),
              GenreMoviesFailure(:final message) =>
                _errorRow(context, message, selectedGenreId),
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

  Widget _movieRow(List<Movie> movies) {
    if (movies.isEmpty) {
      return SizedBox(
        height: AppSpacing.horizontalListHeight,
        child: Center(
          child: Text(
            'home.genre_empty'.tr(),
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
            onTap: () => _onMovieTap(movie),
          );
        },
      ),
    );
  }

  Widget _errorRow(BuildContext context, String message, int genreId) {
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
                context.read<GenreMoviesCubit>().load(genreId);
              },
              child: Text('common.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
