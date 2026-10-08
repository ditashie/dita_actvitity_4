import 'package:flutter/material.dart';

/// Atom: the one indigo-background, white-foreground ElevatedButton style
/// the starter uses twice — "Add to Cart" (default text style, not full
/// width) and "Submit Product" (bold white 16, full width, extra vertical
/// padding). One parameterized atom replaces both hand-written buttons;
/// it takes a label and a callback and renders itself, with no idea what
/// pressing it will actually do.
class FilledActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool fullWidth;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const FilledActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = false,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        padding: padding,
      ),
      child: Text(label, style: textStyle),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
