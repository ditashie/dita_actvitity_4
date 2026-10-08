import 'package:flutter/material.dart';

/// Atom: a product's name, styled. Takes a string, renders Text.
class ProductNameText extends StatelessWidget {
  final String name;
  const ProductNameText(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
