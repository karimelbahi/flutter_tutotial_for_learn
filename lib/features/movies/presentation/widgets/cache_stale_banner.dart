import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Non-blocking banner shown when Cubit success state has `isStale: true`.
///
/// **When does `isStale` become true?**
/// Network refresh failed, but cached Hive data is still on screen (spec 005).
/// The user keeps browsing offline instead of seeing a blank error screen.
///
/// This widget reads only UI flags — it never touches Hive or the repository.
class CacheStaleBanner extends StatelessWidget {
  const CacheStaleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.martinique,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 18,
              color: AppColors.amethystSmoke,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'cache.offline'.tr(),
                style: AppTypography.detailOverview.copyWith(
                  color: AppColors.amethystSmoke,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
