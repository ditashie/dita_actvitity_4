import 'package:flutter/material.dart';

/// Atom: the search input. Intentionally has NO TextEditingController,
/// matching the starter exactly — the starter's search `TextField` was
/// never bound to a controller, only to `onChanged`. That's a real quirk
/// worth preserving: because nothing clears this field's own displayed
/// text, resetting the search query elsewhere in the app (see the Page's
/// submit handler) changes what's *filtered* without visually clearing
/// this box. Reproducing that quirk faithfully was part of "must match
/// behavior exactly," so this atom stays uncontrolled on purpose rather
/// than "fixing" it.
class SearchTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchTextField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: 'Type a product name...',
      ),
    );
  }
}
