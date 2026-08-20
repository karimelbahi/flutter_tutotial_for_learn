import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import 'widget_preview_support.dart';

/// Search text field with a filled bar, search icon, and optional clear action.
///
/// Used on the search screen app bar — the hint uses secondary styling so it
/// reads as placeholder text, not a static title.
class SearchFormField extends StatelessWidget {
  const SearchFormField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.placeholder,
    this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String placeholder;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final hasText = controller.text.isNotEmpty;

        return Container(
          height: AppSpacing.searchBarHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.martinique,
            borderRadius: BorderRadius.circular(AppSpacing.searchBarRadius),
            border: Border.all(color: AppColors.divider),
          ),
          child: TextField(
            autofocus: true,
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            cursorColor: AppColors.textPrimary,
            style: AppTypography.searchField,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 22,
                color: AppColors.textSecondary,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: AppSpacing.searchBarHeight,
              ),
              suffixIcon: hasText && onClear != null
                  ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: AppSpacing.searchBarHeight,
                      ),
                      onPressed: onClear,
                      tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
                    )
                  : null,
              hintText: placeholder,
              hintStyle: AppTypography.searchFieldHint,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// @Preview — run: flutter widget-preview start
// ---------------------------------------------------------------------------

@Preview(
  name: 'Empty search bar',
  group: 'SearchFormField',
  wrapper: moviesFullWidthWrapper,
)
Widget searchFormFieldEmptyPreview() {
  return const _SearchFormFieldPreviewHost();
}

@Preview(
  name: 'With query text',
  group: 'SearchFormField',
  wrapper: moviesFullWidthWrapper,
)
Widget searchFormFieldWithTextPreview() {
  return const _SearchFormFieldPreviewHost(initialText: 'Batman');
}

/// Holds a [TextEditingController] for widget previews only.
class _SearchFormFieldPreviewHost extends StatefulWidget {
  const _SearchFormFieldPreviewHost({this.initialText = ''});

  final String initialText;

  @override
  State<_SearchFormFieldPreviewHost> createState() =>
      _SearchFormFieldPreviewHostState();
}

class _SearchFormFieldPreviewHostState extends State<_SearchFormFieldPreviewHost> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.searchBarHorizontalPadding,
      ),
      child: SearchFormField(
        controller: _controller,
        onChanged: (_) {},
        placeholder: 'Search movies...',
        onClear: () => _controller.clear(),
      ),
    );
  }
}
