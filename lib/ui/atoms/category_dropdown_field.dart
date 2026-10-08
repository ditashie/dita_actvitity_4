import 'package:flutter/material.dart';

/// Atom: a thin wrapper around `DropdownButtonFormField<String>`. Takes
/// the current value, the list of choices, a label, and an onChanged
/// callback, and renders itself. It doesn't decide what the category
/// choices are (that list is passed in) or what happens when one is
/// picked — it just reports the change upward.
class CategoryDropdownField extends StatelessWidget {
  final String value;
  final List<String> categories;
  final String label;
  final ValueChanged<String?> onChanged;

  const CategoryDropdownField({
    super.key,
    required this.value,
    required this.categories,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: categories
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
