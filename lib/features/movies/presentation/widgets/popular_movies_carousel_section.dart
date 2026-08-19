import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/entities/movie.dart';
import '../cubit/popular_movies_cubit.dart';
import '../cubit/popular_movies_state.dart';
import '../navigation/movie_navigation.dart';
import 'carousel_item.dart';
import 'dot_indicator.dart';

/// Popular movies banner — carousel + dot indicators (Step 4).
///
/// Reference caps the carousel at 5 slides; we match that behavior.
class PopularMoviesCarouselSection extends StatefulWidget {
  const PopularMoviesCarouselSection({super.key});

  @override
  State<PopularMoviesCarouselSection> createState() =>
      _PopularMoviesCarouselSectionState();
}

class _PopularMoviesCarouselSectionState
    extends State<PopularMoviesCarouselSection> {
  int _currentIndex = 0;

  static const _maxSlides = 5;

  void _onMovieTap(Movie movie) {
    navigateToMovieDetail(context, movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularMoviesCubit, PopularMoviesState>(
      builder: (context, state) {
        return switch (state) {
          PopularMoviesInitial() => _loadingPlaceholder(),
          PopularMoviesLoading() => _loadingPlaceholder(showIndicator: true),
          PopularMoviesSuccess(:final movies) => _buildCarousel(movies),
          PopularMoviesFailure(:final message) => _buildError(context, message),
        };
      },
    );
  }

  Widget _loadingPlaceholder({bool showIndicator = false}) {
    return SizedBox(
      height: AppSpacing.carouselHeight,
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

  Widget _buildCarousel(List<Movie> movies) {
    if (movies.isEmpty) {
      return SizedBox(
        height: AppSpacing.carouselHeight,
        child: Center(
          child: Text(
            'home.carousel_empty'.tr(),
            style: AppTypography.detailOverview,
          ),
        ),
      );
    }

    final slides = movies.take(_maxSlides).toList();

    return SizedBox(
      height: AppSpacing.carouselHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CarouselSlider(
            items: slides
                .map(
                  (movie) => CarouselItem(
                    title: movie.title,
                    backdropPath: movie.backdropPath,
                    onTap: () => _onMovieTap(movie),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1,
              enlargeCenterPage: false,
              height: AppSpacing.carouselHeight,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
          DotIndicator(
            itemCount: slides.length,
            currentIndex: _currentIndex,
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return SizedBox(
      height: AppSpacing.carouselHeight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.detailOverview,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () {
                  context.read<PopularMoviesCubit>().load();
                },
                child: Text('common.retry'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
