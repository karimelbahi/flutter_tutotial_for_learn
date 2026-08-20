import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/runtime_formatter.dart';
import '../cubit/movie_cast_cubit.dart';
import '../cubit/movie_cast_state.dart';
import '../cubit/movie_detail_cubit.dart';
import '../cubit/movie_detail_state.dart';
import '../cubit/similar_movies_cubit.dart';
import '../cubit/similar_movies_state.dart';
import '../movies_presentation_module.dart';
import '../navigation/movie_navigation.dart';
import '../widgets/carousel_item.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/settings_locale_sheet.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';
import '../../domain/entities/movie_detail.dart';

/// Full movie detail screen — spec 003-movie-detail.
///
/// Three cubits load detail, cast, and similar movies independently so one
/// section failing does not block the others (FR-008).
class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({
    super.key,
    required this.movieId,
  });

  final int movieId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => createMovieDetailCubit()..load(movieId),
        ),
        BlocProvider(
          create: (_) => createMovieCastCubit()..load(movieId),
        ),
        BlocProvider(
          create: (_) => createSimilarMoviesCubit()..load(movieId),
        ),
      ],
      child: _MovieDetailView(movieId: movieId),
    );
  }
}

class _MovieDetailView extends StatelessWidget {
  const _MovieDetailView({required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'detail.title'.tr(),
        showSearchButton: false,
        showLogoLeading: false,
        onSettingsPressed: () => showSettingsLocaleSheet(context),
      ),
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          return switch (state) {
            MovieDetailInitial() || MovieDetailLoading() => _loadingBody(context),
            MovieDetailSuccess(:final detail) => _detailBody(context, detail),
            MovieDetailFailure(:final message) => _errorBody(context, message),
          };
        },
      ),
    );
  }

  Widget _loadingBody(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _errorBody(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.detailOverview,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () => context.read<MovieDetailCubit>().load(movieId),
              child: Text('common.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailBody(BuildContext context, MovieDetail detail) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BackdropCarousel(backdropPaths: detail.backdropPaths),
          _TitleSection(detail: detail),
          const _DetailDivider(),
          _OverviewSection(detail: detail),
          const _DetailDivider(),
          _StatsSection(detail: detail),
          const _DetailDivider(),
          const _CastSection(),
          const _SimilarMoviesSection(),
        ],
      ),
    );
  }
}

class _BackdropCarousel extends StatelessWidget {
  const _BackdropCarousel({required this.backdropPaths});

  final List<String> backdropPaths;

  @override
  Widget build(BuildContext context) {
    if (backdropPaths.isEmpty) {
      return const SizedBox(
        height: AppSpacing.carouselHeight,
        child: CarouselItem(
          title: '',
          onTap: _noop,
        ),
      );
    }

    return SizedBox(
      height: AppSpacing.carouselHeight,
      child: CarouselSlider(
        items: backdropPaths
            .map(
              (path) => CarouselItem(
                title: '',
                backdropPath: path,
                onTap: _noop,
              ),
            )
            .toList(),
        options: CarouselOptions(
          autoPlay: backdropPaths.length > 1,
          viewportFraction: 1,
          enlargeCenterPage: false,
          height: AppSpacing.carouselHeight,
        ),
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection({required this.detail});

  final MovieDetail detail;

  static const _menuShare = 'share';
  static const _menuVisitWebsite = 'visit_website';

  Future<void> _onMenuSelected(BuildContext context, String value) async {
    if (value == _menuShare) {
      return;
    }

    final homepage = detail.homepage;
    if (homepage == null || homepage.isEmpty) {
      return;
    }

    final uri = Uri.tryParse(homepage);
    if (uri == null || !await canLaunchUrl(uri)) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final year = detail.releaseYear ?? 'common.tba'.tr();
    final runtime = formatRuntimeMinutes(detail.runtime);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  detail.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: AppTypography.detailTitle,
                ),
              ),
              PopupMenuButton<String>(
                color: AppColors.martinique,
                offset: const Offset(0, 40),
                icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
                tooltip: 'detail.more_options'.tr(),
                onSelected: (value) => _onMenuSelected(context, value),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _menuShare,
                    child: Text(
                      'detail.share'.tr(),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  PopupMenuItem(
                    value: _menuVisitWebsite,
                    child: Text(
                      'detail.visit_website'.tr(),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              text: '$year ',
              style: AppTypography.detailMeta,
              children: [
                const TextSpan(text: '• '),
                TextSpan(text: runtime),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({required this.detail});

  final MovieDetail detail;

  @override
  Widget build(BuildContext context) {
    final overview = detail.overview?.trim();
    final overviewText = overview == null || overview.isEmpty
        ? 'detail.overview_empty'.tr()
        : overview;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.moviePosterRadius),
            child: _PosterImage(posterPath: detail.posterPath),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: detail.genres.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final genre = detail.genres[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.divider),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.genreChipRadius),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.genreChipVertical,
                            horizontal: AppSpacing.genreChipHorizontal,
                          ),
                          child: Text(
                            genre.name,
                            style: AppTypography.movieCardTitle,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: Text(
                      overviewText,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.detailOverview,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterImage extends StatelessWidget {
  const _PosterImage({this.posterPath});

  final String? posterPath;

  @override
  Widget build(BuildContext context) {
    if (posterPath == null || posterPath!.isEmpty) {
      return const SizedBox(
        width: AppSpacing.moviePosterWidth,
        height: AppSpacing.moviePosterHeight,
        child: ColoredBox(
          color: AppColors.martinique,
          child: Icon(
            Icons.movie_outlined,
            size: 48,
            color: AppColors.placeholder,
          ),
        ),
      );
    }

    return Image.network(
      AppConfig.imageUrl(posterPath!),
      width: AppSpacing.moviePosterWidth,
      height: AppSpacing.moviePosterHeight,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const SizedBox(
        width: AppSpacing.moviePosterWidth,
        height: AppSpacing.moviePosterHeight,
        child: Icon(
          Icons.broken_image_outlined,
          color: AppColors.placeholder,
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.detail});

  final MovieDetail detail;

  String _formatRevenue() {
    if (detail.revenue < 1) {
      return 'detail.revenue_empty'.tr();
    }

    return NumberFormat.compactCurrency(
      locale: 'en',
      decimalDigits: 0,
      name: 'USD ',
    ).format(detail.revenue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              icon: Icons.star,
              iconColor: AppColors.rating,
              value: RichText(
                text: TextSpan(
                  text: detail.voteAverage.toStringAsFixed(1),
                  style: AppTypography.detailStatValue,
                  children: const [
                    TextSpan(
                      text: '/10',
                      style: AppTypography.detailMeta,
                    ),
                  ],
                ),
              ),
              label: 'detail.rating'.tr(),
            ),
          ),
          Expanded(
            child: _StatColumn(
              icon: Icons.attach_money,
              iconColor: AppColors.revenue,
              value: Text(
                _formatRevenue(),
                style: AppTypography.detailStatValue,
                textAlign: TextAlign.center,
              ),
              label: 'detail.revenue'.tr(),
            ),
          ),
          Expanded(
            child: _StatColumn(
              icon: Icons.local_movies_outlined,
              iconColor: AppColors.status,
              value: Text(
                detail.status,
                style: AppTypography.detailStatValue,
                textAlign: TextAlign.center,
              ),
              label: 'detail.status'.tr(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final Widget value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: value,
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Text(
            label,
            style: AppTypography.detailStatLabel,
          ),
        ),
      ],
    );
  }
}

class _CastSection extends StatelessWidget {
  const _CastSection();

  static const _maxCastCount = 15;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'detail.cast_title'.tr(),
          subtitle: 'detail.cast_subtitle'.tr(),
        ),
        BlocBuilder<MovieCastCubit, MovieCastState>(
          builder: (context, state) {
            return switch (state) {
              MovieCastInitial() || MovieCastLoading() => Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
                    ),
                  ),
                ),
              MovieCastFailure(:final message, :final movieId) => Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    children: [
                      Text(
                        message,
                        style: AppTypography.detailOverview,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextButton(
                        onPressed: () =>
                            context.read<MovieCastCubit>().load(movieId),
                        child: Text('common.retry'.tr()),
                      ),
                    ],
                  ),
                ),
              MovieCastSuccess(:final cast) when cast.isEmpty =>
                const SizedBox.shrink(),
              MovieCastSuccess(:final cast) => SizedBox(
                  height: AppSpacing.horizontalListHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(
                      left: AppSpacing.horizontalListPadding,
                    ),
                    itemCount: cast.length > _maxCastCount
                        ? _maxCastCount
                        : cast.length,
                    itemBuilder: (context, index) {
                      final member = cast[index];
                      return MovieCard(
                        title: member.name,
                        posterPath: member.profilePath,
                        subtitle: member.character,
                        onTap: () {},
                      );
                    },
                  ),
                ),
            };
          },
        ),
      ],
    );
  }
}

class _SimilarMoviesSection extends StatelessWidget {
  const _SimilarMoviesSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimilarMoviesCubit, SimilarMoviesState>(
      builder: (context, state) {
        return switch (state) {
          SimilarMoviesInitial() || SimilarMoviesLoading() => Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
                ),
              ),
            ),
          SimilarMoviesFailure(:final message, :final movieId) => Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                children: [
                  Text(
                    message,
                    style: AppTypography.detailOverview,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: () =>
                        context.read<SimilarMoviesCubit>().load(movieId),
                    child: Text('common.retry'.tr()),
                  ),
                ],
              ),
            ),
          SimilarMoviesSuccess(:final movies) when movies.isEmpty =>
            const SizedBox.shrink(),
          SimilarMoviesSuccess(:final movies) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'detail.similar_title'.tr(),
                  subtitle: 'detail.similar_subtitle'.tr(),
                ),
                SizedBox(
                  height: AppSpacing.horizontalListHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.horizontalListPadding,
                    ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return MovieCard(
                        title: movie.title,
                        posterPath: movie.posterPath,
                        rating: movie.voteAverage,
                        onTap: () => navigateToMovieDetail(context, movie.id),
                      );
                    },
                  ),
                ),
              ],
            ),
        };
      },
    );
  }
}

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.divider,
      thickness: 1,
      height: 1,
    );
  }
}

void _noop() {}
