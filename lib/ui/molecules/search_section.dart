import 'package:flutter/material.dart';
import '../atoms/heading_text.dart';
import '../atoms/search_text_field.dart';

/// Molecule: groups the "Search Products" HeadingText atom with the
/// SearchTextField atom into one reusable "labeled search box" unit —
/// two atoms functioning together for a single purpose. It forwards
/// changes upward via [onSearchChanged] and doesn't know what the
/// results of a search are or where the product list lives.
class SearchSection extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  const SearchSection({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingText('Search Products'),
        const SizedBox(height: 8),
        SearchTextField(onChanged: onSearchChanged),
      ],
    );
  }
}
