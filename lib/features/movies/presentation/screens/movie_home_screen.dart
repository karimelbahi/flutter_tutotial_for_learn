import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_routes.dart';
import '../movies_presentation_module.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/genre_movies_section.dart';
import '../widgets/popular_movies_carousel_section.dart';
import '../widgets/settings_locale_sheet.dart';
import '../widgets/top_rated_movies_section.dart';
import '../widgets/upcoming_movies_section.dart';

/// Home screen — full feed: carousel → genres → top rated → upcoming.
class MovieHomeScreen extends StatelessWidget {
  const MovieHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => createPopularMoviesCubit()..load(),
        ),
        BlocProvider(
          create: (_) => createGenreMoviesCubit(),
        ),
        BlocProvider(
          create: (_) => createTopRatedMoviesCubit()..load(),
        ),
        BlocProvider(
          create: (_) => createUpcomingMoviesCubit()..load(),
        ),
      ],
      child: const _MovieHomeView(),
    );
  }
}

class _MovieHomeView extends StatelessWidget {
  const _MovieHomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'home.title'.tr(),
        onSearchPressed: () {
          Navigator.pushNamed(context, AppRoutes.search);
        },
        onSettingsPressed: () => showSettingsLocaleSheet(context),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PopularMoviesCarouselSection(),
            GenreMoviesSection(),
            TopRatedMoviesSection(),
            UpcomingMoviesSection(),
          ],
        ),
      ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton.small(
              tooltip: 'dev.widget_gallery_tooltip'.tr(),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.widgetPreview);
              },
              child: const Icon(Icons.widgets_outlined),
            )
          : null,
    );
  }
}
