import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_routes.dart';
import '../movies_presentation_module.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/popular_movies_carousel_section.dart';

/// Home screen — app bar + popular carousel (Step 4).
///
/// Genre tabs and horizontal rows arrive in Steps 5–7.
class MovieHomeScreen extends StatelessWidget {
  const MovieHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => createPopularMoviesCubit()..load(),
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
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PopularMoviesCarouselSection(),
          ],
        ),
      ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton.small(
              tooltip: 'Widget gallery (Step 2)',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.widgetPreview);
              },
              child: const Icon(Icons.widgets_outlined),
            )
          : null,
    );
  }
}
