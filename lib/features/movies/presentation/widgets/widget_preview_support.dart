import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Shared wrappers for `@Preview` annotations (Flutter Widget Previewer).
///
/// Wrappers must be **top-level functions** — same idea as a Compose preview
/// `@Preview` host with MaterialTheme.
///
/// Run previews:
/// ```bash
/// flutter widget-preview start
/// ```
/// Then open the URL, or use "Filter previews by selected file" in the IDE.

/// No-op tap handler — preview annotations require static callbacks.
void previewNoOp() {}

/// Dark scaffold wrapper for most movie widgets.
Widget moviesDarkScaffoldWrapper(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    home: Scaffold(
      backgroundColor: AppColors.primary,
      body: Align(
        alignment: Alignment.center,
        child: child,
      ),
    ),
  );
}

/// Puts an app bar preview widget into a full [Scaffold].
Widget moviesAppBarPreviewWrapper(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    home: Scaffold(
      backgroundColor: AppColors.primary,
      appBar: child as PreferredSizeWidget,
      body: const SizedBox.shrink(),
    ),
  );
}

/// Full-width wrapper for headers and list rows.
Widget moviesFullWidthWrapper(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    home: Scaffold(
      backgroundColor: AppColors.primary,
      body: SizedBox(
        width: double.infinity,
        child: child,
      ),
    ),
  );
}
