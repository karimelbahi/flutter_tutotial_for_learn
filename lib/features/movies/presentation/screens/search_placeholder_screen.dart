import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Placeholder until spec 002-movie-search is implemented.
///
/// Step 3 only proves navigation from the home app bar search icon.
class SearchPlaceholderScreen extends StatelessWidget {
  const SearchPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search.title'.tr()),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Text(
            'search.placeholder'.tr(),
            textAlign: TextAlign.center,
            style: AppTypography.detailOverview,
          ),
        ),
      ),
    );
  }
}
