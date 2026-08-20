import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Bottom sheet to switch app locale between English and Arabic.
void showSettingsLocaleSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.martinique,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
    ),
    builder: (context) => const _SettingsLocaleSheet(),
  );
}

class _SettingsLocaleSheet extends StatelessWidget {
  const _SettingsLocaleSheet();

  Future<void> _setLocale(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = context.locale;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'settings.title'.tr(),
              style: AppTypography.sectionTitle,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'settings.language'.tr(),
              style: AppTypography.detailMeta,
            ),
            const SizedBox(height: AppSpacing.lg),
            _LocaleTile(
              label: 'settings.language_en'.tr(),
              selected: current.languageCode == 'en',
              onTap: () => _setLocale(context, const Locale('en')),
            ),
            _LocaleTile(
              label: 'settings.language_ar'.tr(),
              selected: current.languageCode == 'ar',
              onTap: () => _setLocale(context, const Locale('ar')),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocaleTile extends StatelessWidget {
  const _LocaleTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: AppTypography.movieCardTitle),
      trailing: selected
          ? const Icon(Icons.check, color: AppColors.rating)
          : null,
      onTap: onTap,
    );
  }
}
