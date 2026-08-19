import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import 'widget_preview_support.dart';

/// Home screen app bar with search and settings actions.
///
/// Ported from reference `lib/widgets/custom_appbar.dart`.
/// [title] comes from the screen (localized via `.tr()` in Step 3).
/// [onSearchPressed] is wired to search navigation in Step 3.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showSearchButton = true,
    this.onSearchPressed,
    this.onSettingsPressed,
  });

  final String title;
  final bool showSearchButton;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onSettingsPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      elevation: 0,
      leading: const Icon(Icons.motion_photos_on_rounded),
      actions: [
        if (showSearchButton)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearchPressed,
          ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: onSettingsPressed,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// @Preview — run: flutter widget-preview start
// ---------------------------------------------------------------------------

@Preview(
  name: 'Default with search',
  group: 'CustomAppBar',
  wrapper: moviesAppBarPreviewWrapper,
)
Widget customAppBarDefaultPreview() {
  return const CustomAppBar(title: 'Movie DB');
}

@Preview(
  name: 'Without search button',
  group: 'CustomAppBar',
  wrapper: moviesAppBarPreviewWrapper,
)
Widget customAppBarNoSearchPreview() {
  return const CustomAppBar(
    title: 'Movie DB',
    showSearchButton: false,
  );
}
