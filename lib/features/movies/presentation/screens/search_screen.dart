import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/debouncer.dart';
import '../../domain/entities/movie.dart';
import '../cubit/search_movies_cubit.dart';
import '../cubit/search_movies_state.dart';
import '../movies_presentation_module.dart';
import '../navigation/movie_navigation.dart';
import '../widgets/list_tile_search.dart';
import '../widgets/search_form_field.dart';

/// TMDB movie search — debounced query, scrollable results, tap → detail.
///
/// Ported from reference `lib/screens/search.dart` with Clean Architecture cubit
/// and explicit empty/error states (spec 002).
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => createSearchMoviesCubit()..reset(),
      child: const _SearchScreenBody(),
    );
  }
}

class _SearchScreenBody extends StatefulWidget {
  const _SearchScreenBody();

  @override
  State<_SearchScreenBody> createState() => _SearchScreenBodyState();
}

class _SearchScreenBodyState extends State<_SearchScreenBody> {
  final TextEditingController _textFieldController = TextEditingController();
  final Debouncer _debouncer = Debouncer();

  @override
  void dispose() {
    _debouncer.dispose();
    _textFieldController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debouncer.run(() {
      context.read<SearchMoviesCubit>().search(query);
    });
  }

  void _onPressClear() {
    _debouncer.cancel();
    _textFieldController.clear();
    context.read<SearchMoviesCubit>().reset();
  }

  void _onPressMovie(int movieId) {
    navigateToMovieDetail(context, movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: SearchFormField(
          controller: _textFieldController,
          onChanged: _onQueryChanged,
          placeholder: 'search.hint'.tr(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onPressClear,
          ),
        ],
      ),
      body: BlocBuilder<SearchMoviesCubit, SearchMoviesState>(
        builder: (context, state) {
          return switch (state) {
            SearchMoviesInitial() => const SizedBox.shrink(),
            SearchMoviesLoading() => _loadingBody(),
            SearchMoviesSuccess(:final movies) => _resultsList(movies),
            SearchMoviesEmpty() => _emptyBody(),
            SearchMoviesFailure(:final message, :final query) =>
              _errorBody(context, message, query),
          };
        },
      ),
    );
  }

  Widget _loadingBody() {
    return Center(
      child: Transform.scale(
        scale: 1,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _resultsList(List<Movie> movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ListTileSearch(
          posterPath: movie.posterPath,
          title: movie.title,
          releaseDate: movie.releaseDate ?? 'common.tba'.tr(),
          onTap: () => _onPressMovie(movie.id),
        );
      },
    );
  }

  Widget _emptyBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Text(
          'search.empty'.tr(),
          textAlign: TextAlign.center,
          style: AppTypography.detailOverview,
        ),
      ),
    );
  }

  Widget _errorBody(BuildContext context, String message, String query) {
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
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () {
                context.read<SearchMoviesCubit>().search(query);
              },
              child: Text('common.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
