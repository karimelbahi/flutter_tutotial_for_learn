import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import 'widget_preview_support.dart';

/// Row header for home sections such as "Top Rated" and "Upcoming".
///
/// Ported from reference `lib/widgets/section_header.dart`.
/// Both [title] and [subtitle] are uppercased to match the reference look.
/// The screen passes localized strings (`.tr()` once easy_localization is wired).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sectionHeaderPaddingLeft,
        AppSpacing.sectionHeaderPaddingTop,
        AppSpacing.sectionHeaderPaddingRight,
        AppSpacing.sectionHeaderPaddingBottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTypography.sectionTitle,
          ),
          Text(
            subtitle.toUpperCase(),
            style: AppTypography.sectionSubtitle,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// @Preview — like Jetpack Compose previews in the same file (Flutter 3.35+)
// Run: flutter widget-preview start
// ---------------------------------------------------------------------------

@Preview(
  name: 'Top Rated section',
  group: 'SectionHeader',
  wrapper: moviesFullWidthWrapper,
)
Widget sectionHeaderTopRatedPreview() {
  return const SectionHeader(
    title: 'Top Rated',
    subtitle: 'Highest scores',
  );
}

@Preview(
  name: 'Upcoming section',
  group: 'SectionHeader',
  wrapper: moviesFullWidthWrapper,
)
Widget sectionHeaderUpcomingPreview() {
  return const SectionHeader(
    title: 'Upcoming',
    subtitle: 'Release dates',
  );
}
