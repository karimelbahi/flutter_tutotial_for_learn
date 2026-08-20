import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Text style tokens from the reference app.
abstract final class AppTypography {
  static const TextStyle carouselTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle tabLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle sectionSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle movieCardTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle movieCardMeta = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  static const TextStyle detailTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
  );

  static const TextStyle detailMeta = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle detailOverview = TextStyle(
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle detailStatValue = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle detailStatLabel = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle searchField = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle searchFieldHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}
