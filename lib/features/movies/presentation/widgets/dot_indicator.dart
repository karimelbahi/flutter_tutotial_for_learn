import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import 'widget_preview_support.dart';

/// Page dots under the popular-movies carousel.
///
/// Ported from reference `lib/widgets/dot_indicator.dart`.
/// Reference capped at 5 dots — we keep the same rule via [maxDots].
class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.maxDots = 5,
  });

  /// Total carousel items (only first [maxDots] get a dot).
  final int itemCount;

  /// Active slide index (0-based).
  final int currentIndex;

  final int maxDots;

  @override
  Widget build(BuildContext context) {
    final dotCount = itemCount < maxDots ? itemCount : maxDots;

    return Positioned(
      bottom: AppSpacing.sm,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(dotCount, (index) {
          final isActive = currentIndex == index;
          return Container(
            width: AppSpacing.dotSize,
            height: AppSpacing.dotSize,
            margin: const EdgeInsets.symmetric(
              vertical: AppSpacing.dotMarginVertical,
              horizontal: AppSpacing.dotMarginHorizontal,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? AppColors.carouselDotActive
                  : AppColors.carouselDotInactive,
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// @Preview — run: flutter widget-preview start
// DotIndicator uses [Positioned] — preview hosts it inside a [Stack].
// ---------------------------------------------------------------------------

@Preview(
  name: 'First dot active',
  group: 'DotIndicator',
  size: Size(400, AppSpacing.carouselHeight),
  wrapper: moviesDarkScaffoldWrapper,
)
Widget dotIndicatorFirstActivePreview() {
  return SizedBox(
    width: 400,
    height: AppSpacing.carouselHeight,
    child: Stack(
      children: [
        const ColoredBox(color: AppColors.martinique),
        const DotIndicator(itemCount: 5, currentIndex: 0),
      ],
    ),
  );
}

@Preview(
  name: 'Third dot active',
  group: 'DotIndicator',
  size: Size(400, AppSpacing.carouselHeight),
  wrapper: moviesDarkScaffoldWrapper,
)
Widget dotIndicatorThirdActivePreview() {
  return SizedBox(
    width: 400,
    height: AppSpacing.carouselHeight,
    child: Stack(
      children: [
        const ColoredBox(color: AppColors.martinique),
        const DotIndicator(itemCount: 5, currentIndex: 2),
      ],
    ),
  );
}
