import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Placeholder until spec 003-movie-detail is implemented (Step 8).
class MovieDetailPlaceholderScreen extends StatelessWidget {
  const MovieDetailPlaceholderScreen({
    super.key,
    required this.movieId,
  });

  final int movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('detail.title'.tr()),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'detail.placeholder'.tr(),
                textAlign: TextAlign.center,
                style: AppTypography.detailOverview,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'detail.movie_id'.tr(args: [movieId.toString()]),
                style: AppTypography.detailTitle.copyWith(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
