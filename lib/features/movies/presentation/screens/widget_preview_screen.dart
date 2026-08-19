import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/entities/movie.dart';
import '../widgets/carousel_item.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/dot_indicator.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';

/// Emulator preview gallery for Step 2 widgets.
///
/// Shown when running `flutter run` in debug mode so you can scroll and
/// interact with every widget on a device. In-file `@Preview` annotations
/// remain for `flutter widget-preview start` in the browser.
///
/// Replaced by the real home screen in Step 3.
class WidgetPreviewScreen extends StatefulWidget {
  const WidgetPreviewScreen({super.key});

  @override
  State<WidgetPreviewScreen> createState() => _WidgetPreviewScreenState();
}

class _WidgetPreviewScreenState extends State<WidgetPreviewScreen> {
  int _carouselIndex = 0;

  static const _carouselMovies = [
    Movie(
      id: 550,
      title: 'Fight Club',
      voteAverage: 8.4,
      backdropPath: '/52AvNEoZCW79VU8d7COaI1c2h86.jpg',
      posterPath: '/pB8BM7pdSp6B6Ih7QZ4SkQttFA0.jpg',
      releaseDate: '1999-10-15',
    ),
    Movie(
      id: 278,
      title: 'The Shawshank Redemption',
      voteAverage: 8.7,
      backdropPath: '/iNh3B5HtxGfGK1R6B0a1wLm0Q2o.jpg',
      posterPath: '/9cqN99sKZm5ZSNp7gtD2lH8WKi.jpg',
      releaseDate: '1994-09-23',
    ),
    Movie(
      id: 238,
      title: 'The Godfather',
      voteAverage: 8.7,
      backdropPath: '/tmU7GeKVybMIF8WPlyjomcmORn.jpg',
      posterPath: '/3bhkrj58dta7.jpg',
      releaseDate: '1972-03-14',
    ),
  ];

  static const _rowMovies = [
    Movie(
      id: 155,
      title: 'The Dark Knight',
      voteAverage: 8.5,
      posterPath: '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
      releaseDate: '2008-07-18',
    ),
    Movie(
      id: 27205,
      title: 'Inception',
      voteAverage: 8.4,
      posterPath: '/9o9kRwe0IzzC8Qp8WAW8b8MrhTh.jpg',
      releaseDate: '2010-07-16',
    ),
    Movie(
      id: 0,
      title: 'No Poster (placeholder)',
      voteAverage: 0,
      releaseDate: '2026-01-01',
    ),
  ];

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Movie DB',
        onSearchPressed: () => _showSnack('Search — wired in Step 3'),
        onSettingsPressed: () => _showSnack('Settings — coming later'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            child: Text(
              'Step 2 widget preview (debug)',
              style: AppTypography.sectionSubtitle,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: AppSpacing.carouselHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  itemCount: _carouselMovies.length,
                  onPageChanged: (index) {
                    setState(() => _carouselIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final movie = _carouselMovies[index];
                    return CarouselItem(
                      title: movie.title,
                      backdropPath: movie.backdropPath,
                      onTap: () => _showSnack('Tapped: ${movie.title}'),
                    );
                  },
                ),
                DotIndicator(
                  itemCount: _carouselMovies.length,
                  currentIndex: _carouselIndex,
                ),
              ],
            ),
          ),
          const SectionHeader(
            title: 'Top Rated',
            subtitle: 'Highest scores',
          ),
          SizedBox(
            height: AppSpacing.horizontalListHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalListPadding,
              ),
              itemCount: _rowMovies.length,
              itemBuilder: (context, index) {
                final movie = _rowMovies[index];
                return MovieCard(
                  title: movie.title,
                  posterPath: movie.posterPath,
                  rating: movie.posterPath != null ? movie.voteAverage : null,
                  subtitle: movie.releaseYear,
                  onTap: () => _showSnack('Tapped: ${movie.title}'),
                );
              },
            ),
          ),
          const SectionHeader(
            title: 'Upcoming',
            subtitle: 'Release dates',
          ),
          SizedBox(
            height: AppSpacing.horizontalListHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalListPadding,
              ),
              itemCount: _rowMovies.length,
              itemBuilder: (context, index) {
                final movie = _rowMovies[index];
                return MovieCard(
                  title: movie.title,
                  posterPath: movie.posterPath,
                  subtitle: movie.releaseYear ?? 'TBA',
                  onTap: () => _showSnack('Tapped: ${movie.title}'),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
