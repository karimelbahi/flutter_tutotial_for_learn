import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import 'widget_preview_support.dart';

/// Single slide in the home popular-movies carousel.
///
/// Ported from reference `lib/widgets/carousel_item.dart`.
/// Uses a gradient [ShaderMask] so the backdrop fades at the top (cinematic look).
class CarouselItem extends StatelessWidget {
  const CarouselItem({
    super.key,
    required this.title,
    required this.onTap,
    this.backdropPath,
  });

  final String title;
  final String? backdropPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.transparent],
            ).createShader(
              Rect.fromLTRB(0, 0, rect.width, rect.height),
            );
          },
          blendMode: BlendMode.dstIn,
          child: _BackdropImage(backdropPath: backdropPath),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: AppColors.inkSplash,
              highlightColor: AppColors.inkHighlight,
              onTap: onTap,
            ),
          ),
        ),
        Positioned(
          bottom: AppSpacing.xxl,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.carouselTitle,
          ),
        ),
      ],
    );
  }
}

class _BackdropImage extends StatelessWidget {
  const _BackdropImage({this.backdropPath});

  final String? backdropPath;

  @override
  Widget build(BuildContext context) {
    if (backdropPath == null || backdropPath!.isEmpty) {
      return const ColoredBox(
        color: AppColors.martinique,
        child: Center(
          child: Icon(
            Icons.movie_outlined,
            size: 64,
            color: AppColors.placeholder,
          ),
        ),
      );
    }

    return Image.network(
      AppConfig.imageUrl(backdropPath!),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => const ColoredBox(
        color: AppColors.martinique,
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: AppColors.placeholder,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// @Preview — run: flutter widget-preview start
// ---------------------------------------------------------------------------

@Preview(
  name: 'Placeholder backdrop',
  group: 'CarouselItem',
  size: Size(400, AppSpacing.carouselHeight),
  wrapper: moviesDarkScaffoldWrapper,
)
Widget carouselItemPlaceholderPreview() {
  return SizedBox(
    width: 400,
    height: AppSpacing.carouselHeight,
    child: CarouselItem(
      title: 'Fight Club',
      onTap: previewNoOp,
    ),
  );
}

@Preview(
  name: 'TMDB backdrop image',
  group: 'CarouselItem',
  size: Size(400, AppSpacing.carouselHeight),
  wrapper: moviesDarkScaffoldWrapper,
)
Widget carouselItemWithBackdropPreview() {
  return SizedBox(
    width: 400,
    height: AppSpacing.carouselHeight,
    child: CarouselItem(
      title: 'The Shawshank Redemption',
      backdropPath: '/iNh3B5HtxGfGK1R6B0a1wLm0Q2o.jpg',
      onTap: previewNoOp,
    ),
  );
}
