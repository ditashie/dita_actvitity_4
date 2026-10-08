import 'package:flutter/material.dart';

/// Atom: the one bold, size-20 heading style used four times in the
/// starter — the AppBar title ("Messy Catalog", white) and the three
/// section headings ("Search Products", "Catalog", "Add New Product",
/// black87). Same TextStyle, different string and color, so one atom
/// with a [color] parameter replaces four hand-written Text widgets.
/// Takes a string and a color, renders styled Text — no logic.
class HeadingText extends StatelessWidget {
  final String text;
  final Color color;

  const HeadingText(this.text, {super.key, this.color = Colors.black87});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    );
  }
}
