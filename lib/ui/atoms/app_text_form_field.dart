import 'package:flutter/material.dart';

/// Atom: a thin wrapper around Flutter's own `TextFormField`, reused for
/// the Name, Price, and Description fields (each with different label,
/// keyboard type, line count, and validator). This widget renders based
/// purely on the props it's given; it never runs the validator itself —
/// that closure is supplied from outside and invoked by Flutter's own
/// FormState machinery when `.validate()` is called, so no logic lives
/// inside this widget's own code. Passing `validator: null` (as the
/// Description field does below) exactly reproduces the starter, where
/// the description TextFormField had no `validator:` argument at all.
class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool alignLabelWithHint;
  final FormFieldValidator<String>? validator;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.maxLines = 1,
    this.alignLabelWithHint = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: alignLabelWithHint,
      ),
      validator: validator,
    );
  }
}
