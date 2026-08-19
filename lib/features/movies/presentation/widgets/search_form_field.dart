import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../core/constants/app_typography.dart';
import 'widget_preview_support.dart';

/// Search text field embedded in the search screen app bar title slot.
///
/// Ported from reference `lib/widgets/search_form_field.dart`.
/// The screen passes a localized [placeholder] via `.tr()`.
class SearchFormField extends StatelessWidget {
  const SearchFormField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.placeholder,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: placeholder,
        border: InputBorder.none,
        hintStyle: AppTypography.searchField,
      ),
      style: AppTypography.searchField,
    );
  }
}

// ---------------------------------------------------------------------------
// @Preview — run: flutter widget-preview start
// ---------------------------------------------------------------------------

@Preview(
  name: 'In app bar title',
  group: 'SearchFormField',
  wrapper: moviesAppBarPreviewWrapper,
)
Widget searchFormFieldAppBarPreview() {
  return const _SearchFormFieldPreviewHost();
}

/// Holds a [TextEditingController] for widget previews only.
class _SearchFormFieldPreviewHost extends StatefulWidget {
  const _SearchFormFieldPreviewHost();

  @override
  State<_SearchFormFieldPreviewHost> createState() =>
      _SearchFormFieldPreviewHostState();
}

class _SearchFormFieldPreviewHostState extends State<_SearchFormFieldPreviewHost> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchFormField(
      controller: _controller,
      onChanged: (_) {},
      placeholder: 'Search',
    );
  }
}
